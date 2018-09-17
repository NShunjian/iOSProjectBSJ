//
//  SUPNewViewController.m
//  BSJProject
//
//  Created by NShunJian on 2018/7/31.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPNewViewController.h"

@interface SUPNewViewController ()

@end

@implementation SUPNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //第二种
    [self.childVcs makeObjectsPerformSelector:@selector(setAreaType:) withObject:@"newlist"];
    
}



// //第一种
//- (UIViewController <ZJScrollPageViewChildVcDelegate> *)childViewController:(BSJTopicViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
//    [self.childController removeAllObjects];
//    BSJTopicViewController<ZJScrollPageViewChildVcDelegate> *childVc = reuseViewController;
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
//    [self.childController makeObjectsPerformSelector:@selector(setAreaType:) withObject:@"newlist"];
//
//    NSLog(@"%ld-----%@",(long)index, childVc);
//    return childVc;
//}


#pragma mark - SUPNavUIBaseViewControllerDataSource
//- (BOOL)navUIBaseViewControllerIsNeedNavBar:(SUPNavUIBaseViewController *)navUIBaseViewController
//{
//    return YES;
//}


//
//#pragma mark - DataSource
///**头部标题*/
////- (NSMutableAttributedString*)SUPNavigationBarTitle:(SUPNavigationBar *)navigationBar
////{
////    return [self changeTitle:@"预演 功能列表"];
////}
//
///** 背景图片 */
////- (UIImage *)SUPNavigationBarBackgroundImage:(SUPNavigationBar *)navigationBar
////{
////
////}
//
///** 背景色 */
////- (UIColor *)SUPNavigationBackgroundColor:(SUPNavigationBar *)navigationBar
////{
////
////}
//
///** 是否隐藏底部黑线 */
//- (BOOL)SUPNavigationIsHideBottomLine:(SUPNavigationBar *)navigationBar
//{
//    return NO;
//}
//
///** 导航条的高度 */
////- (CGFloat)SUPNavigationHeight:(SUPNavigationBar *)navigationBar
////{
////
////}
//
//
///** 导航条的左边的 view */
////- (UIView *)SUPNavigationBarLeftView:(SUPNavigationBar *)navigationBar
////{
////
////}
///** 导航条右边的 view */
////- (UIView *)SUPNavigationBarRightView:(SUPNavigationBar *)navigationBar
////{
////
////}
///** 导航条中间的 View */
//- (UIView *)SUPNavigationBarTitleView:(SUPNavigationBar *)navigationBar
//{
//    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
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
    
    return nil;
}



#pragma mark - Delegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(SUPNavigationBar *)navigationBar
{
    NSLog(@"======");
}
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(SUPNavigationBar *)navigationBar
{
    
    NSLog(@"%s", __func__);
}
///** 中间如果是 label 就会有点击 */
//-(void)titleClickEvent:(UILabel *)sender navigationBar:(SUPNavigationBar *)navigationBar
//{
//    NSLog(@"%s", __func__);
//}
//
//
/**头部标题*/
- (NSMutableAttributedString*)SUPNavigationBarTitle:(SUPNavigationBar *)navigationBar
{
    return [self changeTitle:@"点击时间部位页面返回顶部"];
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



@end
