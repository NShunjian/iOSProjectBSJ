//
//  SUPMeViewController.m
//  BSJProject
//
//  Created by NShunJian on 2018/7/31.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPMeViewController.h"
#import "BSJMeSquare.h"
#import "BSJMeSquareCell.h"
#import "SUPWebViewController.h"
#import "SUPCollectionViewCell.h"
#import "SUPSettingViewController.h"
@interface SUPMeViewController ()<SUPElementsFlowLayoutDelegate,SUPVerticalFlowLayoutDelegate>
/** <#digest#> */
@property (strong, nonatomic) UIButton *backBtn;

/** <#digest#> */
@property (strong, nonatomic) UIButton *closeBtn;
@property (nonatomic, strong) NSMutableArray<NSValue *> *elementsHight;

/** <#digest#> */
@property (nonatomic, strong) NSMutableArray<BSJMeSquare *> *meSquares;

/** <#digest#> */
@property (weak, nonatomic) SUPRequestManager *requestManager;

@property(nonatomic, strong)NSMutableDictionary *cellIdentifierDic;

@end

@implementation SUPMeViewController
{
    UIImageView *_ImageV;
    UIImageView *_ImageVi;
    UIImageView *_ImageVa;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //为了防止重复写在了uicollectionCell里面
//    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BSJMeSquareCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([BSJMeSquareCell class])];
//    self.collectionView.backgroundColor = [UIColor whiteColor];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
      [self getDatas];
}
- (void)getDatas
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"square";
    params[@"c"] = @"topic";
    
    SUPWeakSelf(self);
    [self.requestManager GET:BSJBaiSiJieHTTPAPI parameters:params completion:^(SUPBaseResponse *response) {
        
        NSError *error = response.error;
        
        if (error) {
            [weakself.view makeToast:response.errorMsg];
        }
        
        [weakself.meSquares removeAllObjects];
        [weakself.meSquares addObjectsFromArray:[BSJMeSquare mj_objectArrayWithKeyValuesArray:response.responseObject[@"square_list"]]];
        [weakself.meSquares removeObjectAtIndex:weakself.meSquares.count-1];
         SUPLog(@"%zd",self.meSquares.count);
        [self.collectionView reloadData];
    }];
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.elementsHight.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
 //第一种
    //防重复
