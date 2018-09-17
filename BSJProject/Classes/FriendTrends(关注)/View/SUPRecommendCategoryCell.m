//
//  SUPRecommendCategoryCell.m
//  BSJProject
//
//  Created by NShunJian on 2018/8/5.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPRecommendCategoryCell.h"
#import "SUPRecommendCategory.h"
@interface SUPRecommendCategoryCell()
/** 选中时显示的指示器控件 */

@property (weak, nonatomic) IBOutlet UIView *selectedIndicator;
@end

@implementation SUPRecommendCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = SUPRGBColor(244, 244, 244);
    self.selectedIndicator.backgroundColor = SUPRGBColor(219, 21, 26);
    
    // 当cell的selection为None时, cell被选中时, 内部的子控件就不会进入高亮状态
    //    self.textLabel.textColor = SUPRGBColor(78, 78, 78);
    //    self.textLabel.highlightedTextColor = SUPRGBColor(219, 21, 26);
    //    UIView *bg = [[UIView alloc] init];
    //    bg.backgroundColor = [UIColor clearColor];
    //    self.selectedBackgroundView = bg;
}

- (void)setCategory:(SUPRecommendCategory *)category
{
    _category = category;
    
    self.textLabel.text = category.name;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 重新调整内部textLabel的frame
    self.textLabel.SUP_y = 2;
    self.textLabel.SUP_height = self.contentView.SUP_height - 2 * self.textLabel.SUP_y;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    self.selectedIndicator.hidden = !selected;
    self.textLabel.textColor = selected ? self.selectedIndicator.backgroundColor : SUPRGBColor(78, 78, 78);
}

@end
