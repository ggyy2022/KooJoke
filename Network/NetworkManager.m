#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import "Logger.h"

@interface NetworkManager()
@property (nonatomic, strong) AFHTTPSessionManager *mgr;
@property (nonatomic, strong) AFNetworkReachabilityManager *reachability;
@end

@implementation NetworkManager

+ (instancetype)sharedManager {
    static NetworkManager *s;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        s = [[NetworkManager alloc] init];
        s.baseURL = @"https://api.example.com"; // customize
        s.timeoutInterval = 15.0;
        s.mgr = [AFHTTPSessionManager manager];
        s.mgr.requestSerializer = [AFJSONRequestSerializer serializer];
        s.mgr.responseSerializer = [AFJSONResponseSerializer serializer];
        s.mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html", @"text/plain", nil];
        s.mgr.requestSerializer.timeoutInterval = s.timeoutInterval;
        s.reachability = [AFNetworkReachabilityManager sharedManager];
        [s.reachability startMonitoring];
    });
    return s;
}

- (void)GET:(NSString *)path params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *url = [self absoluteURL:path];
    if (self.reachability.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        NSError *err = [NSError errorWithDomain:@"Network" code:-1009 userInfo:@{NSLocalizedDescriptionKey: @"No network"}];
        if (failure) failure(err);
        return;
    }
    [[Logger sharedLogger] logRequestWithMethod:@"GET" url:url params:params];
    [self.mgr GET:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[Logger sharedLogger] logResponse:responseObject];
        if (success) success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[Logger sharedLogger] logError:error];
        if (failure) failure(error);
    }];
}

- (void)POST:(NSString *)path params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *url = [self absoluteURL:path];
    if (self.reachability.networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable) {
        NSError *err = [NSError errorWithDomain:@"Network" code:-1009 userInfo:@{NSLocalizedDescriptionKey: @"No network"}];
        if (failure) failure(err);
        return;
    }
    [[Logger sharedLogger] logRequestWithMethod:@"POST" url:url params:params];
    [self.mgr POST:url parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[Logger sharedLogger] logResponse:responseObject];
        if (success) success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[Logger sharedLogger] logError:error];
        if (failure) failure(error);
    }];
}

- (NSString *)absoluteURL:(NSString *)path {
    if ([path hasPrefix:@"http"]) return path;
    return [NSString stringWithFormat:@"%@/%@", self.baseURL, [path stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]]];
}

@end
