#import "JokesViewController.h"
#import "JokeTableViewCell.h"
#import "JokeModel.h"
#import "NetworkManager.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>

@interface JokesViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<JokeModel *> *data;
@property (nonatomic, assign) NSInteger page;
@end

@implementation JokesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"笑话";
    self.view.backgroundColor = [UIColor whiteColor];
    self.data = [NSMutableArray array];
    self.page = 1;

    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[JokeTableViewCell class] forCellReuseIdentifier:@"JokeCell"];
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf loadDataRefresh:YES];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page += 1;
        [weakSelf loadDataRefresh:NO];
    }];

    [self.tableView.mj_header beginRefreshing];
}

- (void)loadDataRefresh:(BOOL)isRefresh {
    // 示例使用 mock remote: you can replace with your API
    NSString *url = @"https://api.example.com/jokes"; // replace with real API
    __weak typeof(self) weakSelf = self;
    [[NetworkManager sharedManager] GET:url params:@{@"page": @(self.page)} success:^(id response) {
        NSArray *arr = response[@"data"];
        if (![arr isKindOfClass:[NSArray class]]) arr = nil;
        if (isRefresh) [weakSelf.data removeAllObjects];
        if (arr.count) {
            for (NSDictionary *d in arr) {
                [weakSelf.data addObject:[JokeModel modelWithDict:d]];
            }
        } else {
            for (int i = 0; i < 10; i++) {
                NSDictionary *d = @{@"id": @(weakSelf.data.count + i + 1),
                                    @"title": [NSString stringWithFormat:@"笑话标题 %ld", (long)(weakSelf.data.count + i + 1)],
                                    @"content": @"这是一个示例笑话内容，纯属示例。可以替换为你的接口返回内容。",
                                    @"author": @"KooJoke",
                                    @"time": @"刚刚"};
                [weakSelf.data addObject:[JokeModel modelWithDict:d]];
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        if (isRefresh) {
            [weakSelf.data removeAllObjects];
            weakSelf.page = 1;
        }
        for (int i = 0; i < 10; i++) {
            NSDictionary *d = @{@"id": @(weakSelf.data.count + i + 1),
                                @"title": [NSString stringWithFormat:@"本地示例笑话 %ld", (long)(weakSelf.data.count + i + 1)],
                                @"content": @"网络请求失败，使用本地示例。替换 NetworkManager URL 可接入真实接口。",
                                @"author": @"KooJoke",
                                @"time": @"刚刚"};
            [weakSelf.data addObject:[JokeModel modelWithDict:d]];
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - Table

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JokeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JokeCell" forIndexPath:indexPath];
    [cell configureWithModel:self.data[indexPath.row]];
    return cell;
}

@end
