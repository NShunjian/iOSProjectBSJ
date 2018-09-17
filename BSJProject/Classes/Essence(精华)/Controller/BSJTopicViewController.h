//
//  BSJTopicViewController.h
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/5/14.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "SUPRefreshTableViewController.h"
#import "BSJ.h"
#import "ZJScrollPageViewDelegate.h"
@interface BSJTopicViewController : SUPRefreshTableViewController<ZJScrollPageViewChildVcDelegate>

/** <#digest#> */
@property (assign, nonatomic) BSJTopicType topicType;

/** <#digest#> */
@property (nonatomic, copy) NSString *areaType;

@end