//    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%ld%ld",indexPath.section,indexPath.row];
//
//    [self.collectionView registerNib:[UINib nibWithNibName:@"BSJMeSquareCell" bundle:nil] forCellWithReuseIdentifier:CellIdentifier];
//
//    // 通过不同标识创建cell实例
//    BSJMeSquareCell *squareCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
 
    
   //第二种
    //防重复
    NSString *identifier = [_cellIdentifierDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];

    if(identifier == nil){

        identifier = [NSString stringWithFormat:@"selectedBtn%@", [NSString stringWithFormat:@"%@", indexPath]];

        [_cellIdentifierDic setObject:identifier forKey:[NSString  stringWithFormat:@"%@",indexPath]];

        // 注册Cell（把对cell的注册写在此处）

//        [self.collectionView registerClass:[BSJMeSquareCell class] forCellWithReuseIdentifier:identifier];
        [self.collectionView registerNib:[UINib nibWithNibName:@"BSJMeSquareCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    }

    BSJMeSquareCell *squareCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    if(!squareCell){
        squareCell = [[[NSBundle mainBundle]loadNibNamed:@"BSJMeSquareCell" owner:self options:nil]lastObject];
//        owner可以为空
    }
//    注：在使用UITableViewCell时同样可以用这样的方法来解决再次不再具体说明：
   
    
    if (indexPath.item == 0) {
  
//        if(identifier == nil){
//
//            identifier = [NSString stringWithFormat:@"selectedBtn%@", [NSString stringWithFormat:@"%@", indexPath]];
//
//            [_cellIdentifierDic setObject:identifier forKey:[NSString  stringWithFormat:@"%@",indexPath]];
//
//            // 注册Cell（把对cell的注册写在此处）
//
//            //        [self.collectionView registerClass:[BSJMeSquareCell class] forCellWithReuseIdentifier:identifier];
//            [self.collectionView registerNib:[UINib nibWithNibName:@"SUPCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
//        }
//        SUPCollectionViewCell *squareCell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//
//            if(!squareCell){
//                squareCell = [[[NSBundle mainBundle]loadNibNamed:@"SUPCollectionViewCell" owner:self options:nil]lastObject];
//        //        owner可以为空
//            }
        squareCell.contentView.backgroundColor = [UIColor whiteColor];
        
            if (![squareCell.contentView viewWithTag:100]) {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 30)];
                label.tag = 100;
                label.textColor = [UIColor grayColor];
                label.font = [UIFont boldSystemFontOfSize:17];
                [squareCell.contentView addSubview:label];
            }
        
            UILabel *label = [squareCell.contentView viewWithTag:100];
//arrow_
            label.text = @"登录/注册";
        if (![squareCell.contentView viewWithTag:1021]) {
            _ImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setup-head-default"]];
            _ImageV.SUP_x = 10;
            _ImageV.SUP_centerY = label.SUP_centerY;
            _ImageV.SUP_width = 36;
            _ImageV.SUP_height = 36;
            _ImageV.tag = 1021;
            [squareCell.contentView addSubview:_ImageV];
        }
        _ImageV = [squareCell.contentView viewWithTag:1021];
        if (![squareCell.contentView viewWithTag:1022]) {
            _ImageVi = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_"]];
            _ImageVi.SUP_x = SUPScreenWidth-50;
            _ImageVi.SUP_centerY = label.SUP_centerY;
            _ImageVi.SUP_width = 12;
            _ImageVi.SUP_height = 16;
            _ImageVi.tag = 1022;
            [squareCell.contentView addSubview:_ImageVi];
        }
        _ImageVi = [squareCell.contentView viewWithTag:1022];
        
        
           return squareCell;
    }else if (indexPath.item == 1){

         squareCell.contentView.backgroundColor = [UIColor whiteColor];
        if (![squareCell.contentView viewWithTag:102]) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 30)];
            label.tag = 102;
            label.textColor = [UIColor grayColor];
            label.font = [UIFont boldSystemFontOfSize:17];
            [squareCell.contentView addSubview:label];
        }
        
        UILabel *label = [squareCell.contentView viewWithTag:102];

        label.text = @"离线下载";
        if (![squareCell.contentView viewWithTag:1023]) {
            _ImageVa = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_"]];
            _ImageVa.SUP_x = SUPScreenWidth-50;
            _ImageVa.SUP_centerY = label.SUP_centerY;
            _ImageVa.SUP_width = 12;
            _ImageVa.SUP_height = 16;
            _ImageVa.tag = 1023;
            [squareCell.contentView addSubview:_ImageVa];
        }
        _ImageVa = [squareCell.contentView viewWithTag:1023];
        
           return squareCell;
    }else{

            squareCell.meSquare = self.meSquares[indexPath.item-2];
           return squareCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if (indexPath.item==0||indexPath.item==1) {
        NSLog(@"%@", @"self.meSquares[indexPath.row].url.absoluteString");

    }else{
        SUPWebViewController *webVc = [[SUPWebViewController alloc] init];
    webVc.gotoURL = self.meSquares[indexPath.row-2].url.absoluteString;
    [self.navigationController pushViewController:webVc animated:YES];
         NSLog(@"%@", self.meSquares[indexPath.row-2].url.absoluteString);
    }
   
}

#pragma mark - SUPElementsFlowLayoutDelegate

- (CGSize)waterflowLayout:(SUPElementsFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.elementsHight[indexPath.item].CGSizeValue;
}

- (UIEdgeInsets)waterflowLayout:(SUPElementsFlowLayout *)waterflowLayout edgeInsetsInCollectionView:(UICollectionView *)collectionView
{
    
    return UIEdgeInsetsMake(10, 10, 60, 10);
}

/**
 *  列间距, 默认10
 */
- (CGFloat)waterflowLayout:(SUPVerticalFlowLayout *)waterflowLayout columnsMarginInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
/**
 *  行间距, 默认10
 */
- (CGFloat)waterflowLayout:(SUPVerticalFlowLayout *)waterflowLayout collectionView:(UICollectionView *)collectionView linesMarginForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}

