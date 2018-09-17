//
//  SUPAddTagToolbar.m
//  01-百思不得姐
//
//  Created by xiaomage on 15/8/5.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "SUPAddTagToolbar.h"
#import "SUPAddTagViewController.h"

@interface SUPAddTagToolbar()
/** 顶部控件 */
@property (weak, nonatomic) IBOutlet UIView *topView;
/** 添加按钮 */
@property (weak, nonatomic) UIButton *addButton;
/** 存放所有的标签label */
@property (nonatomic, strong) NSMutableArray *tagLabels;
@end

@implementation SUPAddTagToolbar

- (NSMutableArray *)tagLabels
{
    if (!_tagLabels) {
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    // 添加一个加号按钮
    UIButton *addButton = [[UIButton alloc] init];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    addButton.size = addButton.currentImage.size;
    addButton.SUP_x = SUPTagMargin;
    [self.topView addSubview:addButton];
    self.addButton = addButton;
    
    // 默认就拥有2个标签
    [self createTagLabels:@[@"吐槽", @"糗事"]];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    for (int i = 0; i<self.tagLabels.count; i++) {
        UILabel *tagLabel = self.tagLabels[i];
        // 设置位置
        if (i == 0) { // 最前面的标签
            tagLabel.SUP_x = 0;
            tagLabel.SUP_y = 0;
        } else { // 其他标签
            UILabel *lastTagLabel = self.tagLabels[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + SUPTagMargin;
            // 计算当前行右边的宽度
            CGFloat rightWidth = self.topView.width - leftWidth;
            if (rightWidth >= tagLabel.width) { // 按钮显示在当前行
                tagLabel.SUP_y = lastTagLabel.SUP_y;
                tagLabel.SUP_x = leftWidth;
            } else { // 按钮显示在下一行
                tagLabel.SUP_x = 0;
                tagLabel.SUP_y = CGRectGetMaxY(lastTagLabel.frame) + SUPTagMargin;
            }
        }
    }
    
    // 最后一个标签
    UILabel *lastTagLabel = [self.tagLabels lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + SUPTagMargin;
    
    // 更新textField的frame
    if (self.topView.width - leftWidth >= self.addButton.width) {
        self.addButton.SUP_y = lastTagLabel.SUP_y;
        self.addButton.SUP_x = leftWidth;
    } else {
        self.addButton.SUP_x = 0;
        self.addButton.SUP_y = CGRectGetMaxY(lastTagLabel.frame) + SUPTagMargin;
    }
    
    // 整体的高度
    CGFloat oldH = self.height;
    self.height = CGRectGetMaxY(self.addButton.frame) + 45;
    self.SUP_y -= self.SUP_height - oldH;
    
}
- (void)addButtonClick
{
    SUPAddTagViewController *vc = [[SUPAddTagViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    [vc setTagsBlock:^(NSArray *tags) {
        [weakSelf createTagLabels:tags];
    }];
    vc.tags = [self.tagLabels valueForKeyPath:@"text"];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)root.presentedViewController;
    [nav pushViewController:vc animated:YES];
}

/**
 * 创建标签
 */
- (void)createTagLabels:(NSArray *)tags
{
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
    
    for (int i = 0; i<tags.count; i++) {
        UILabel *tagLabel = [[UILabel alloc] init];
        [self.tagLabels addObject:tagLabel];
        tagLabel.backgroundColor = SUPTagBg;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.text = tags[i];
        tagLabel.font = SUPTagFont;
        // 应该要先设置文字和字体后，再进行计算
        [tagLabel sizeToFit];
        tagLabel.SUP_width += 2 * SUPTagMargin;
        tagLabel.SUP_height = SUPTagH;
        tagLabel.textColor = [UIColor whiteColor];
        [self.topView addSubview:tagLabel];
       
    }
    
    // 重新布局子控件
    [self setNeedsLayout];
}

@end
