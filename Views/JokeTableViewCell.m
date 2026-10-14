#import "JokeTableViewCell.h"
#import "JokeModel.h"
#import <Masonry/Masonry.h>

@interface JokeTableViewCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *metaLabel;
@end

@implementation JokeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:_titleLabel];

        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];

        _metaLabel = [[UILabel alloc] init];
        _metaLabel.font = [UIFont systemFontOfSize:12];
        _metaLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_metaLabel];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self.contentView).offset(12);
            make.right.equalTo(self.contentView).offset(-12);
        }];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_bottom).offset(8);
            make.left.right.equalTo(_titleLabel);
        }];
        [_metaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_contentLabel.mas_bottom).offset(8);
            make.left.right.equalTo(_titleLabel);
            make.bottom.equalTo(self.contentView).offset(-12);
        }];
    }
    return self;
}

- (void)configureWithModel:(JokeModel *)model {
    self.titleLabel.text = model.title.length ? model.title : @"";
    self.contentLabel.text = model.content;
    self.metaLabel.text = [NSString stringWithFormat:@"%@  %@", model.author, model.time ?: @""];
}
@end
