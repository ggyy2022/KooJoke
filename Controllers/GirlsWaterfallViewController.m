#import "GirlsWaterfallViewController.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "GirlsCollectionViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import "BigImageViewController.h"

@interface GirlsWaterfallViewController () <UICollectionViewDelegate, UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<NSString *> *imageUrls;
@end

@implementation GirlsWaterfallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"妹子";
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.imageUrls = [NSMutableArray array];

    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.columnCount = 2;
    layout.minimumColumnSpacing = 12;
    layout.minimumInteritemSpacing = 12;
    layout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    [self.collectionView registerClass:[GirlsCollectionViewCell class] forCellWithReuseIdentifier:@"GirlsCell"];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) { make.edges.equalTo(self.view); }];

    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{ [weakSelf loadMock:YES]; }];
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{ [weakSelf loadMock:NO]; }];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)loadMock:(BOOL)refresh {
    if (refresh) [self.imageUrls removeAllObjects];
    NSArray *samples = @[
        @"https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=800&q=80",
        @"https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=800&q=80",
        @"https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=800&q=80",
        @"https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=800&q=80",
        @"https://images.unsplash.com/photo-1521119989659-a83eee488004?auto=format&fit=crop&w=800&q=80",
        @"https://images.unsplash.com/photo-1521572267360-ee0c2909d518?auto=format&fit=crop&w=800&q=80"
    ];
    for (NSString *s in samples) { [self.imageUrls addObject:s]; }
    [self.collectionView reloadData];
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}

#pragma mark - UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { return self.imageUrls.count; }
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GirlsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GirlsCell" forIndexPath:indexPath];
    [cell configWithURL:self.imageUrls[indexPath.item] title:@""];
    // long press to save
    UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:lp];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(CHTCollectionViewWaterfallLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.view.bounds.size.width - 12*3)/2.0;
    // random height ratio to simulate masonry
    CGFloat ratio = 1.0 + (arc4random_uniform(40) / 100.0);
    return CGSizeMake(width, width * ratio);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BigImageViewController *big = [[BigImageViewController alloc] initWithImageURLs:self.imageUrls startIndex:indexPath.item];
    big.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:big animated:YES completion:nil];
}

- (void)longPress:(UILongPressGestureRecognizer *)g {
    if (g.state != UIGestureRecognizerStateBegan) return;
    UIView *v = g.view;
    NSIndexPath *ip = [self.collectionView indexPathForCell:(UICollectionViewCell *)v];
    if (!ip) return;
    NSString *url = self.imageUrls[ip.item];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [ac addAction:[UIAlertAction actionWithTitle:@"保存图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // download
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:url] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *img = [UIImage imageWithData:data];
                if (img) UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil);
            }
        }];
        [task resume];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}

@end
