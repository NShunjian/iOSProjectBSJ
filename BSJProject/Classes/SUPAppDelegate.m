//
//  AppDelegate.m
//  BSJProject
//
//  Created by NShunJian on 2018/7/29.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPAppDelegate.h"
#import "SUPTabBarController.h"
#import "CYLPlusButtonSubclass.h"
#import "SUPGuidePushView.h"
#import "BSJTopicListDAL.h"
#import "SUPTopWindow.h"
@interface SUPAppDelegate ()<UITabBarControllerDelegate>

@end

@implementation SUPAppDelegate
- (UIWindow *)window
{
    if(!_window)
    {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//        [_window makeKeyAndVisible];
    }
    return _window;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//     [SUPTopWindow show];
    [self setUpHomeViewController];
    //导向页
    [SUPGuidePushView showGuideView];
//    [self configureBoardManager];
    return YES;
}

-(void)setUpHomeViewController{
    [CYLPlusButtonSubclass registerPlusButton];
    SUPTabBarController *tabBarControllerConfig = [[SUPTabBarController alloc] init];
    CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
    tabBarController.delegate = self;
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    [tabBarController hideTabBadgeBackgroundSeparator];
   
}
#pragma mark - <UITabBarControllerDelegate>
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    // 发出一个通知
    [SUPNoteCenter postNotificationName:SUPTabBarDidSelectNotification object:nil userInfo:nil];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [BSJTopicListDAL clearOutTimeCashes];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // 添加一个window, 点击这个window, 可以让屏幕上的scrollView滚到最顶部
    [SUPTopWindow show:self.window];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark 键盘收回管理
-(void)configureBoardManager
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.keyboardDistanceFromTextField=60;
    manager.enableAutoToolbar = NO;
}
@end
