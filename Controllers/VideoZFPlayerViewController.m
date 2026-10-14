#import "VideoZFPlayerViewController.h"
#import <Masonry/Masonry.h>
#import "VideoModel.h"
#import <ZFPlayer/ZFPlayerController.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>

@interface VideoZFPlayerViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<VideoModel *> *videos;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@end

@implementation VideoZFPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.title = @"视频";
    self.videos = [NSMutableArray array];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = UIScreen.mainScreen.bounds.size;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsZero;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.backgroundColor = [UIColor blackColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"playerCell"];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) { make.edges.equalTo(self.view); }];

    // ZFPlayer setup
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    self.controlView = [[ZFPlayerControlView alloc] init];
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:nil];
    self.player.controlView = self.controlView;
    self.player.shouldAutoPlay = YES;
    self.player.disableGestureTypes = ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesDoubleTap;

    [self loadMockData];
}

- (void)loadMockData {
    NSArray *samples = @[
        @{@"title":@"城市夜景",@"author":@"KooJoke",@"coverUrl":@"https://images.unsplash.com/photo-1493246507139-91e8fad9978e?auto=format&fit=crop&w=800&q=80",@"videoUrl":@"https://www.w3schools.com/html/mov_bbb.mp4"},
        @{@"title":@"夏日海边",@"author":@"小鹿",@"coverUrl":@"https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",@"videoUrl":@"https://www.w3schools.com/html/movie.mp4"},
        @{@"title":@"搞笑片段",@"author":@"开心树",@"coverUrl":@"https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&w=800&q=80",@"videoUrl":@"https://www.w3schools.com/html/mov_bbb.mp4"}
    ];
    for (NSDictionary *d in samples) {
        [self.videos addObject:[VideoModel modelWithDict:d]];
    }
    [self.collectionView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playCurrentIndex:0];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { return self.videos.count; }

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"playerCell" forIndexPath:indexPath];
    // container for player
    UIView *container = [cell.contentView viewWithTag:1001];
    if (!container) {
        container = [[UIView alloc] initWithFrame:cell.contentView.bounds];
        container.tag = 1001;
        container.backgroundColor = [UIColor blackColor];
        container.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:container];

        UIImageView *cover = [[UIImageView alloc] initWithFrame:container.bounds];
        cover.contentMode = UIViewContentModeScaleAspectFill;
        cover.clipsToBounds = YES;
        cover.tag = 1002;
        cover.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [container addSubview:cover];
    }
    VideoModel *m = self.videos[indexPath.item];
    UIImageView *cover = [cell.contentView viewWithTag:1002];
    [cover sd_setImageWithURL:[NSURL URLWithString:m.coverUrl] placeholderImage:nil];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = round(scrollView.contentOffset.y / scrollView.bounds.size.height);
    [self playCurrentIndex:index];
}

- (void)playCurrentIndex:(NSInteger)index {
    if (index < 0 || index >= self.videos.count) return;
    VideoModel *m = self.videos[index];
    NSIndexPath *ip = [NSIndexPath indexPathForItem:index inSection:0];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:ip];
    UIView *container = [cell.contentView viewWithTag:1001];
    if (!container) return;
    self.player.containerView = container;
    [self.player playTheIndex:index assetURL:[NSURL URLWithString:m.videoUrl]];
}

@end
