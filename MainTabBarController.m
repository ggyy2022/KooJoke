#import "MainTabBarController.h"
#import "JokesViewController.h"
#import "VideoFeedViewController.h"
#import "GirlsViewController.h"
#import "FeaturedViewController.h"

@implementation MainTabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
        JokesViewController *jokesVC = [[JokesViewController alloc] init];
        UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:jokesVC];
        nav1.tabBarItem.title = @"笑话";
        nav1.tabBarItem.image = [UIImage systemImageNamed:@"text.bubble"];

        VideoFeedViewController *videoVC = [[VideoFeedViewController alloc] init];
        UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:videoVC];
        nav2.tabBarItem.title = @"视频";
        nav2.tabBarItem.image = [UIImage systemImageNamed:@"play.rectangle"];

        GirlsViewController *girlsVC = [[GirlsViewController alloc] init];
        UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:girlsVC];
        nav3.tabBarItem.title = @"妹子";
        nav3.tabBarItem.image = [UIImage systemImageNamed:@"photo"];

        FeaturedViewController *featuredVC = [[FeaturedViewController alloc] init];
        UINavigationController *nav4 = [[UINavigationController alloc] initWithRootViewController:featuredVC];
        nav4.tabBarItem.title = @"精选";
        nav4.tabBarItem.image = [UIImage systemImageNamed:@"sparkles"];

        self.viewControllers = @[nav1, nav2, nav3, nav4];
    }
    return self;
}
@end
