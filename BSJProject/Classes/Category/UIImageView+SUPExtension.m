//
//  UIImageView+SUPExtension.m
//  BSJProject
//
//  Created by NShunJian on 2018/7/29.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "UIImageView+SUPExtension.h"
#import <UIImageView+WebCache.h>
#import "UIImage+SUPExtension.h"
@implementation UIImageView (SUPExtension)
- (void)setHeader:(NSString *)url
{
    UIImage *placeholder = [[UIImage imageNamed:@"defaultUserIcon"] circleImage];
    [self sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.image = image ? [image circleImage] : placeholder;
    }];
}
@end
