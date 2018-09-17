//
//  SUPRecommendCategory.m
//  BSJProject
//
//  Created by NShunJian on 2018/8/5.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPRecommendCategory.h"

@implementation SUPRecommendCategory

- (NSMutableArray *)users
{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID" : @"id"
             
             };
}

//  用这种也行 和上面的一样
//+ (NSString *)replacedKeyFromPropertyName121:(NSString *)propertyName
//{
//    // propertyName == myName == myHeight
//    if ([propertyName isEqualToString:@"ID"]) return @"id";
//
//    return propertyName;
//}



@end
