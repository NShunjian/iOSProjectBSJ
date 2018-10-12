//
//  SUPTopicCell.h
//  BSJProject
//
//  Created by NShunJian on 2018/8/9.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSJTopicViewModel.h"
#import "BSJTopicVideoView.h"
#import "BSJTopicVoiceView.h"
@protocol ZFTableViewCellDelegate <NSObject>

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface SUPTopicCell : UITableViewCell

+ (instancetype)topicCellWithTableView:(UITableView *)tableView;

/** <#digest#> */
@property (nonatomic, strong) BSJTopicViewModel *topicViewModel;

/** 展示视频 */
@property (weak, nonatomic)  BSJTopicVideoView *videoView;

/** 展示声音 */
@property (weak, nonatomic) BSJTopicVoiceView *voiceView;

@property (nonatomic, strong) UIButton         * playButton;

@property (nonatomic,assign)NSInteger tags;

+ (instancetype)cell;



//- (void)play:(void(^)(void))playCallback;
- (void)setDelegate:(id<ZFTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath;

- (void)showMaskView;

- (void)hideMaskView;

- (void)setNormalMode;
@end
