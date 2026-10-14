#import <Foundation/Foundation.h>

@interface JokeModel : NSObject
@property (nonatomic, copy) NSString *jid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *time;
+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end
