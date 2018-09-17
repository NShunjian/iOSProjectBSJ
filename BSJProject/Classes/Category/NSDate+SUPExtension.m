//
//  NSData+SUPExtension.m
//  BSJProject
//
//  Created by NShunJian on 2018/8/14.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "NSDate+SUPExtension.h"

@implementation NSDate (SUPExtension)
- (NSDateComponents *)deltaFrom:(NSDate *)from
{
    // 日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 比较时间
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    return [calendar components:unit fromDate:from toDate:self options:0];
}
@end
