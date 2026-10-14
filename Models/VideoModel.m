#import "VideoModel.h"

@implementation VideoModel
+ (instancetype)modelWithDict:(NSDictionary *)dict {
    VideoModel *m = [[VideoModel alloc] init];
    m.videoUrl = dict[@"videoUrl"] ?: dict[@"url"] ?: @"";
    m.coverUrl = dict[@"coverUrl"] ?: dict[@"cover"] ?: @"";
    m.title = dict[@"title"] ?: @"";
    m.author = dict[@"author"] ?: @"";
    return m;
}
@end
