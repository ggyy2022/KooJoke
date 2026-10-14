#import <Foundation/Foundation.h>

@interface VideoModel : NSObject
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) NSString *coverUrl;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *author;
+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end
