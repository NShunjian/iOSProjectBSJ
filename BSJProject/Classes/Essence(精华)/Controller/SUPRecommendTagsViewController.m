//
//  SUPRecommendTagsViewController.m
//  BSJProject
//
//  Created by NShunJian on 2018/8/6.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPRecommendTagsViewController.h"
#import "SUPRecommendTag.h"
#import "SUPRecommendTagCell.h"
@interface SUPRecommendTagsViewController ()
/** 标签数据 */
@property (nonatomic, strong) NSArray *tags;

@end
static NSString * const SUPTagsId = @"tag";
@implementation SUPRecommendTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableView];
    
    [self loadTags];
}

- (void)loadTags
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    // 请求参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    
    // 发送请求
     [[SUPRequestManager sharedManager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params completion:^(SUPBaseResponse *response) {
         if (!response.error) {
             self.tags = [SUPRecommendTag mj_objectArrayWithKeyValuesArray:response.responseObject];
             [self.tableView reloadData];
         }
        
        [SVProgressHUD dismiss];
       if (response.error) {
            [SVProgressHUD showErrorWithStatus:@"加载标签数据失败!"];
       }
    }];
}

- (void)setupTableView
{
    self.title = @"推荐标签";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SUPRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:SUPTagsId];
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = SUPRGBColor(223, 223, 223);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tags.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SUPRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:SUPTagsId];
    
    cell.recommendTag = self.tags[indexPath.row];
    
    return cell;
}
#pragma mark - DataSource
/**头部标题*/
- (NSMutableAttributedString*)SUPNavigationBarTitle:(SUPNavigationBar *)navigationBar
{
    return [self changeTitle:@"我的关注"];
}

/** 背景图片 */
//- (UIImage *)SUPNavigationBarBackgroundImage:(SUPNavigationBar *)navigationBar
//{
//
//}

/** 背景色 */
//- (UIColor *)SUPNavigationBackgroundColor:(SUPNavigationBar *)navigationBar
//{
//
//}

/** 是否隐藏底部黑线 */
- (BOOL)SUPNavigationIsHideBottomLine:(SUPNavigationBar *)navigationBar
{
    return NO;
}

/** 导航条的高度 */
//- (CGFloat)SUPNavigationHeight:(SUPNavigationBar *)navigationBar
//{
//
//}


/** 导航条的左边的 view */
//- (UIView *)SUPNavigationBarLeftView:(SUPNavigationBar *)navigationBar
//{
//
//}
/** 导航条右边的 view */
//- (UIView *)SUPNavigationBarRightView:(SUPNavigationBar *)navigationBar
//{
//
//}
///** 导航条中间的 View */
//- (UIView *)SUPNavigationBarTitleView:(SUPNavigationBar *)navigationBar
//{
//    return [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
//}
/** 导航条左边的按钮 */
- (UIImage *)SUPNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(SUPNavigationBar *)navigationBar
{
    [leftButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    leftButton.size = CGSizeMake(70, 44);
    // 让按钮内部的所有内容左对齐
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //        [button sizeToFit];
    // 让按钮的内容往左边偏移10
    leftButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    leftButton.backgroundColor = [UIColor redColor];
    [leftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];

    return nil;
}
///** 导航条右边的按钮 */
//- (UIImage *)SUPNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(SUPNavigationBar *)navigationBar
//{
//    [rightButton setTitle:@"百度" forState:UIControlStateNormal];
//
//    [rightButton setTitleColor:[UIColor RandomColor] forState:UIControlStateNormal];
//    return nil;
//}



#pragma mark - Delegate
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(SUPNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:NO];
    NSLog(@"======");
}
///** 右边的按钮的点击 */
//-(void)rightButtonEvent:(UIButton *)sender navigationBar:(SUPNavigationBar *)navigationBar
//{
//
//    NSLog(@"%s", __func__);
//}
/** 中间如果是 label 就会有点击 */
-(void)titleClickEvent:(UILabel *)sender navigationBar:(SUPNavigationBar *)navigationBar
{
    NSLog(@"%s", __func__);
}


#pragma mark 自定义代码

-(NSMutableAttributedString *)changeTitle:(NSString *)curTitle
{   if(curTitle){
    
}
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:curTitle ?: @""];
    
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, title.length)];
    
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, title.length)];
    
    return title;
}



@end
