#import "VideoFeedViewController.h"
#import "VideoModel.h"
#import "VideoPlayerCollectionCell.h"
#import <Masonry/Masonry.h>
#import <MJRefresh/MJRefresh.h>
#import "NetworkManager.h"
#import <AVKit/AVKit.h>

@interface VideoFeedViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<VideoModel *> *videos;
@end

@implementation VideoFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频";
    self.view.backgroundColor = [UIColor blackColor];
    self.videos = [NSMutableArray array];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = UIScreen.mainScreen.bounds.size;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[VideoPlayerCollectionCell class] forCellWithReuseIdentifier:@"VideoPlayerCell"];
    [self.view addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadMockVideosRefresh:YES];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMockVideosRefresh:NO];
    }];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFullscreenRequest:) name:@"VideoCellRequestFullscreen" object:nil];

    [self.collectionView.mj_header beginRefreshing];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleFullscreenRequest:(NSNotification *)note {
    AVPlayer *player = note.object;
    if (!player) return;
    AVPlayerViewController *vc = [[AVPlayerViewController alloc] init];
    vc.player = player;
    [self presentViewController:vc animated:YES completion:^{
        [player play];
    }];
}

- (void)loadMockVideosRefresh:(BOOL)refresh {
    if (refresh) [self.videos removeAllObjects];
    NSArray *samples = @[
        @{@"title":@"城市夜景",@"author":@"KooJoke",@"coverUrl":@"https://images.unsplash.com/photo-1493246507139-91e8fad9978e?auto=format&fit=crop&w=800&q=80",@"videoUrl":@"https://www.w3schools.com/html/mov_bbb.mp4"},
        @{@"title":@"夏日海边",@"author":@"小鹿",@"coverUrl":@"https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80",@"videoUrl":@"https://www.w3schools.com/html/movie.mp4"},
        @{@"title":@"搞笑片段",@"author":@"开心树",@"coverUrl":@"https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&w=800&q=80",@"videoUrl":@"https://www.w3schools.com/html/mov_bbb.mp4"}
    ];
    for (NSDictionary *d in samples) {
        [self.videos addObject:[VideoModel modelWithDict:d]];
    }
    [self.collectionView reloadData];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self playVisibleCell];
    });
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.videos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VideoPlayerCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"VideoPlayerCell" forIndexPath:indexPath];
    [cell configureWithModel:self.videos[indexPath.item]];
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self playVisibleCell];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) [self playVisibleCell];
}

- (void)playVisibleCell {
    NSArray *visible = [self.collectionView indexPathsForVisibleItems];
    if (visible.count == 0) return;
    NSIndexPath *target = nil;
    CGFloat centerY = CGRectGetMidY(self.collectionView.bounds);
    CGFloat best = CGFLOAT_MAX;
    for (NSIndexPath *ip in visible) {
        CGRect cellRect = [self.collectionView layoutAttributesForItemAtIndexPath:ip].frame;
        CGFloat delta = fabs(CGRectGetMidY(cellRect) - centerY);
        if (delta < best) { best = delta; target = ip; }
    }
    for (NSIndexPath *ip in visible) {
        VideoPlayerCollectionCell *cell = (VideoPlayerCollectionCell *)[self.collectionView cellForItemAtIndexPath:ip];
        if ([ip isEqual:target]) [cell play];
        else [cell pause];
    }
}

@end
