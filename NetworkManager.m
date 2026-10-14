#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>

@interface NetworkManager()
@property (nonatomic, strong) AFHTTPSessionManager *mgr;
@end

@implementation NetworkManager

+ (instancetype)sharedManager {
    static NetworkManager *s;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        s = [[NetworkManager alloc] init];
        s.mgr = [AFHTTPSessionManager manager];
        s.mgr.requestSerializer = [AFJSONRequestSerializer serializer];
        s.mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        s.mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", nil];
    });
    return s;
}

- (void)GET:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    [self.mgr GET:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) failure(error);
    }];
}
@end
