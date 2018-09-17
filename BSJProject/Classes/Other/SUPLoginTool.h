//
//  SUPLoginTool.h
//  BSJProject
//
//  Created by NShunJian on 2018/7/29.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SUPLoginTool : NSObject
+ (void)setUid:(NSString *)uid;

/** 
 获得当前登录用户的uid，检测是否登录
 NSString *：已经登录, nil：没有登录 
 */
+ (NSString *)getUid;
+ (NSString *)getUid:(BOOL)showLoginController;
@end
