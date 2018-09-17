//
//  SUPFriendTrendsViewController.m
//  BSJProject
//
//  Created by NShunJian on 2018/7/31.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPFriendTrendsViewController.h"
#import "SUPRecommendViewController.h"
#import "SUPLoginRegisterViewController.h"
@interface SUPFriendTrendsViewController ()

@end

@implementation SUPFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (IBAction)loginRegister {
    SUPLoginRegisterViewController *login = [[SUPLoginRegisterViewController alloc] init];
    [self presentViewController:login animated:YES completion:nil];
}
#pragma mark - SUPNavUIBaseViewControllerDataSource
//- (BOOL)navUIBaseViewControllerIsNeedNavBar:(SUPNavUIBaseViewController *)navUIBaseViewController
//{
//    return YES;
//}



#pragma mark - DataSource
/**头部标题*/
- (NSMutableAttributedString*)SUPNavigationBarTitle:(SUPNavigationBar *)navigationBar
{
    return [self changeTitle:@"我的关注"];
}

/** 背景图片 */
//- (UIImage *)SUPNavigationBarBackgroundImage:(SUPNavigationBar *)navigationBar
//{
//
//}

/** 背景色 */
//- (UIColor *)SUPNavigationBackgroundColor:(SUPNavigationBar *)navigationBar
//{
//
//}

/** 是否隐藏底部黑线 */
- (BOOL)SUPNavigationIsHideBottomLine:(SUPNavigationBar *)navigationBar
{
    return NO;
}

/** 导航条的高度 */
//- (CGFloat)SUPNavigationHeight:(SUPNavigationBar *)navigationBar
//{
//
//}


/** 导航条的左边的 view */
//- (UIView *)SUPNavigationBarLeftView:(SUPNavigationBar *)navigationBar
//{
//
//}
/** 导航条右边的 view */
//- (UIView *)SUPNavigationBarRightView:(SUPNavigationBar *)navigationBar
//{
//
//}
///** 导航条中间的 View */
//- (UIView *)SUPNavigationBarTitleView:(SUPNavigationBar *)navigationBar
//{
//    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
//}
/** 导航条左边的按钮 */
- (UIImage *)SUPNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(SUPNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"friendsRecommentIcon"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] forState:UIControlStateHighlighted];
    return nil;
}
///** 导航条右边的按钮 */
//- (UIImage *)SUPNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(SUPNavigationBar *)navigationBar
//{
//    [rightButton setTitle:@"百度" forState:UIControlStateNormal];
//
//    [rightButton setTitleColor:[UIColor RandomColor] forState:UIControlStateNormal];
//    return nil;
//}



#pragma mark - Delegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(SUPNavigationBar *)navigationBar
{
    SUPRecommendViewController *vc = [[SUPRecommendViewController alloc]init];
    [self.navigationController pushViewController:vc animated:NO];
    NSLog(@"======");
}
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(SUPNavigationBar *)navigationBar
{
    
    NSLog(@"%s", __func__);
}
/** 中间如果是 label 就会有点击 */
-(void)titleClickEvent:(UILabel *)sender navigationBar:(SUPNavigationBar *)navigationBar
{
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



@end
