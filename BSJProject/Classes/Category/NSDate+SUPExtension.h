//
//  NSData+SUPExtension.h
//  BSJProject
//
//  Created by NShunJian on 2018/8/14.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SUPExtension)
/**
 * 比较from和self的时间差值
 */
- (NSDateComponents *)deltaFrom:(NSDate *)from;
@end
