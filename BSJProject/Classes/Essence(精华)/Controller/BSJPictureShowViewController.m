//
//  BSJPictureShowViewController.m
//  PLMMPRJK
//
//  Created by HuXuPeng on 2017/6/1.
//  Copyright © 2017年 GoMePrjk. All rights reserved.
//

#import "BSJPictureShowViewController.h"
#import "BSJTopicViewModel.h"
#import <M13ProgressViewRing.h>
#import <FLAnimatedImageView+WebCache.h>
#import "UIView+GestureCallback.h"

@interface BSJPictureShowViewController ()<UIScrollViewDelegate>
/** <#digest#> */
@property (weak, nonatomic) FLAnimatedImageView *pictureImageView;

/** <#digest#> */
@property (weak, nonatomic) M13ProgressViewRing *ringProgressView;

/** <#digest#> */
@property (weak, nonatomic) UIScrollView *scrollView;

/** <#digest#> */
@property (weak, nonatomic) UIButton *backButton;
@property (weak, nonatomic) UIButton *SaveButton;
@property (weak, nonatomic) UIButton *ReweetButton;
@end

@implementation BSJPictureShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.modalPresentationCapturesStatusBarAppearance = YES;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    BSJTopicViewModel *topicViewModel = self.topicViewModel;
    
    SUPWeakSelf(self);
    [self.view addTapGestureRecognizer:^(UITapGestureRecognizer *recognizer, NSString *gestureId) {
//        PopUp
        [weakself dismissViewControllerAnimated:YES completion:nil];
    }];
    
    // 3, 处理进度,
    // 3.1 隐藏
    self.ringProgressView.hidden = self.topicViewModel.downloadPictureProgress >= 1;
    
    // 3.2刷新进度立马
    [self.ringProgressView setProgress:self.topicViewModel.downloadPictureProgress animated:NO];
    
    [self.pictureImageView SUP_setImageWithURL:self.topicViewModel.topic.largePicture thumbnailImageURL:self.topicViewModel.topic.smallPicture placeholderImage:nil options:SDWebImageTransformAnimatedImage progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        // 3.3储存 "每个模型" 的进度
        topicViewModel.downloadPictureProgress = (CGFloat)receivedSize / expectedSize;
        
        // 3.4给每个cell对应的模型进度赋值
        [weakself.ringProgressView setProgress:self.topicViewModel.downloadPictureProgress animated:NO];
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        weakself.ringProgressView.hidden = self.topicViewModel.downloadPictureProgress >= 1;
    }];
    
    CGFloat picWidth = kScreenWidth;
    CGFloat picHeight = picWidth * self.topicViewModel.topic.height / self.topicViewModel.topic.width;
    picHeight = floor(picHeight);
    if (picHeight <= kScreenHeight) {
        self.pictureImageView.frame = CGRectMake(0, (kScreenHeight - picHeight) * 0.5, kScreenWidth, picHeight);
    } else {
        self.pictureImageView.frame = CGRectMake(0, 0, kScreenWidth, picHeight);
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, picHeight);
    [self backButton];
    [self SaveButton];
    [self ReweetButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.pictureImageView;
}

//- (void)scrollViewDidZoom:(UIScrollView *)scrollView
//{
//    if (self.pictureImageView.SUP_height < kScreenHeight) {
//        self.pictureImageView.SUP_centerY = kScreenHeight * 0.5;
//    }
//}

- (FLAnimatedImageView *)pictureImageView
{
    if(_pictureImageView == nil)
    {
        FLAnimatedImageView *pictureImageView = [[FLAnimatedImageView alloc] init];
        [self.scrollView addSubview:pictureImageView];
        _pictureImageView = pictureImageView;
        pictureImageView.userInteractionEnabled = YES;
        pictureImageView.contentMode = UIViewContentModeScaleToFill;
        pictureImageView.runLoopMode = NSRunLoopCommonModes;
    }
    return _pictureImageView;
}


- (UIScrollView *)scrollView
{
    if(_scrollView == nil)
    {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:scrollView];
        _scrollView = scrollView;
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.insets(UIEdgeInsetsZero);
        }];
        scrollView.delegate = self;
        scrollView.minimumZoomScale = 1;
        scrollView.maximumZoomScale = 2;
    }
    return _scrollView;
}


- (UIButton *)backButton
{
    if(_backButton == nil)
    {
        
        UIButton *btn = [UIButton new];
        [self.view addSubview:btn];
        _backButton = btn;
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:@"返回" forState: UIControlStateNormal];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.offset (20);
            make.size.mas_equalTo(CGSizeMake(44, 44));
        }];
        
        SUPWeakSelf(self);
        [btn addActionHandler:^(NSInteger tag) {
//            PopUp
            [weakself dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _backButton;
}
- (UIButton *)SaveButton
{
    if(_SaveButton == nil)
    {
        
        UIButton *btn = [UIButton new];
        [self.view addSubview:btn];
        _SaveButton = btn;
        btn.backgroundColor = SUPRGBColor(128, 128, 128);
        [btn setTitle:@"保存" forState: UIControlStateNormal];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.right.offset (-20);
            make.size.mas_equalTo(CGSizeMake(70, 25));
        }];
        
        SUPWeakSelf(self);
        [btn addActionHandler:^(NSInteger tag) {
            if (weakself.pictureImageView.image == nil) {
                [SVProgressHUD showErrorWithStatus:@"图片并没下载完毕!"];
                return;
            }
            
            // 将图片写入相册
            UIImageWriteToSavedPhotosAlbum(self.pictureImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];
    }
    return _SaveButton;
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败!"];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"保存成功!"];
    }
}
- (UIButton *)ReweetButton
{
    if(_ReweetButton == nil)
    {
        
        UIButton *btn = [UIButton new];
        [self.view addSubview:btn];
        _ReweetButton = btn;
        btn.backgroundColor = SUPRGBColor(128, 128, 128);
        [btn setTitle:@"转发" forState: UIControlStateNormal];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.offset (-100);
            make.bottom.offset(-20);
            make.size.mas_equalTo(CGSizeMake(70, 25));
        }];
        
//        SUPWeakSelf(self);
        [btn addActionHandler:^(NSInteger tag) {
            
        }];
    }
    return _ReweetButton;
}
- (M13ProgressViewRing *)ringProgressView
{
    if(_ringProgressView == nil)
    {
        M13ProgressViewRing *ringProgressView = [[M13ProgressViewRing alloc] init];
        [self.view insertSubview:ringProgressView atIndex:0];
        _ringProgressView = ringProgressView;
        
        ringProgressView.backgroundRingWidth = 5;
        ringProgressView.progressRingWidth = 5;
        ringProgressView.showPercentage = YES;
        ringProgressView.primaryColor = [UIColor redColor];
        ringProgressView.secondaryColor = [UIColor yellowColor];
        
        [ringProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.center.centerOffset(CGPointZero);
            make.size.mas_equalTo(CGSizeMake(80, 80));
        }];
        
    }
    return _ringProgressView;
}


@end
