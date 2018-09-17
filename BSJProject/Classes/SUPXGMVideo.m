//
//  SUPXGMVideo.m
//
//  Created by NShunJian on 2018/7/31.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPXGMVideo.h"

@implementation SUPXGMVideo

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

- (void)setImage:(NSURL *)image
{
    _image = [NSURL URLWithString:[SUPSUPBaseUrl stringByAppendingPathComponent:image.absoluteString]];
}

- (void)setUrl:(NSURL *)url
{
    _url = [NSURL URLWithString:[SUPSUPBaseUrl stringByAppendingPathComponent:url.absoluteString]];
}

@end
