//
//  BSJTopicViewController.m
//  BSJProject
//
//  Created by NShunJian on 2018/7/29.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "BSJTopicViewController.h"
#import "ZJScrollPageView.h"
#import "BSJTopicService.h"
#import "BSJTopicViewModel.h"
#import "BSJTopic.h"
#import "SUPTopicCell.h"
#import "BSJCommentPageViewController.h"
static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

@interface BSJTopicViewController ()<ZFTableViewCellDelegate>
/*
//<ZJScrollPageViewChildVcDelegate>
 */
/** <#digest#> */
@property (nonatomic, strong) BSJTopicService *topicService;
/** 上次选中的索引(或者控制器) */
@property (nonatomic, assign) NSInteger lastSelectedIndex;


@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) NSMutableArray *urls;

@property (nonatomic, strong) UIImageView *containerView;
@property (nonatomic, strong) UIButton *playBtn;

@property(nonatomic, strong)SUPTopicCell *topicCell;
@end

@implementation BSJTopicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIEdgeInsets edgeInsets = self.tableView.contentInset;
    edgeInsets.bottom += self.tabBarController.tabBar.SUP_height;
    self.tableView.contentInset = edgeInsets;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 监听tabbar点击的通知
    [SUPNoteCenter addObserver:self selector:@selector(tabBarSelect) name:SUPTabBarDidSelectNotification object:nil];
}

#pragma mark - ZJScrollPageViewChildVcDelegate
- (void)zj_viewWillAppearForIndex:(NSInteger)index {
    [self viewWillAppear:YES];
}
- (void)zj_viewDidAppearForIndex:(NSInteger)index {
    [self viewDidAppear:YES];
    // bug fix
    self.view.height = self.view.superview.height;
}
- (void)zj_viewWillDisappearForIndex:(NSInteger)index {
    [self viewWillDisappear:YES];
}
- (void)zj_viewDidDisappearForIndex:(NSInteger)index {
    [self viewDidDisappear:YES];
}

//- (void)zj_viewDidLoadForIndex:(NSInteger)index{}
/*
#pragma mark - a参数
- (NSString *)a
{
    return [self.parentViewController isKindOfClass:[SUPNewViewController class]] ? @"newlist" : @"list";
}
*/

- (void)loadMore:(BOOL)isMore
{
    /*
    // 结束之前的所有请求  这个方法是防止 上拉刷新之后 又下拉刷新  这是其中的一个处理方法... 点击 getTopicIsMore 这个方法 里面的self.parameters != parameters 也是可以的  防止上拉刷新之后 又下拉刷新数据请求的问题
//    if (self.parameters != parameters) {
//        return ;
//    }
    [[SUPRequestManager sharedManager].tasks makeObjectsPerformSelector:@selector(cancel)];
    */
    
    
    SUPWeakSelf(self);
    SUPLog(@"=====  ===%@",self.areaType);
    SUPLog(@"=====  ===%zd",self.topicType);
    [self.topicService getTopicIsMore:isMore typeA:self.areaType topicType:self.topicType completion:^(NSError *error, NSInteger totalCount, NSInteger currentCount) {
        
        [weakself endHeaderFooterRefreshing];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wint-conversion"
        [weakself.tableView configBlankPage:SUPEasyBlankPageViewTypeNoData hasData:currentCount hasError:error reloadButtonBlock:^(id sender) {
            [weakself.tableView.mj_header beginRefreshing];
        }];
#pragma clang diagnostic pop
        if (error) {
            [weakself.view makeToast:error.localizedDescription duration:3 position:CSToastPositionCenter];
            return ;
        }
        
        self.tableView.mj_footer.state = (currentCount >= totalCount) ? MJRefreshStateNoMoreData : MJRefreshStateIdle;
        
        if (self.topicType == 41||self.topicType == 1) {
            self.urls = @[].mutableCopy;
            for (BSJTopicViewModel *dataDic in self.topicService.topicViewModels) {
//                if (dataDic.topic.videoUrl.absoluteString.length > 0) {
                
                NSString *urldata = [dataDic.topic.videoUrl.absoluteString stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] invertedSet]];
                NSString *URLString = [urldata stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
                NSURL *url = [NSURL URLWithString:URLString];;
                [self.urls addObject:url];
//                }
            }
            
            
                 /// playerManager
            ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
            //    KSMediaPlayerManager *playerManager = [[KSMediaPlayerManager alloc] init];
            //    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
            
            /// player的tag值必须在cell里设置
            self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
            self.player.controlView = self.controlView;
            self.player.assetURLs = self.urls;
            self.player.shouldAutoPlay = NO;
            /// 1.0是完全消失的时候
            self.player.playerDisapperaPercent = 1.0;
            
            @weakify(self)
            self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
                @strongify(self)
                [self setNeedsStatusBarAppearanceUpdate];
                [UIViewController attemptRotationToDeviceOrientation];
                self.tableView.scrollsToTop = !isFullScreen;
            };
            
            self.player.playerDidToEnd = ^(id  _Nonnull asset) {
                @strongify(self)
                if (self.player.playingIndexPath.row < self.urls.count - 1 && !self.player.isFullScreen) {
//                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.player.playingIndexPath.row+1 inSection:0];
//                     BSJTopicViewModel *layout = self.topicService.topicViewModels[indexPath.row];
//                    [self playTheVideoAtIndexPath:indexPath scrollToTop:YES];
                    
                    [self.player stop];
                    
                } else if (self.player.isFullScreen) {
                    [self.player stopCurrentPlayingCell];
                }
            };
        }
        [self.tableView reloadData];
        
    }];
}
//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
//    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
//    CGFloat h = CGRectGetMaxY(self.view.frame);
//    self.tableView.frame = CGRectMake(0, y, self.view.frame.size.width, h-y);
//}
- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [SDWebImageManager.sharedManager cancelAll];
//    [SDWebImageManager.sharedManager.imageCache clearMemory];
    // 清除缓存
    [[SDImageCache sharedImageCache] clearMemory];
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [super scrollViewWillBeginDragging:scrollView];
    [scrollView zf_scrollViewWillBeginDragging];
}


