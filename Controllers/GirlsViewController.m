#import "GirlsViewController.h"
#import "GirlsCollectionViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import "BigImageViewController.h"

@interface GirlsViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<NSString *> *imageUrls;
@property (nonatomic, strong) NSMutableArray<NSString *> *titles;
@end

@implementation GirlsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"妹子";
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.imageUrls = [NSMutableArray array];
    self.titles = [NSMutableArray array];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 12;
    layout.minimumInteritemSpacing = 12;
    layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.collectionView registerClass:[GirlsCollectionViewCell class] forCellWithReuseIdentifier:@"GirlsCell"];
    [self.view addSubview:self.collectionView];

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadMock:YES];
    }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMock:NO];
    }];

    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadMock:(BOOL)refresh {
    if (refresh) {
        [self.imageUrls removeAllObjects];
        [self.titles removeAllObjects];
    }
    NSArray *samples = @[
        @"https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80",
        @"https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=800&q=80",
        @"https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=800&q=80",
        @"https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=80",
        @"https://images.unsplash.com/photo-1521119989659-a83eee488004?auto=format&fit=crop&w=800&q=80",
        @"https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=800&q=80"
    ];
    for (int i = 0; i < samples.count; i++) {
        [self.imageUrls addObject:samples[i]];
        [self.titles addObject:[NSString stringWithFormat:@"风格 %d", (int)(self.imageUrls.count)]];
    }
    [self.collectionView reloadData];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageUrls.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GirlsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GirlsCell" forIndexPath:indexPath];
    [cell configWithURL:self.imageUrls[indexPath.item] title:self.titles[indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)layout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.view.bounds.size.width - 12*3) / 2.0;
    return CGSizeMake(width, width * 1.35);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BigImageViewController *big = [[BigImageViewController alloc] initWithImageURLs:self.imageUrls startIndex:indexPath.item];
    big.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:big animated:YES completion:nil];
}

@end
