//
//  BSJTopicVoiceView.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/24.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJTopicVoiceView.h"
#import "BSJTopicViewModel.h"
#import <M13ProgressViewRing.h>
#import "SUPAudioVoiceViewController.h"
#import "CFCDView.h"
#import <FSAudioStream.h>
#import <AVFoundation/AVFoundation.h>
#import <DALabeledCircularProgressView.h>

//typedef void(^butRef)(void);
@interface BSJTopicVoiceView ()

/** <#digest#> */
@property (weak, nonatomic) UIImageView *pictureImageView;

/** <#digest#> */
@property (weak, nonatomic) M13ProgressViewRing *ringProgressView;

/** <#digest#> */
@property (weak, nonatomic) UILabel *voicePlayCountLabel;

/** <#digest#> */
@property (weak, nonatomic) UILabel *voiceLengthLabel;

/** <#digest#> */
@property (weak, nonatomic) UIButton *voicePlayButton;

@property (strong, nonatomic) AVPlayerItem *playerItem;
@end

static AVPlayer * voice_player_;
static UIButton *lastPlayBtn_;
static BSJTopic *lastTopicM_;
static NSTimer *avTimer_;
static DALabeledCircularProgressView  *progressV_;

@implementation BSJTopicVoiceView



- (void)setupUIOnce
{
    
    self.pictureImageView.contentMode = UIViewContentModeScaleToFill;
    
    self.clipsToBounds = YES;
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.voicePlayButton.enabled = YES;
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIImage *logo = [UIImage imageNamed:@"imageBackground"];
    
    [logo drawAtPoint:CGPointMake((rect.size.width - logo.size.width) * 0.5, 5)];
   
    
}


- (void)setTopicViewModel:(BSJTopicViewModel *)topicViewModel
{
    _topicViewModel = topicViewModel;
    if (lastTopicM_ && ![_topicViewModel.topic.ID isEqualToString:lastTopicM_.ID]){
        progressV_.hidden = YES;
        [progressV_ removeFromSuperview];
    }
    
    
    // 1, playcount
    self.voicePlayCountLabel.text = [NSString stringWithFormat:@"%zd播放", topicViewModel.topic.playfcount];
    
    
    // 2, length
    self.voiceLengthLabel.text = topicViewModel.playLength;
    
    
    // 3, 处理进度,
    // 3.1 隐藏
    self.ringProgressView.hidden = (topicViewModel.downloadPictureProgress >= 1);
    
    // 3.2刷新进度立马
    [self.ringProgressView setProgress:topicViewModel.downloadPictureProgress animated:NO];
    
    [self.pictureImageView SUP_setImageWithURL:topicViewModel.topic.largePicture thumbnailImageURL:topicViewModel.topic.smallPicture placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetUrl) {
        
        // 3.3储存 "每个模型" 的进度
        topicViewModel.downloadPictureProgress = (CGFloat)receivedSize / expectedSize;
        
        
        // 3.4给每个cell对应的模型进度赋值
        [self.ringProgressView setProgress:self.topicViewModel.downloadPictureProgress animated:NO];
        
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        

        
    }];
    [self.voicePlayButton setImage:[UIImage imageNamed:topicViewModel.topic.voicePlaying ? @"playButtonPause":@"playButtonPlay"] forState:UIControlStateNormal];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.playerItem = [AVPlayerItem playerItemWithURL:self.topicViewModel.topic.voiceUrl];
        voice_player_ = [AVPlayer playerWithPlayerItem:self.playerItem];
        avTimer_ = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
        //[[NSRunLoop mainRunLoop] addTimer:avTimer_ forMode:NSRunLoopCommonModes];
        [avTimer_ setFireDate:[NSDate distantFuture]];
        
        progressV_ = [[DALabeledCircularProgressView alloc] initWithFrame:CGRectZero];
        progressV_.roundedCorners = YES;
        progressV_.progressLabel.textColor = [UIColor redColor];
        progressV_.trackTintColor = [UIColor clearColor];
        progressV_.progressTintColor = [UIColor redColor];
        progressV_.hidden = YES;
        progressV_.progressLabel.text = @"";
        progressV_.thicknessRatio = 0.1;
        [progressV_ setProgress:0 animated:NO];
        
    });
    if (topicViewModel.topic.voicePlaying){
        [self insertSubview:progressV_ belowSubview:self.voicePlayButton];
        progressV_.hidden = NO;
    }else{
        progressV_.hidden = YES;
    }
    
}
- (void)timer{
    //NSLog(@" --- progress --- ");
    Float64 currentTime = CMTimeGetSeconds(voice_player_.currentItem.currentTime);
    if (currentTime > 0){
        progressV_.hidden = NO;
        [progressV_ setProgress:currentTime / CMTimeGetSeconds(voice_player_.currentItem.duration) animated:YES];
        [progressV_.progressLabel setText:[NSString stringWithFormat:@"%.0f%%",progressV_.progress * 100]];
//        NSLog(@" --- progress %f --- ",progressV_.progress)
    }
}


#pragma mark - getter

- (UILabel *)voiceLengthLabel
{
    if(_voiceLengthLabel == nil)
    {
        UILabel *voiceLengthLabel = [[UILabel alloc] init];
        [self.pictureImageView addSubview:voiceLengthLabel];
        _voiceLengthLabel = voiceLengthLabel;
        
        voiceLengthLabel.textColor = [UIColor whiteColor];
        voiceLengthLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        voiceLengthLabel.font = [UIFont systemFontOfSize:12];
        
        [voiceLengthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.bottom.offset(0);
            
        }];
        
    }
    return _voiceLengthLabel;
}


