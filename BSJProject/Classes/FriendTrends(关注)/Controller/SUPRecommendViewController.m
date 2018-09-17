//
//  SUPRecommendViewController.m
//  BSJProject
//
//  Created by NShunJian on 2018/8/4.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPRecommendViewController.h"
#import "SUPRecommendCategoryCell.h"
#import "SUPRecommendCategory.h"
#import "SUPRequestManager.h"
#import "SUPRecommendUserCell.h"
#import "SUPRecommendUser.h"
//        SUPSelectedCategory 直接是从数组中取出来的,是id类型 不能使用点语法只能使用这种方式[SUPSelectedCategory users]来调用
#define SUPSelectedCategory self.categories[self.categoryTableView.indexPathForSelectedRow.row]

@interface SUPRecommendViewController ()<UITableViewDataSource, UITableViewDelegate>
/** 左边的类别数据 */
@property (nonatomic, strong) NSArray *categories;
/** 右边的用户数据 */
//@property (nonatomic, strong) NSArray *users;
/** 请求参数 */
@property (nonatomic, strong) NSMutableDictionary *params;
/** 左边的类别表格 */
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;
/** 右边的用户表格 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@end

@implementation SUPRecommendViewController
static NSString * const SUPCategoryId = @"category";
static NSString * const SUPUserId = @"user";
- (void)viewDidLoad {
    [super viewDidLoad];
//    SUPRecommendCategory *c = [[SUPRecommendCategory alloc]init];
//    SUPRecommendCategory *c1 = [[SUPRecommendCategory alloc]init];
//    NSArray *arr= @[@1,@2,@3];
//    NSArray *arr1= @[@5,@6];
//    NSArray *arr2= @[@11,@222,@43];
//    [c.users addObjectsFromArray:arr];
//    [c1.users addObjectsFromArray:arr1];
//    [c.users addObjectsFromArray:arr2];
//    SUPLog(@"%@",c.users);
    // 控件的初始化
    [self setupTableView];
    // 添加刷新控件
    [self setupRefresh];
    
    // 加载左侧的类别数据
    [self loadCategories];
    
}
/**
 * 控件的初始化
 */
- (void)setupTableView
{
   
    // 注册
    [self.categoryTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SUPRecommendCategoryCell class]) bundle:nil] forCellReuseIdentifier:SUPCategoryId];
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([SUPRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:SUPUserId];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categoryTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categoryTableView.contentInset;
    self.userTableView.rowHeight = 70;
}
/**
 * 加载左侧的类别数据
 */
- (void)loadCategories
{
    // 显示指示器
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    // 发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    [[SUPRequestManager sharedManager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params completion:^(SUPBaseResponse *response) {
        // 隐藏指示器
        [SVProgressHUD dismiss];
        SUPLog(@"%@",response.responseObject);
        if (!response.error) {
            // 服务器返回的JSON数据
            self.categories = [SUPRecommendCategory mj_objectArrayWithKeyValuesArray:response.responseObject[@"list"]];
            //         刷新表格
            [self.categoryTableView reloadData];
            //         默认选中首行
            [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            // 让用户表格进入下拉刷新状态
            [self.userTableView.mj_header beginRefreshing];
        }
        
        if (response.error) {
            // 显示失败信息
            [SVProgressHUD showErrorWithStatus:@"加载推荐信息失败!"];
        }
    }];
}
/**
 * 添加刷新控件
 */
- (void)setupRefresh
{
    

    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    
    self.userTableView.mj_footer.hidden = YES;
}

#pragma mark - 加载用户数据

