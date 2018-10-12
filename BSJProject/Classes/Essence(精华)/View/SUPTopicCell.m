//
//  BSJTopicCell.m
//  BSJProject
//
//  Created by NShunJian on 2018/7/29.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPTopicCell.h"
#import "BSJTopicPictureView.h"
#import "BSJTopicVoiceView.h"
#import "BSJTopicVideoView.h"
//#import "SUPUMengHelper.h"
#import "SUPLoginTool.h"
@interface SUPTopicCell ()<UIActionSheetDelegate>

/**
 头像
 */
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

/**
 是否是新浪会员
 */
@property (weak, nonatomic) IBOutlet UIImageView *isSinaVipImageView;

/**
 昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;

/**
 发表时间
 */
@property (weak, nonatomic) IBOutlet UILabel *creatTimeLabel;

/**
 内容 text
 */
@property (weak, nonatomic) IBOutlet UILabel *contentTextLabel;

/**
 顶的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *dingBtn;
@property (weak, nonatomic) IBOutlet UIButton *caiBtn;
@property (weak, nonatomic) IBOutlet UIButton *repostBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;


/**
 热门评论的父控件 view
 */
@property (weak, nonatomic) IBOutlet UIView *cmtContainerView;

/** 展示图片的控件 */
@property (weak, nonatomic) BSJTopicPictureView *pictureView;

///** 展示声音 */
//@property (weak, nonatomic) BSJTopicVoiceView *voiceView;

///** 展示视频 */
//@property (weak, nonatomic)  BSJTopicVideoView *videoView;

/**
 热门评论的 Label
 */
@property (weak, nonatomic) IBOutlet YYLabel *topCmtContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCmtHeightConstraint;


@property (nonatomic, strong) UIView *fullMaskView;
@property (nonatomic, weak) id<ZFTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation SUPTopicCell


- (void)setDelegate:(id<ZFTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath {
    self.delegate = delegate;
    self.indexPath = indexPath;
}

- (void)setNormalMode {
    self.fullMaskView.hidden = YES;
//    self.titleLabel.textColor = [UIColor blackColor];
//    self.nickNameLabel.textColor = [UIColor blackColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)showMaskView {
    [UIView animateWithDuration:0.3 animations:^{
        self.fullMaskView.alpha = 1;
    }];
}

- (void)hideMaskView {
    [UIView animateWithDuration:0.3 animations:^{
        self.fullMaskView.alpha = 0;
    }];
}


- (void)playBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_playTheVideoAtIndexPath:)]) {
        [self.delegate zf_playTheVideoAtIndexPath:self.indexPath];
    }
}

- (UIView *)fullMaskView {
    if (!_fullMaskView) {
        _fullMaskView = [UIView new];
        _fullMaskView.frame = self.contentView.bounds;
        _fullMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _fullMaskView.userInteractionEnabled = NO;
    }
    return _fullMaskView;
}












+ (instancetype)cell
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}


- (void)setupBSJTopicCellUIOnce
{
    self.contentTextLabel.font = AdaptedFontSize(14);
    
    self.headerImageView.layer.cornerRadius = 25;
    self.headerImageView.layer.masksToBounds = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
     [self insertSubview:self.fullMaskView aboveSubview:self.contentView];
}

