#import "Theme.h"

@implementation Theme

+ (UIColor *)primaryColor {
    return [UIColor colorWithRed:1.0 green:107/255.0 blue:107/255.0 alpha:1.0]; // #FF6B6B
}

+ (void)applyGlobalAppearance {
    UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
    [appearance configureWithOpaqueBackground];
    appearance.backgroundColor = [Theme primaryColor];
    appearance.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [UINavigationBar appearance].standardAppearance = appearance;
    [UINavigationBar appearance].scrollEdgeAppearance = appearance;
    [UITabBar appearance].tintColor = [Theme primaryColor];
}

@end
