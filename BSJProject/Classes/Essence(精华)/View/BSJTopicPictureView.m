//
//  BSJTopicPictureView.m
//
//  Created by NShunJian on 2018/7/31.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "BSJTopicPictureView.h"
#import "BSJTopicViewModel.h"
#import <M13ProgressViewRing.h>
#import "BSJPictureShowViewController.h"
#import "PresentAnimator.h"
#import <FLAnimatedImageView+WebCache.h>
#import "UIView+GestureCallback.h"
#import "GCD.h"
@interface BSJTopicPictureView ()

/** <#digest#> */
@property (weak, nonatomic) FLAnimatedImageView *pictureImageView;

/** <#digest#> */
@property (weak, nonatomic) M13ProgressViewRing *ringProgressView;

/** <#digest#> */
@property (weak, nonatomic) UIImageView *gifImageView;

/** <#digest#> */
@property (weak, nonatomic) UIButton *seeBigPictureButton;

@end

@implementation BSJTopicPictureView



- (void)setupUIOnce
{
    
    self.pictureImageView.contentMode = UIViewContentModeScaleToFill;
    
    self.clipsToBounds = YES;
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIImage *logo = [UIImage imageNamed:@"imageBackground"];
    
    [logo drawAtPoint:CGPointMake((rect.size.width - logo.size.width) * 0.5, 5)];
}


- (void)setTopicViewModel:(BSJTopicViewModel *)topicViewModel
{
    _topicViewModel = topicViewModel;
    // 1, gif
    self.gifImageView.hidden = !topicViewModel.topic.isGif;
    
    // 2, 查看大图
    self.seeBigPictureButton.hidden = !topicViewModel.isBigPicture;
    
    // 3, 处理进度,
    // 3.1 隐藏
    self.ringProgressView.hidden = (topicViewModel.downloadPictureProgress >= 1);
    
    // 3.2刷新进度立马
    [self.ringProgressView setProgress:topicViewModel.downloadPictureProgress animated:NO];
    SUPWeakSelf(self);
    // 判断是否为gif
//    NSString *extension = topicViewModel.topic.smallPicture.pathExtension;
//        if ([extension.lowercaseString isEqualToString:@"gif"]) {
//            NSData *data1 = UIImagePNGRepresentation(image);
//                    NSData *data1 = [NSData dataWithContentsOfURL:topicViewModel.topic.smallPicture];
//            FLAnimatedImage *animatedImage1 = [FLAnimatedImage animatedImageWithGIFData:data1];
//            self.pictureImageView.animatedImage = animatedImage1;
//
//        }
//    else
//    {
    
        [self.pictureImageView SUP_setImageWithURL:topicViewModel.topic.smallPicture thumbnailImageURL:topicViewModel.topic.smallPicture placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL *targetURL) {
            
            // 3.3储存 "每个模型" 的进度, topicViewModel
            topicViewModel.downloadPictureProgress = (CGFloat)receivedSize / expectedSize;
            SUPLog(@"topicViewModel.downloadPictureProgress=%f",topicViewModel.downloadPictureProgress);
            // 3.4给每个cell对应的模型进度赋值, self.topicViewModel, getter 获得
            [weakself.ringProgressView setProgress:weakself.topicViewModel.downloadPictureProgress animated:NO];
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            //如果gif没有反应,或者查看gif很卡可以把这个注释打开   (不知为什么加上之后会很卡)
//                NSString *extension = imageURL.pathExtension;
//                    if ([extension.lowercaseString isEqualToString:@"gif"]) {
//                        NSData *data1 = [NSData dataWithContentsOfURL:imageURL];
//                        [weakself animatedImageView:self.pictureImageView data:data1];
//                    }
            // 4, 处理大图, 必须是当前的模型
            if (!image || error || !weakself.topicViewModel.isBigPicture || weakself.topicViewModel != topicViewModel || weakself.topicViewModel.topic.isGif) {
                return ;
            }
            
            // 4.1 裁剪
            // 只要设置图片就会调用
            // 控制隐藏, 当是当前的模型的时候才隐藏
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                UIGraphicsBeginImageContextWithOptions(weakself.topicViewModel.pictureFrame.size, NO, 0);
                
                CGFloat w = weakself.topicViewModel.pictureFrame.size.width;
                
                CGFloat h = w * weakself.topicViewModel.topic.height / weakself.topicViewModel.topic.width;
                
                [image drawInRect:CGRectMake(0, 0, w, h)];
                
                UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
                
                UIGraphicsEndImageContext();
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    weakself.pictureImageView.image = newImage;
                    
                });
                
            });
            
        }];
//    }
}

