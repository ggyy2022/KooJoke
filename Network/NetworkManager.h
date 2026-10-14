#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : NSObject
+ (instancetype)sharedManager;

@property (nonatomic, copy) NSString *baseURL;
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

- (void)GET:(NSString *)path params:(nullable NSDictionary *)params success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
- (void)POST:(NSString *)path params:(nullable NSDictionary *)params success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
