#import <UIKit/UIKit.h>
@class VideoModel;

@interface VideoPlayerCollectionCell : UICollectionViewCell
- (void)configureWithModel:(VideoModel *)model;
- (void)play;
- (void)pause;
@end