#pragma mark - ZFTableViewCellDelegate

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark - private method

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    SUPLog(@"%zd",indexPath.row);
    BSJTopicViewModel *layout = self.topicService.topicViewModels[indexPath.row];
    NSString *urldata = [layout.topic.smallPicture.absoluteString stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "] invertedSet]];
    [self.controlView showTitle:layout.topic.text
                 coverURLString:urldata
                 fullScreenMode:layout.isVerticalVideo?ZFFullScreenModePortrait:ZFFullScreenModeLandscape];
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        /// 快进视图是否显示动画，默认NO。
//        _controlView.fastViewAnimated = YES;
        
    }
    return _controlView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicService.topicViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    _topicCell = [SUPTopicCell topicCellWithTableView:tableView];
    [_topicCell setDelegate:self withIndexPath:indexPath];
    _topicCell.topicViewModel = self.topicService.topicViewModels[indexPath.row];
    [_topicCell setNormalMode];
    
    
//    [topicCell.playButton addTarget:self action:@selector(playButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    topicCell.playButton.tag = 100 + indexPath.row;
//    topicCell.tags = 1000 + indexPath.row;
    return _topicCell;
}
// 根据点击的Cell控制播放器的位置
- (void)playButtonAction:(UIButton *)sender{
    SUPLog(@"---------sender.tag = %ld------------------",(long)sender.tag);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.topicService.topicViewModels[indexPath.row].cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

//    BSJCommentPageViewController *cmtVc = [[BSJCommentPageViewController alloc] init];
//    cmtVc.topicViewModel = self.topicService.topicViewModels[indexPath.row];
//    [self.navigationController pushViewController:cmtVc animated:YES];
    
    
    
    /// 如果正在播放的index和当前点击的index不同，则停止当前播放的index
    if (self.player.playingIndexPath != indexPath) {
        [self.player stopCurrentPlayingCell];
    }
    /// 如果没有播放，则点击进详情页会自动播放
    if (!self.player.currentPlayerManager.isPlaying) {
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }
    /// 到详情页
    BSJCommentPageViewController *detailVC = [BSJCommentPageViewController new];
    detailVC.player = self.player;
    @weakify(self)
    /// 详情页返回的回调
    detailVC.detailVCPopCallback = ^{
        @strongify(self)
//        [self.player updateScrollViewPlayerToCell];
        [self.player stop];
    };
    /// 详情页点击播放的回调
    detailVC.detailVCPlayCallback = ^{
        @strongify(self)
        [self zf_playTheVideoAtIndexPath:indexPath];
    };
    detailVC.topicViewModel = self.topicService.topicViewModels[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    
    
    
    
}

#pragma mark - getter

- (UIImageView *)containerView {
    if (!_containerView) {
        _containerView = [UIImageView new];
        [_containerView setImageWithURLString:kVideoCover placeholder:[ZFUtilities imageWithColor:[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1] size:CGSizeMake(1, 1)]];
    }
    return _containerView;
}
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"ZFPlayer_repeat_video"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
- (void)playClick:(UIButton *)sender {
//    if (self.detailVCPlayCallback) {
//        self.detailVCPlayCallback();
//    }
//    [self.player updateNoramlPlayerWithContainerView:_header.videoView];
}

- (BSJTopicService *)topicService
{
    if(_topicService == nil)
    {
        _topicService = [[BSJTopicService alloc] init];
    }
    return _topicService;
}

- (void)tabBarSelect
{
    // 如果是连续选中2次, 直接刷新
    if (self.lastSelectedIndex == self.tabBarController.selectedIndex
        //        && self.tabBarController.selectedViewController == self.navigationController
        && self.view.isShowingOnKeyWindow) {
        [self.tableView.mj_header beginRefreshing];
    }
    
    // 记录这一次选中的索引
    self.lastSelectedIndex = self.tabBarController.selectedIndex;
}

#pragma mark - SUPNavUIBaseViewControllerDataSource
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
     NSLog(@"376  -- dealloc---%@", self.class);
    // 取消所有任务
    //    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];//这个取消是取消所有的任务  这个是可以重新开启任务
    [[SUPRequestManager sharedManager] invalidateSessionCancelingTasks:YES];//这个取消是整个任务都不好使也就是AFHTTPSessionManager 中的Session被取消了整个都用不了了 不能重新开启任务了
}

@end