- (void)loadNewUsers
{
    SUPRecommendCategory *rc = SUPSelectedCategory;
    
    // 设置当前页码为1
    
    rc.currentPage = 1;
    
    // 发送请求给服务器, 加载右侧的数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(rc.ID);
    params[@"page"] = @(rc.currentPage);
    self.params = params;
    
    [[SUPRequestManager sharedManager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params completion:^(SUPBaseResponse *response) {
        if (!response.error) {
            NSArray *users = [SUPRecommendUser mj_objectArrayWithKeyValuesArray:response.responseObject[@"list"]];
            // 清除所有旧数据
            [rc.users removeAllObjects];
            // 添加到当前类别对应的用户数组中 因为每一个模型数据都有对应的users数组,所以不会被覆盖掉,储存着各自的数据 相当于给模型里的字段赋值,记录了这个数据
            [rc.users addObjectsFromArray:users];
            
            // 保存总数
            rc.total = [response.responseObject[@"total"] integerValue];
            
            [self.userTableView.mj_header endRefreshing];
            // 不是最后一次请求 (当点击[网红],紧接着又点击[工作室],self.params记录的是最后一次点击参数, 紧接着[网红]的数据回来了也就是params 这时候做个对比 不相等就return,然后[工作室]的数据回来了相等就继续)
            if (self.params != params) return;
            
            // 刷新右边的表格
            [self.userTableView reloadData];
            
            // 结束刷新
            [self.userTableView.mj_header endRefreshing];
            
            // 让底部控件结束刷新
            [self checkFooterState];
        }
        if (response.error) {
            if (self.params != params) return;
            
            // 提醒
            [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
            
            // 结束刷新
            [self.userTableView.mj_header endRefreshing];
        }
    }];
}

- (void)loadMoreUsers
{
    SUPRecommendCategory *category = SUPSelectedCategory;
    
    // 发送请求给服务器, 加载右侧的数据
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.ID);
    params[@"page"] = @(++category.currentPage);
    self.params = params;
    
    [[SUPRequestManager sharedManager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params completion:^(SUPBaseResponse *response) {
        if (!response.error) {
            // 字典数组 -> 模型数组
            NSArray *users = [SUPRecommendUser mj_objectArrayWithKeyValuesArray:response.responseObject[@"list"]];
            
            // 添加到当前类别对应的用户数组中
            [category.users addObjectsFromArray:users];
            
            // 不是最后一次请求
            if (self.params != params) return;
            
            // 刷新右边的表格
            [self.userTableView reloadData];
            
            // 让底部控件结束刷新
            [self checkFooterState];
        }
        
        if (response.error) {
            if (self.params != params) return;
            
            // 提醒
            [SVProgressHUD showErrorWithStatus:@"加载用户数据失败"];
            
            // 让底部控件结束刷新
            [self.userTableView.mj_footer endRefreshing];
        }
    }];
    
}
/**
 * 时刻监测footer的状态
 */
- (void)checkFooterState
{
    SUPRecommendCategory *rc = SUPSelectedCategory;
    
    // 每次刷新右边数据时, 都控制footer显示或者隐藏
    self.userTableView.mj_footer.hidden = (rc.users.count == 0);
    
    // 让底部控件结束刷新
    if (rc.users.count == rc.total) { // 全部数据已经加载完毕
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
    } else { // 还没有加载完毕
        //结束刷新等待下次刷新
        [self.userTableView.mj_footer endRefreshing];
    }
}

#pragma mark - <UITableViewDataSource>
//每次刷新数据时都会走这个方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.categoryTableView) { // 左边的类别表格
        return self.categories.count;
        
    } else { // 右边的用户表格
//        SUPSelectedCategory 直接是从数组中取出来的,是id类型 不能使用点语法只能使用这种方式[SUPSelectedCategory users]来调用
        NSInteger count = [SUPSelectedCategory users].count;
        // 监测footer的状态
        [self checkFooterState];
        return count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == self.categoryTableView) { // 左边的类别表格
        SUPRecommendCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:SUPCategoryId];
        
        cell.category = self.categories[indexPath.row];
        
        return cell;
    } else { // 右边的用户表格
        SUPRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:SUPUserId];
//        SUPRecommendCategory *c = self.categories[self.categoryTableView.indexPathForSelectedRow.row];
        cell.user = [SUPSelectedCategory  users][indexPath.row];
        return cell;
    }

}
#pragma mark - <UITableViewDelegate>
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.userTableView == tableView) return;
    
    // 结束刷新
//    [self.userTableView.mj_header endRefreshing]; 这个地方用它 下拉会显示不全,具体原因不明
    [self.userTableView.mj_footer endRefreshing];
    
    SUPRecommendCategory *c = self.categories[indexPath.row];

    //        因为每一个模型数据都有对应的users数组,所以不会被覆盖掉,储存着各自的数据 ,相当于给模型里的字段赋值,记录了这个数据
    if(c.users.count){
        // 显示曾经的数据
        [self.userTableView reloadData];
    }else {
//    dispiatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
         // 赶紧刷新表格,目的是: 马上显示当前category的用户数据, 不让用户看见上一个category的残留数据
        [self.userTableView reloadData];
        
        // 进入下拉刷新状态
        [self.userTableView.mj_header beginRefreshing];
        
    }

}

#pragma mark - Delegate

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



/**头部标题*/
- (NSMutableAttributedString*)SUPNavigationBarTitle:(SUPNavigationBar *)navigationBar
{
    return [self changeTitle:@"推荐关注"];
}
/** 左边的按钮的点击 */
-(void)leftButtonEvent:(UIButton *)sender navigationBar:(SUPNavigationBar *)navigationBar
{
    [self.navigationController popViewControllerAnimated:NO];
}
/** 右边的按钮的点击 */
-(void)rightButtonEvent:(UIButton *)sender navigationBar:(SUPNavigationBar *)navigationBar
{
    
    NSLog(@"%s", __func__);
}
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

#pragma mark - 控制器的销毁
- (void)dealloc
{
    // 停止所有操作
    [[SUPRequestManager sharedManager].operationQueue cancelAllOperations];
}
@end
