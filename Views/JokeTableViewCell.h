#import <UIKit/UIKit.h>
@class JokeModel;

@interface JokeTableViewCell : UITableViewCell
- (void)configureWithModel:(JokeModel *)model;
@end
