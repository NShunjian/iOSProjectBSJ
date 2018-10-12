//
//  SUPEssenceViewController.m
//  BSJProject
//
//  Created by NShunJian on 2018/7/31.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPEssenceViewController.h"
#import "SUPRecommendTagsViewController.h"
#import "BSJTopicViewController.h"
#import "SUPAudioVoiceViewController.h"
#import "ViewController.h"

@interface SUPEssenceViewController ()<ZJScrollPageViewDelegate>
@property (nonatomic, weak) ZJScrollPageView *scrollPageView;
@property(strong, nonatomic)NSArray<NSString *> *titles;

@end

@implementation SUPEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //必要的设置, 如果没有设置可能导致内容显示不正常
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //    1为全部，10为图片，29为段子，31为音频，41为视频
    
//    第二种
    BSJTopicViewController *all = [[BSJTopicViewController alloc] initWithTitle:@"全部"];
    BSJTopicViewController *video = [[BSJTopicViewController alloc] initWithTitle:@"视频"];
    BSJTopicViewController *picture = [[BSJTopicViewController alloc] initWithTitle:@"图片"];
    BSJTopicViewController *words = [[BSJTopicViewController alloc] initWithTitle:@"段子"];
    BSJTopicViewController *voice = [[BSJTopicViewController alloc] initWithTitle:@"音频"];


    words.topicType = BSJTopicTypeWords;
    voice.topicType = BSJTopicTypeVoice;
    picture.topicType = BSJTopicTypePicture;
    video.topicType = BSJTopicTypeVideo;
    all.topicType = BSJTopicTypeAll;
    self.childVcs = [NSArray arrayWithObjects:all,video,picture,words, voice, nil];


    //第二种
    [self.childVcs makeObjectsPerformSelector:@selector(setAreaType:) withObject:@"list"];

    self.scrollPageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}
#pragma mark - getter

- (ZJScrollPageView *)scrollPageView
{
    if(_scrollPageView == nil)
    {
        ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
        //显示滚动条
        style.showLine = YES;
//        style.showCover = YES;
        // 颜色渐变
        style.gradualChangeTitleColor = YES;
        style.animatedContentViewWhenTitleClicked = NO;
        style.autoAdjustTitlesWidth = YES;
        self.titles = @[@"全部",
                        @"视频",
                        @"图片",
                        @"段子",
                        @"音频"
                        ];
        //第二种
        ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, self.SUP_navgationBar.SUP_height, self.view.SUP_width, self.view.SUP_height - self.SUP_navgationBar.SUP_height) segmentStyle:style titles:[self.childVcs valueForKey:@"title"] parentViewController:self delegate:self];
//        第一种
//        ZJScrollPageView *scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, self.SUP_navgationBar.SUP_height, self.view.SUP_width, self.view.SUP_height - self.SUP_navgationBar.SUP_height) segmentStyle:style titles:self.titles parentViewController:self delegate:self];
//
        
        scrollPageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        scrollPageView.segmentView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.7];
//        scrollPageView.contentView.backgroundColor = [UIColor redColor];
        [self.view addSubview:scrollPageView];
        _scrollPageView = scrollPageView;
    }
    return _scrollPageView;
}


#pragma mark - ZJScrollPageViewDelegate
- (NSInteger)numberOfChildViewControllers {
    //第一种
//    return self.titles.count;
    //第二种
    return self.childVcs.count;
}
//第二种
- (UIViewController <ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    UIViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
    //第二种
    if (!childVc) {
        childVc = self.childVcs[index];
    }
     NSLog(@"%ld-----%@",(long)index, childVc);
    return childVc;
}




// //第一种

//-(NSMutableArray<BSJTopicViewController *> *)childController{
//    if (!_childController) {
//        _childController = [[NSMutableArray alloc]init];
//    }
//    return _childController;
//}
//
//- (UIViewController <ZJScrollPageViewChildVcDelegate> *)childViewController:(BSJTopicViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
//    [self.childController removeAllObjects];
//    BSJTopicViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
//    //    BSJTopicViewController *vc = (BSJTopicViewController*)childVc;
//    //第一种
//    if (!childVc) {
//        childVc = [[BSJTopicViewController alloc] init];
//    }
//    if (index == 0) {
//
//        childVc.topicType = BSJTopicTypeAll;
//    }else if (index == 1){
//        childVc.topicType = BSJTopicTypeVideo;
//    }else if (index == 2){
//        childVc.topicType = BSJTopicTypePicture;
//    }else if (index == 3){
//        childVc.topicType = BSJTopicTypeWords;
//    }else{
//        childVc.topicType = BSJTopicTypeVoice;
//    }
//
//    [self.childController addObject:childVc];
//    [self.childController makeObjectsPerformSelector:@selector(setAreaType:) withObject:@"list"];
//
//    NSLog(@"%ld-----%@",(long)index, childVc);
//    return childVc;
//}


- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}


#pragma mark - SUPNavUIBaseViewControllerDataSource
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

/** 是否隐藏底部黑线 */
- (BOOL)SUPNavigationIsHideBottomLine:(SUPNavigationBar *)navigationBar
{
    return NO;
}

///** 导航条中间的 View */
//- (UIView *)SUPNavigationBarTitleView:(SUPNavigationBar *)navigationBar
//{
//    return ({
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
//        imageView.backgroundColor = [UIColor whiteColor];
//        imageView;
//    });
//}

/** 导航条左边的按钮 */
- (UIImage *)SUPNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(SUPNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"MainTagSubIcon"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"MainTagSubIconClick"] forState:UIControlStateHighlighted];
    return nil;
}


/** 导航条右边的按钮 */
- (UIImage *)SUPNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(SUPNavigationBar *)navigationBar
{
    [rightButton setImage:[UIImage imageNamed:@"nav_coin_icon_click"] forState:UIControlStateHighlighted];
    return [UIImage imageNamed:@"nav_coin_icon"];
}

//- (void)titleClickEvent:(UILabel *)sender navigationBar:(SUPNavigationBar *)navigationBar {
//    [self.navigationController pushViewController:[[BSJRecommendViewController alloc] init] animated:YES];
//}


//- (void)rightButtonEvent:(UIButton *)sender navigationBar:(SUPNavigationBar *)navigationBar {
//    [self.navigationController pushViewController:[[BSJRecommendViewController alloc] init] animated:YES];
//}


/** 导航条中间的 View */
- (UIView *)SUPNavigationBarTitleView:(SUPNavigationBar *)navigationBar
{
    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
}


#pragma mark - Delegate

/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(SUPNavigationBar *)navigationBar
{
    SUPRecommendTagsViewController *vc = [[SUPRecommendTagsViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
    NSLog(@"======");
}
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(SUPNavigationBar *)navigationBar
{
    ViewController *playerVc = [[ViewController alloc] init];
    //    playerVc.voiceUrl = self.topicViewModel.topic.voiceUrl.absoluteString;
    [self.navigationController pushViewController:playerVc animated:NO];
    
    
    NSLog(@"%s", __func__);
}


#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{   if(curTitle){
    
}
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, title.length)];
    
    return title;
}

-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];//即使没有显示在window上，也不会自动的将self.view释放。
    // Dispose of any resources that can be recreated.
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0下使用的,6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载 ，在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window)// 是否是正在使用的视图
        {
            //code
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}

@end