- (void)setTopicViewModel:(BSJTopicViewModel *)topicViewModel
{
    _topicViewModel = topicViewModel;
    
    // Model
    [self.headerImageView sd_setImageWithURL:topicViewModel.topic.profile_image placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
    
    self.screenNameLabel.text = topicViewModel.topic.name;
    
    self.creatTimeLabel.text = topicViewModel.creatTime;
    
    self.contentTextLabel.text = topicViewModel.topic.text;
    
    self.isSinaVipImageView.hidden = !topicViewModel.topic.isSina_v;
    
    
    // ViewModel
    [self.dingBtn setTitle:topicViewModel.zanCount forState:UIControlStateNormal];
    [self.caiBtn setTitle:topicViewModel.caiCount forState:UIControlStateNormal];
    [self.repostBtn setTitle:topicViewModel.repostCount forState:UIControlStateNormal];
    [self.commentBtn setTitle:topicViewModel.commentCount forState:UIControlStateNormal];
    
    SUPLog(@"%zd",topicViewModel.topic.type);
    if (topicViewModel.topic.type == BSJTopicTypePicture) {
        
        self.pictureView.topicViewModel = topicViewModel;
        self.pictureView.frame = topicViewModel.pictureFrame;
        
        _pictureView.hidden = NO;
        _voiceView.hidden = YES;
        _videoView.hidden = YES;
        
    }else if (topicViewModel.topic.type == BSJTopicTypeVoice)
    {
        self.voiceView.frame = topicViewModel.pictureFrame;
        self.voiceView.topicViewModel = topicViewModel;
        _pictureView.hidden = YES;
        _voiceView.hidden = NO;
        _videoView.hidden = YES;
        
    }else if (topicViewModel.topic.type == BSJTopicTypeWords)
    {
        _pictureView.hidden = YES;
        _voiceView.hidden = YES;
        _videoView.hidden = YES;
        
    }else if (topicViewModel.topic.type == BSJTopicTypeVideo)
    {
        self.videoView.frame = topicViewModel.pictureFrame;
        self.videoView.topicViewModel = topicViewModel;
        self.videoView.playCallback = ^{
            [self playBtnClick:nil];
        };
        _pictureView.hidden = YES;
        _voiceView.hidden = YES;
        _videoView.hidden = NO;
    }
    
    
    // 热门评论
    if (topicViewModel.topic.topCmts.count) {
        
        self.cmtContainerView.hidden = NO;
        self.topCmtContentView.textLayout = topicViewModel.topCmtLayout;
        self.topCmtHeightConstraint.constant = topicViewModel.topCmtLayout.textBoundingSize.height+26;
        SUPLog(@"%f",topicViewModel.topCmtLayout.textBoundingSize.height);
        self.topicViewModel.topCmtClick = ^(BSJUser *user, BSJTopicTopComent *topCmt) {
            NSLog(@"%@,   %@", user.username, topCmt.content);
        };
        
    }else
    {
        self.cmtContainerView.hidden = YES;
    }
}




#pragma mark - action
- (IBAction)dingButtonClick:(UIButton *)sender {
}
- (IBAction)caiButtonClick:(UIButton *)sender {
}

- (IBAction)repostButtonClick:(UIButton *)sender {
    
//  [SUPUMengHelper shareTitle:self.topicViewModel.topic.name subTitle:self.topicViewModel.topic.text thumbImage:self.topicViewModel.topic.profile_image.absoluteString shareURL:self.topicViewModel.topic.weixin_url];
}
- (IBAction)commentButtonClick:(UIButton *)sender {
}

- (IBAction)topRightClick:(UIButton *)sender {
}


#pragma mark - getter

- (BSJTopicPictureView *)pictureView
{
    if(_pictureView == nil)
    {
        BSJTopicPictureView *pictureView = [[BSJTopicPictureView alloc] init];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}

- (BSJTopicVoiceView *)voiceView
{
    if(_voiceView == nil)
    {
        BSJTopicVoiceView *voiceView = [[BSJTopicVoiceView alloc] init];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}


- (BSJTopicVideoView *)videoView
{
    if(_videoView == nil)
    {
        BSJTopicVideoView *videoView = [[BSJTopicVideoView alloc] init];
        videoView.tag = 100;
        videoView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:videoView];
        _videoView = videoView;
        
    }
    return _videoView;
}

+ (instancetype)topicCellWithTableView:(UITableView *)tableView
{
    SUPTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([self class])];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil].lastObject;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupBSJTopicCellUIOnce];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setupBSJTopicCellUIOnce];
}
- (IBAction)More:(id)sender {
    
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏",@"举报" ,nil];
    [action showInView:self.window];
}

#pragma mark - <UIActionSheetDelegate>
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SUPLog(@"===clickedButtonAtIndex===");
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
      SUPLog(@"===didDismissWithButtonIndex===");
    if (buttonIndex == 2) return;
    
    if ([SUPLoginTool getUid] == nil) return;
    
    // 开始执行举报\收藏操作
}

@end
