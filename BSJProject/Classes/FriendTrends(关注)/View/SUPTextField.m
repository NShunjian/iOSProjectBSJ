//
//  BSJProject
//
//  Created by NShunJian on 2018/8/5.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPTextField.h"
static NSString * const SUPPlacerholderColorKeyPath = @"_placeholderLabel.textColor";

@implementation SUPTextField
// 重写这个方法 draw 画上去
//- (void)drawPlaceholderInRect:(CGRect)rect
//{
//    [self.placeholder drawInRect:CGRectMake(0, 10, rect.size.width, 25) withAttributes:@{
//                                                       NSForegroundColorAttributeName : [UIColor grayColor],
//                                                       NSFontAttributeName : self.font}];
//}

//另一种  还有一种看百思
/**
 运行时(Runtime):
 * 苹果官方一套C语言库
 * 能做很多底层操作(比如访问隐藏的一些成员变量\成员方法....)
 */
- (void)awakeFromNib
{
    [super awakeFromNib];
    // 设置光标颜色和文字颜色一致
    self.tintColor = self.textColor;

    // 不成为第一响应者
    [self resignFirstResponder];

}
/**
 * 当前文本框聚焦时就会调用
 */
- (BOOL)becomeFirstResponder
{
    // 修改占位文字颜色
    [self setValue:self.textColor forKeyPath:SUPPlacerholderColorKeyPath];
    return [super becomeFirstResponder];
}

/**
 * 当前文本框失去焦点时就会调用
 */
- (BOOL)resignFirstResponder
{
    // 修改占位文字颜色
    [self setValue:[UIColor grayColor] forKeyPath:SUPPlacerholderColorKeyPath];
    return [super resignFirstResponder];
}

/**
 运行时(Runtime):
 * 苹果官方一套C语言库
 * 能做很多底层操作(比如访问隐藏的一些成员变量\成员方法....)
 */

@end
