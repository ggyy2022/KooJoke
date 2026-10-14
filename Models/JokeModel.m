#import "JokeModel.h"

@implementation JokeModel
+ (instancetype)modelWithDict:(NSDictionary *)dict {
    JokeModel *m = [[JokeModel alloc] init];
    m.jid = [NSString stringWithFormat:@"%@", dict[@"id"] ?: dict[@"jid"] ?: @""];
    m.title = dict[@"title"] ?: @"";
    m.content = dict[@"content"] ?: dict[@"text"] ?: @"";
    m.author = dict[@"author"] ?: @"匿名";
    m.time = dict[@"time"] ?: @"";
    return m;
}
@end
