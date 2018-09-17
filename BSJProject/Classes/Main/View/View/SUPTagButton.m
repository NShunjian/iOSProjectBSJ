//
//  SUPTagButton.m
//  01-百思不得姐
//
//  Created by xiaomage on 15/8/5.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "SUPTagButton.h"

@implementation SUPTagButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
        self.backgroundColor = SUPRGBColor(74, 139, 209);
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    [self sizeToFit];
    
    self.width += 3 * SUPTagMargin;
    self.SUP_height = SUPTagH;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.SUP_x = SUPTagMargin;
    self.imageView.SUP_x = CGRectGetMaxX(self.titleLabel.frame) + SUPTagMargin;
}

@end
