#import "BigImageViewController.h"
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>

@interface BigImageViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) NSArray<NSString *> *urls;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UIScrollView *pagingScroll;
@end

@implementation BigImageViewController

- (instancetype)initWithImageURLs:(NSArray<NSString *> *)urls startIndex:(NSInteger)index {
    self = [super init];
    if (self) {
        _urls = urls;
        _currentIndex = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    UIButton *close = [UIButton buttonWithType:UIButtonTypeSystem];
    [close setTitle:@"关闭" forState:UIControlStateNormal];
    [close setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(dismissSelf) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
    [close mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(8);
        make.left.equalTo(self.view).offset(12);
    }];

    self.pagingScroll = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.pagingScroll.pagingEnabled = YES;
    self.pagingScroll.delegate = self;
    self.pagingScroll.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.pagingScroll];

    self.pagingScroll.contentSize = CGSizeMake(self.view.bounds.size.width * self.urls.count, self.view.bounds.size.height);
    for (int i = 0; i < self.urls.count; i++) {
        UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width * i, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        sv.minimumZoomScale = 1.0;
        sv.maximumZoomScale = 3.0;
        sv.delegate = self;
        sv.showsVerticalScrollIndicator = NO;
        sv.showsHorizontalScrollIndicator = NO;

        UIImageView *iv = [[UIImageView alloc] initWithFrame:sv.bounds];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        [iv sd_setImageWithURL:[NSURL URLWithString:self.urls[i]] placeholderImage:nil];
        iv.userInteractionEnabled = YES;
        [sv addSubview:iv];
        [self.pagingScroll addSubview:sv];
    }
    CGPoint p = CGPointMake(self.currentIndex * self.view.bounds.size.width, 0);
    [self.pagingScroll setContentOffset:p animated:NO];

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
}

- (void)doubleTap:(UITapGestureRecognizer *)g {
    CGPoint pt = [g locationInView:self.pagingScroll];
    NSInteger idx = round(pt.x / self.view.bounds.size.width);
    UIScrollView *sv = self.pagingScroll.subviews[idx];
    if (sv.zoomScale > 1.0) {
        [sv setZoomScale:1.0 animated:YES];
    } else {
        [sv setZoomScale:2.0 animated:YES];
    }
}

- (void)dismissSelf {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (scrollView == self.pagingScroll) return nil;
    for (UIView *v in scrollView.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) return v;
    }
    return nil;
}
@end
