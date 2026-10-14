#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject
+ (instancetype)sharedManager;
- (void)GET:(NSString *)url params:(nullable NSDictionary *)params success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