- (void)animatedImageView:(FLAnimatedImageView *)imageView data:(NSData *)data {
    
    FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:data];
    //    imageView.frame           = CGRectMake(0, 0, gifImage.size.width, gifImage.size.height);
    //    imageView.center          = self.contentView.middlePoint;
    imageView.animatedImage   = gifImage;
    //    imageView.alpha           = 0.f;
    
    //    [UIView animateWithDuration:1.f animations:^{
    //
    //        imageView.alpha = 1.f;
    //    }];
}
- (FLAnimatedImageView *)pictureImageView
{
    if(_pictureImageView == nil)
    {
        FLAnimatedImageView *pictureImageView = [[FLAnimatedImageView alloc] init];
        _pictureImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:pictureImageView];
        _pictureImageView = pictureImageView;
        pictureImageView.runLoopMode = NSRunLoopCommonModes;
        [pictureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        
        pictureImageView.userInteractionEnabled = YES;
        
        SUPWeakSelf(self);
        [pictureImageView addTapGestureRecognizer:^(UITapGestureRecognizer *recognizer, NSString *gestureId) {
            
            BSJPictureShowViewController *showPicVc = [[BSJPictureShowViewController alloc] init];
            showPicVc.topicViewModel = weakself.topicViewModel;
            
            // 自写动画
            [PresentAnimator viewController:weakself.viewController presentViewController:showPicVc presentViewFrame:[UIScreen mainScreen].bounds animated:YES completion:nil animatedDuration:0.5 presentAnimation:^(UIView *presentedView, UIView *containerView, void (^completionHandler)(BOOL finished)) {
                
                presentedView.alpha = 0;
                [UIView animateWithDuration:0.5 animations:^{
                    presentedView.alpha = 1;
                } completion:^(BOOL finished) {
                    completionHandler(finished);
                }];
                
            } dismissAnimation:^(UIView *dismissView, void (^completionHandler)(BOOL finished)) {
                
                dismissView.alpha = 1;
                [UIView animateWithDuration:0.5 animations:^{
                    dismissView.alpha = 0;
                } completion:^(BOOL finished) {
                    completionHandler(finished);
                }];
                
            }];
            
        }];
        
    }
    return _pictureImageView;
}



- (M13ProgressViewRing *)ringProgressView
{
    if(_ringProgressView == nil)
    {
        M13ProgressViewRing *ringProgressView = [[M13ProgressViewRing alloc] init];
        [self insertSubview:ringProgressView belowSubview:self.pictureImageView];
        _ringProgressView = ringProgressView;
        
        
        /**@name Appearance*/
        /**The primary color of the `M13ProgressView`.*/
        //        @property (nonatomic, retain) UIColor *primaryColor;
        //        *The secondary color of the `M13ProgressView`.
        //        @property (nonatomic, retain) UIColor *secondaryColor;
        //
        //        *@name Properties
        //        *Wether or not the progress view is indeterminate.
        //        @property (nonatomic, assign) BOOL indeterminate;
        //        *The durations of animations in seconds.
        //        @property (nonatomic, assign) CGFloat animationDuration;
        
        
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


- (UIImageView *)gifImageView
{
    if(_gifImageView == nil)
    {
        UIImageView *gifImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common-gif"]];
        [self.pictureImageView addSubview:gifImageView];
        _gifImageView = gifImageView;
        
        [gifImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.offset(0);
            
        }];
        
    }
    return _gifImageView;
}
- (UIButton *)seeBigPictureButton
{
    if(_seeBigPictureButton == nil)
    {
        UIButton *btn = [[UIButton alloc] init];
        [self.pictureImageView addSubview:btn];
        _seeBigPictureButton = btn;
        
        [btn setBackgroundImage:[UIImage imageNamed:@"see-big-picture-background"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"see-big-picture"] forState:UIControlStateNormal];
        
        [btn setTitle:@"查看大图" forState:UIControlStateNormal];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.left.right.offset(0);
            make.height.mas_equalTo(34);
            
        }];
        
        btn.userInteractionEnabled = NO;
        
    }
    return _seeBigPictureButton;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUIOnce];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.autoresizingMask = UIViewAutoresizingNone;
    [self setupUIOnce];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setNeedsDisplay];
}

@end


/*
 self.ringProgressView.hidden = (topicViewModel.downloadPictureProgress >= 1);
 
 [self.ringProgressView setProgress:topicViewModel.downloadPictureProgress animated:NO];
 
 SUPWeak(self);
 [self.pictureImageView SUP_setImageWithURL:topicViewModel.topic.largePicture thumbnailImageURL:topicViewModel.topic.smallPicture placeholderImage:nil options:SDWebImageTransformAnimatedImage progress:^(NSInteger receivedSize, NSInteger expectedSize) {
 
 //关键步骤
 topicViewModel.downloadPictureProgress = (CGFloat)receivedSize / expectedSize;
 
 // 关键步骤
 [weakself.ringProgressView setProgress:weakself.topicViewModel.downloadPictureProgress animated:NO];
 
 
 } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
 
 if (error || !weakself.topicViewModel.isBigPicture || weakself.topicViewModel.topic.isGif || !image || weakself.topicViewModel != topicViewModel) { // 关键步骤,
 return ;
 }
 
 CGFloat w = weakself.topicViewModel.topic.width;
 CGFloat h = weakself.topicViewModel.pictureFrame.size.height / weakself.topicViewModel.pictureFrame.size.width * w;
 
 weakself.pictureImageView.image = [image imageByCropToRect:CGRectMake(0, 0, w, h)];
 
 }];
 */