#pragma mark - SUPCollectionViewControllerDataSource

- (UICollectionViewLayout *)collectionViewController:(SUPCollectionViewController *)collectionViewController layoutForCollectionView:(UICollectionView *)collectionView
{
    SUPElementsFlowLayout *elementsFlowLayout = [[SUPElementsFlowLayout alloc] initWithDelegate:self];
    
    return elementsFlowLayout;
}

- (NSMutableArray<NSValue *> *)elementsHight
{
    SUPLog(@"%zd",self.meSquares.count);
    
        NSMutableArray<NSValue *> * elementsHight = [NSMutableArray array];
   
        for (NSInteger i = 0; i < self.meSquares.count; i++) {
            
//            if (i == 0) {
//
//                [_elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 50)]];
//
//            }else if (i == 1)
//            {
//
//                [_elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 50)]];
//
//            }else
//            {
            
                [elementsHight addObject:[NSValue valueWithCGSize:CGSizeMake(([UIScreen mainScreen].bounds.size.width - 50) * 0.25, 110)]];
//            }
            
        }
    [elementsHight insertObject:[NSValue valueWithCGSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 50)] atIndex:0];
    [elementsHight insertObject:[NSValue valueWithCGSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 50)] atIndex:1];
    
    return elementsHight;
}

#pragma mark - DataSource
/**头部标题*/
- (NSMutableAttributedString*)SUPNavigationBarTitle:(SUPNavigationBar *)navigationBar
{
    return [self changeTitle:@"我的"];
}



/** 是否隐藏底部黑线 */
- (BOOL)SUPNavigationIsHideBottomLine:(SUPNavigationBar *)navigationBar
{
    return NO;
}

- (UIButton *)backBtn
{
    if(_backBtn == nil)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"mine-setting-icon"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"mine-setting-icon-click"] forState:UIControlStateHighlighted];
        
        btn.SUP_size = CGSizeMake(34, 44);
        
        [btn addTarget:self action:@selector(leftButton:navigationBar:) forControlEvents:UIControlEventTouchUpInside];
        
        _backBtn = btn;
    }
    return _backBtn;
}
- (UIButton *)closeBtn
{
    if(_closeBtn == nil)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitle:@"关闭" forState:UIControlStateNormal];
        
//        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//
//        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@"mine-moon-icon"] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:@"mine-moon-icon-click"] forState:UIControlStateHighlighted];
        btn.SUP_size = CGSizeMake(44, 44);
        
        //        btn.hidden = YES;
        
        [btn addTarget:self action:@selector(left_close_button_event:) forControlEvents:UIControlEventTouchUpInside];
        
        _closeBtn = btn;
    }
    return _closeBtn;
}
- (void)leftButton:(UIButton *)sender navigationBar:(SUPNavigationBar *)navigationBar
{
    SUPLogFunc
    [self.navigationController pushViewController:[[SUPSettingViewController alloc] initWithStyle:UITableViewStyleGrouped] animated:YES];
    
}

- (void)left_close_button_event:(UIButton *)sender
{
    SUPLogFunc
}
#pragma mark - SUPNavUIBaseViewControllerDataSource
#pragma mark - 设置右上角的一个返回按钮和一个关闭按钮
/** 导航条的左边的 view */
- (UIView *)SUPNavigationBarRightView:(SUPNavigationBar *)navigationBar
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 44)];
    
//    leftView.backgroundColor = [UIColor yellowColor];
    
    self.backBtn.mj_origin = CGPointZero;
    
    self.closeBtn.SUP_x = leftView.SUP_width - self.closeBtn.SUP_width;
    
    [leftView addSubview:self.backBtn];
    
    [leftView addSubview:self.closeBtn];
    
    return leftView;
}


#pragma mark - Delegate

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

- (NSMutableArray<BSJMeSquare *> *)meSquares
{
    if(_meSquares == nil)
    {
        _meSquares = [NSMutableArray array];
    }
    return _meSquares;
}

- (SUPRequestManager *)requestManager
{
    if(_requestManager == nil)
    {
        _requestManager = [SUPRequestManager sharedManager];
    }
    return _requestManager;
}


@end
