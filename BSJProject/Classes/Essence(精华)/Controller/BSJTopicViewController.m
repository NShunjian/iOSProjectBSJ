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

@interface BSJTopicViewController ()
/*
//<ZJScrollPageViewChildVcDelegate>
 */
/** <#digest#> */
@property (nonatomic, strong) BSJTopicService *topicService;
/** 上次选中的索引(或者控制器) */
@property (nonatomic, assign) NSInteger lastSelectedIndex;
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
        
        [self.tableView reloadData];
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topicService.topicViewModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SUPTopicCell *topicCell = [SUPTopicCell topicCellWithTableView:tableView];
    topicCell.topicViewModel = self.topicService.topicViewModels[indexPath.row];
    return topicCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.topicService.topicViewModels[indexPath.row].cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    BSJCommentPageViewController *cmtVc = [[BSJCommentPageViewController alloc] init];
    cmtVc.topicViewModel = self.topicService.topicViewModels[indexPath.row];
    [self.navigationController pushViewController:cmtVc animated:YES];
}

#pragma mark - getter

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
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    // 取消所有任务
    //    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];//这个取消是取消所有的任务  这个是可以重新开启任务
    [[SUPRequestManager sharedManager] invalidateSessionCancelingTasks:YES];//这个取消是整个任务都不好使也就是AFHTTPSessionManager 中的Session被取消了整个都用不了了 不能重新开启任务了
}

@end
