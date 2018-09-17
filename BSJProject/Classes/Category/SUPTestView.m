//
//  SUPTestView.m
//  BSJProject
//
//  Created by NShunJian on 2018/7/29.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPTestView.h"

@implementation SUPTestView

+ (instancetype)testView
{
    return [[self alloc] init];
}

//在这里重写完之后外界是不能修改的

- (void)setFrame:(CGRect)frame
{
    frame.size = CGSizeMake(100, 100);
    [super setFrame:frame];
}

- (void)setBounds:(CGRect)bounds
{
    bounds.size = CGSizeMake(100, 100);
    [super setBounds:bounds];
}

@end
