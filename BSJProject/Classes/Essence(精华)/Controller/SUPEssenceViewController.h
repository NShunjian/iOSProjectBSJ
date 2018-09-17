//
//  SUPEssenceViewController.h
//  BSJProject
//
//  Created by NShunJian on 2018/7/31.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPBaseViewController.h"
#import "SUPTextViewController.h"
@interface SUPEssenceViewController : SUPTextViewController
@property(nonatomic, strong)NSArray *childVcs;
@property(strong, nonatomic)NSMutableArray<BSJTopicViewController *> *childController;
@end
