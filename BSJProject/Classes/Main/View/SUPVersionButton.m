//
//  SUPVersionButton.m
//  不得姐
//
//  Created by NShunJian on 16/11/18.
//  Copyright © 2016年 cui. All rights reserved.
//


/*
 按钮的高度增高 竖子方向图片文字之间的距离就会增大 , 可以在xib里对应约束修改即可
 谁使用就把 这个自定义button类 替换到xib里button的Class类里即可
 */
#import "SUPVersionButton.h"

@implementation SUPVersionButton

-(void)setup{

    self.titleLabel.textAlignment = NSTextAlignmentCenter;

}


-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        [self setup];
        
    }

    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setup];

}


-(void)layoutSubviews{
    [super layoutSubviews];
    // 调整图片
    self.imageView.SUP_x = 0;
    self.imageView.SUP_y = 0;
    self.imageView.SUP_width = self.SUP_width;
    self.imageView.SUP_height = self.imageView.SUP_width;
    
    
    // 调整文字
    self.titleLabel.SUP_x = 0;
    self.titleLabel.SUP_y = self.imageView.SUP_height;
    self.titleLabel.SUP_width = self.SUP_width;
    self.titleLabel.SUP_height = self.SUP_height - self.titleLabel.SUP_y;
}

//另外一种写法  图片自身有宽高
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//
//    // 调整图片
//    self.imageView.x = 0;
//    self.imageView.y = 0;
//
//    // 调整文字
//    self.titleLabel.x = 0;
//    self.titleLabel.y = self.imageView.height;
//    self.titleLabel.width = self.width;
//    self.titleLabel.height = self.height - self.titleLabel.y;
//}
@end