- (UILabel *)voicePlayCountLabel
{
    if(_voicePlayCountLabel == nil)
    {
        UILabel *voicePlayCountLabel = [[UILabel alloc] init];
        [self.pictureImageView addSubview:voicePlayCountLabel];
        _voicePlayCountLabel = voicePlayCountLabel;
        
        voicePlayCountLabel.textColor = [UIColor whiteColor];
        voicePlayCountLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        
        voicePlayCountLabel.font = [UIFont systemFontOfSize:12];
        
        [voicePlayCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.top.offset(0);
            
        }];
        
    }
    return _voicePlayCountLabel;
}

- (UIImageView *)pictureImageView
{
    if(_pictureImageView == nil)
    {
        UIImageView *pictureImageView = [[UIImageView alloc] init];
        [self addSubview:pictureImageView];
        _pictureImageView = pictureImageView;
        pictureImageView.userInteractionEnabled = YES;
        
        [pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return _pictureImageView;
}

- (M13ProgressViewRing *)ringProgressView
{
    if(_ringProgressView == nil)
    {
        M13ProgressViewRing *ringProgressView = [[M13ProgressViewRing alloc] init];
        [self insertSubview:ringProgressView belowSubview:self.pictureImageView];
        _ringProgressView = ringProgressView;
        
        
        
        ringProgressView.backgroundRingWidth = 5;
        ringProgressView.progressRingWidth = 5;
        ringProgressView.showPercentage = YES;
        ringProgressView.primaryColor = [UIColor redColor];
        ringProgressView.secondaryColor = [UIColor yellowColor];
        
        [ringProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.centerOffset(CGPointZero);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
    }
    return _ringProgressView;
}


- (UIButton *)voicePlayButton
{
    if(_voicePlayButton == nil)
    {
        UIButton *btn = [[UIButton alloc] init];
        [self addSubview:btn];
        _voicePlayButton = btn;
        
        [btn setBackgroundImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.centerOffset(CGPointZero);
            
        }];

         [btn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _voicePlayButton;
}

- (void)playVideo:(UIButton *)playBtn
{
    playBtn.selected = !playBtn.isSelected;
    lastPlayBtn_.selected = !lastPlayBtn_.isSelected;
    if (lastTopicM_ != self.topicViewModel.topic) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
        
        self.playerItem = [AVPlayerItem playerItemWithURL:self.topicViewModel.topic.voiceUrl];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:self.playerItem];
        [voice_player_ replaceCurrentItemWithPlayerItem:self.playerItem];
        
        progressV_.frame = CGRectMake(playBtn.frame.origin.x-2, playBtn.frame.origin.y-2, playBtn.frame.size.width+4, playBtn.frame.size.height+4);
        [self insertSubview:progressV_ belowSubview:self.voicePlayButton];
        [progressV_ setProgress:0 animated:NO];
        
        [voice_player_ play];
        [avTimer_ setFireDate:[NSDate date]];
        lastTopicM_.voicePlaying = NO;
        self.topicViewModel.topic.voicePlaying = YES;
        [lastPlayBtn_ setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
        [playBtn setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
    }else{
        if(lastTopicM_.voicePlaying){
            [voice_player_ pause];
            [avTimer_ setFireDate:[NSDate distantFuture]];
            self.topicViewModel.topic.voicePlaying = NO;
            [playBtn setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
        }else{
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(playerItemDidReachEnd:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:self.playerItem];
            progressV_.frame = CGRectMake(playBtn.frame.origin.x-2, playBtn.frame.origin.y-2, playBtn.frame.size.width+4, playBtn.frame.size.height+4);
            [self insertSubview:progressV_ belowSubview:self.voicePlayButton];
            
            [voice_player_ play];
            [avTimer_ setFireDate:[NSDate date]];
            self.topicViewModel.topic.voicePlaying = YES;
            [playBtn setImage:[UIImage imageNamed:@"playButtonPause"] forState:UIControlStateNormal];
        }
    }
    lastTopicM_ = self.topicViewModel.topic;
    lastPlayBtn_ = playBtn;
    progressV_.hidden = !self.topicViewModel.topic.voicePlaying;
    
}
    
-(void) playerItemDidReachEnd:(AVPlayerItem *)playerItem{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    lastTopicM_.voicePlaying = NO;
    self.topicViewModel.topic.voicePlaying = NO;
    [lastPlayBtn_ setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
    [self.voicePlayButton setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
    [voice_player_ seekToTime:kCMTimeZero];
    [progressV_ setProgress:0 animated:NO];
    [progressV_ removeFromSuperview];
    progressV_.hidden = YES;
}
    
    

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUIOnce];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupUIOnce];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    progressV_.frame = CGRectMake(lastPlayBtn_.frame.origin.x-2, lastPlayBtn_.frame.origin.y-2, lastPlayBtn_.frame.size.width+4, lastPlayBtn_.frame.size.height+4);
    [self setNeedsDisplay];
}
-(void)setPlayCallback:(void (^)(void))playCallback{
    [voice_player_ pause];
    
    lastTopicM_.voicePlaying = NO;
    [lastPlayBtn_ setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    //[avTimer_ invalidate];
    //avTimer_= nil;
    SUPLog(@"=======setPlayCallback=====");
}

-(void)dealloc{
    [voice_player_ pause];
     NSLog(@"dealloc---%@", self.class);
    lastTopicM_.voicePlaying = NO;
    [lastPlayBtn_ setImage:[UIImage imageNamed:@"playButtonPlay"] forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
@end
