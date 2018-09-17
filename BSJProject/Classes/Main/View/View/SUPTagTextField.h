//
//  SUPTagTextField.h
//  BSJProject
//
//  Created by NShunJian on 2018/7/29.
//  Copyright © 2018年 superMan. All rights reserved.
///

#import <UIKit/UIKit.h>

@interface SUPTagTextField : UITextField
/** 按了删除键后的回调 */
@property (nonatomic, copy) void (^deleteBlock)(void);
@end








