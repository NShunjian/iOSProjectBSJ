//
//  SUPCommentHeaderView.m
//  百思不得姐
//
//  Created by NShunJian on 2018/7/31.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPCommentHeaderView.h"

@interface SUPCommentHeaderView ()
/** uilabel */
@property (weak, nonatomic) UILabel *label;
@end

@implementation SUPCommentHeaderView

+ (instancetype)commentHeaderViewWithTableView:(UITableView *)tableView
{
    static NSString *const ID = @"headerfooterheader";
    ////先从缓存池中找到header  通过标识ID找
    SUPCommentHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    //给每一个header绑定一个标识   也就是说创建header的同时给他一个标识 (像这种的都一样 循环利用)
    if (header == nil) {
        header = [[SUPCommentHeaderView alloc] initWithReuseIdentifier:ID];
    }
    
    return header;
}

// 在里边添加一个label, 并且设置字体颜色  通过这个方法来创建header
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithReuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor darkTextColor];
        [self.contentView addSubview:label];
        
        self.label = label;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame = self.contentView.bounds;
    self.label.SUP_width = SUPScreenWidth -20;
    self.label.SUP_x = 10;
    self.label.backgroundColor = [UIColor RandomColor];
}

- (void)setTitle:(NSString *)title
{
    _title = title.copy;
    self.label.text = _title;
}

@end
