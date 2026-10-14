#import "VideoPlayerCollectionCell.h"
#import "VideoModel.h"
#import <AVFoundation/AVFoundation.h>
#import <SDWebImage/SDWebImage.h>
#import <Masonry/Masonry.h>

@interface VideoPlayerCollectionCell()
@property (nonatomic, strong) UIImageView *coverView;
@property (nonatomic, strong) UIView *playerContainer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *fullscreenBtn;
@end

@implementation VideoPlayerCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _playerContainer = [[UIView alloc] init];
        _playerContainer.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:_playerContainer];

        _coverView = [[UIImageView alloc] init];
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
        _coverView.clipsToBounds = YES;
        [_playerContainer addSubview:_coverView];

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [self.contentView addSubview:_titleLabel];

        _fullscreenBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_fullscreenBtn setImage:[UIImage systemImageNamed:@"arrow.up.left.and.arrow.down.right"] forState:UIControlStateNormal];
        _fullscreenBtn.tintColor = [UIColor whiteColor];
        [self.contentView addSubview:_fullscreenBtn];

        __weak typeof(self) weakSelf = self;
        [_fullscreenBtn addTarget:weakSelf action:@selector(fullscreenTapped) forControlEvents:UIControlEventTouchUpInside];

        [_playerContainer mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [_coverView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_playerContainer);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(12);
            make.bottom.equalTo(self.contentView).offset(-20);
            make.right.equalTo(self.contentView).offset(-60);
        }];
        [_fullscreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-12);
            make.bottom.equalTo(self.contentView).offset(-20);
            make.width.height.mas_equalTo(36);
        }];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.player pause];
    [self.playerLayer removeFromSuperlayer];
    self.player = nil;
    self.playerLayer = nil;
    self.coverView.image = nil;
}

- (void)configureWithModel:(VideoModel *)model {
    self.titleLabel.text = model.title;
    [self.coverView sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:nil];
    // setup player but do not play yet
    if (model.videoUrl.length) {
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.videoUrl]];
        self.player = [AVPlayer playerWithPlayerItem:item];
        self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        self.playerLayer.frame = self.playerContainer.bounds;
        [self.playerContainer.layer insertSublayer:self.playerLayer above:0];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.playerContainer.bounds;
}

- (void)play {
    if (self.player) {
        [self.player play];
        self.coverView.hidden = YES;
    }
}

- (void)pause {
    if (self.player) {
        [self.player pause];
        self.coverView.hidden = NO;
    }
}

- (void)fullscreenTapped {
    // Post notification so controller can present AVPlayerViewController
    [[NSNotificationCenter defaultCenter] postNotificationName:@"VideoCellRequestFullscreen" object:self.player];
}

@end
