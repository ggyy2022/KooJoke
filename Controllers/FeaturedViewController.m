#import "FeaturedViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <Masonry/Masonry.h>

@implementation FeaturedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"精选";
    self.view.backgroundColor = [UIColor whiteColor];

    NSArray *images = @[
        @"https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&w=1200&q=80",
        @"https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80",
        @"https://images.unsplash.com/photo-1493246507139-91e8fad9978e?auto=format&fit=crop&w=1200&q=80"
    ];

    SDCycleScrollView *banner = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero delegate:nil placeholderImage:nil];
    banner.localizationImageNamesGroup = images;
    banner.autoScrollTimeInterval = 3;
    [self.view addSubview:banner];

    [banner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(180);
    }];
}

@end
