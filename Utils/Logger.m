#import "Logger.h"

@implementation Logger

+ (instancetype)sharedLogger {
    static Logger *l;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        l = [[Logger alloc] init];
    });
    return l;
}

- (void)logRequestWithMethod:(NSString *)method url:(NSString *)url params:(NSDictionary *)params {
    NSLog(@"[Request] %@ %@ params: %@", method, url, params ?: @{});
}
- (void)logResponse:(id)response {
    NSLog(@"[Response] %@", response ?: @{});
}
- (void)logError:(NSError *)error {
    NSLog(@"[Error] %@", error);
}

@end
