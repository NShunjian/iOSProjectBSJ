//
//  UIBarButtonItem+SUPExtension.h
//  BSJProject
//
//  Created by NShunJian on 2018/7/29.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (SUPExtension)
+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;

+ (instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage title:(NSString *)title target:(id)target action:(SEL)action;
@end
