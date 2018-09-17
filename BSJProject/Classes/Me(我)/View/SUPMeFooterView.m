//
//  SUPMeFooterView.m
//  BSJProject
//
//  Created by NShunJian on 2018/7/29.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPMeFooterView.h"
#import <AFNetworking.h>
#import "SUPSquare.h"
#import <MJExtension.h>
#import "SUPSqaureButton.h"
#import "SUPWebViewContr.h"

@implementation SUPMeFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        // 参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
        
        // 发送请求
        [[SUPRequestManager sharedManager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params completion:^(SUPBaseResponse *response) {
            SUPLog(@"%@",response);
            NSArray *sqaures = [SUPSquare mj_objectArrayWithKeyValuesArray:response.responseObject[@"square_list"]];
            SUPLog(@"%zd",sqaures.count);
            // 创建方块
            [self createSquares:sqaures];
        }];
//        [[SUPRequestManager sharedManager] GET: parameters:params success:^(NSURLSessionDataTask *task, NSDictionary *responseObject) {
//
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//
//        }];
    }
    return self;
}

/**
 * 创建方块
 */
- (void)createSquares:(NSArray *)sqaures
{
    // 一行最多4列
    int maxCols = 4;
    
    // 宽度和高度
    CGFloat buttonW = SUPScreenWidth / maxCols;
    CGFloat buttonH = buttonW;
    
    for (int i = 0; i<sqaures.count; i++) {
        // 创建按钮
        SUPSqaureButton *button = [SUPSqaureButton buttonWithType:UIButtonTypeCustom];
        // 监听点击
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        // 传递模型
        button.square = sqaures[i];
        [self addSubview:button];
        
        // 计算frame
        int col = i % maxCols;
        int row = i / maxCols;

        button.SUP_x = col * buttonW;
        button.SUP_y = row * buttonH;
        button.width = buttonW;
        button.height = buttonH;
    }
    
    // 8个方块, 每行显示4个, 计算行数 8/4 == 2 2
    // 9个方块, 每行显示4个, 计算行数 9/4 == 2 3
    // 7个方块, 每行显示4个, 计算行数 7/4 == 1 2
    
    // 总行数
//    NSUInteger rows = sqaures.count / maxCols;
//    if (sqaures.count % maxCols) { // 不能整除, + 1
//        rows++;
//    }
    
    // 总页数 == (总个数 + 每页的最大数 - 1) / 每页最大数
    
    NSUInteger rows = (sqaures.count + maxCols - 1) / maxCols;
    
    // 计算footer的高度
    self.height = rows * buttonH;
    
    // 重绘
    [self setNeedsDisplay];
}

- (void)buttonClick:(SUPSqaureButton *)button
{
    if (![button.square.url hasPrefix:@"http"]) return;
    
    SUPWebViewContr *web = [[SUPWebViewContr alloc] init];
    web.url = button.square.url;
    web.title = button.square.name;
    
    // 取出当前的导航控制器
    UITabBarController *tabBarVc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)tabBarVc.selectedViewController;
    [nav pushViewController:web animated:YES];
}

// 设置背景图片
//- (void)drawRect:(CGRect)rect
//{
//    [[UIImage imageNamed:@"mainCellBackground"] drawInRect:rect];
//}

@end
