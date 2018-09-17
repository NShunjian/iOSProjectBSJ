//
//  SUPTopicCell.h
//  BSJProject
//
//  Created by NShunJian on 2018/8/9.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSJTopicViewModel.h"
@interface SUPTopicCell : UITableViewCell

+ (instancetype)topicCellWithTableView:(UITableView *)tableView;

/** <#digest#> */
@property (nonatomic, strong) BSJTopicViewModel *topicViewModel;



+ (instancetype)cell;
@end
