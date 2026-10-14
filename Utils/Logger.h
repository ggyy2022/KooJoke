#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Logger : NSObject
+ (instancetype)sharedLogger;
- (void)logRequestWithMethod:(NSString *)method url:(NSString *)url params:(NSDictionary *)params;
- (void)logResponse:(id)response;
- (void)logError:(NSError *)error;
@end

NS_ASSUME_NONNULL_END
