//
//  BSJProject
//
//  Created by NShunJian on 2018/8/5.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPLoginRegisterViewController.h"

@interface SUPLoginRegisterViewController ()
/** 登录框距离控制器view左边的间距 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;

@end

@implementation SUPLoginRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
- (IBAction)showLoginOrRegister:(UIButton *)sender {
    // 退出键盘
    [self.view endEditing:YES];
    
    if (self.loginViewLeftMargin.constant == 0) { // 显示注册界面
        self.loginViewLeftMargin.constant = - self.view.width;
        sender.selected = YES;
        //        [button setTitle:@"已有账号?" forState:UIControlStateNormal];
    } else { // 显示登录界面
        self.loginViewLeftMargin.constant = 0;
        sender.selected = NO;
        //        [button setTitle:@"注册账号" forState:UIControlStateNormal];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}
- (IBAction)back:(UIButton *)sender {
       [self dismissViewControllerAnimated:YES completion:nil];
}





/**
 * 让当前控制器对应的状态栏是白色
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
