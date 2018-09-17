//
//  SUPRecommendUserCell.m
//  BSJProject
//
//  Created by NShunJian on 2018/8/5.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPRecommendUserCell.h"
#import "SUPRecommendUser.h"
@interface SUPRecommendUserCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;
@end

@implementation SUPRecommendUserCell

- (void)setUser:(SUPRecommendUser *)user
{
    _user = user;
    SUPLog(@"%@",user.screen_name);
    self.screenNameLabel.text = user.screen_name;
    self.fansCountLabel.text = [NSString stringWithFormat:@"%zd人关注", user.fans_count];
    [self.headerImageView setHeader:user.header];
//    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:user.header] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"]];
}

@end
