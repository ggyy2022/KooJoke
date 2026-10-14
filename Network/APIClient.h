#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APIClient : NSObject
+ (instancetype)sharedClient;
- (void)fetchJokesPage:(NSInteger)page success:(void(^)(id data))success failure:(void(^)(NSError *error))failure;
- (void)fetchVideoFeedWithSuccess:(void(^)(id data))success failure:(void(^)(NSError *error))failure;
- (void)fetchImagesPage:(NSInteger)page success:(void(^)(id data))success failure:(void(^)(NSError *error))failure;
@end

NS_ASSUME_NONNULL_END
