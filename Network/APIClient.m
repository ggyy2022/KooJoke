#import "APIClient.h"
#import "NetworkManager.h"

@implementation APIClient

+ (instancetype)sharedClient {
    static APIClient *c;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        c = [[APIClient alloc] init];
    });
    return c;
}

- (void)fetchJokesPage:(NSInteger)page success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *path = [NSString stringWithFormat:@"jokes?page=%ld", (long)page];
    [[NetworkManager sharedManager] GET:path params:nil success:success failure:failure];
}

- (void)fetchVideoFeedWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *path = @"videos/list";
    [[NetworkManager sharedManager] GET:path params:nil success:success failure:failure];
}

- (void)fetchImagesPage:(NSInteger)page success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *path = [NSString stringWithFormat:@"images?page=%ld", (long)page];
    [[NetworkManager sharedManager] GET:path params:nil success:success failure:failure];
}

@end
