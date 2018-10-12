//
//  SUPAudioVoiceViewController.m
//  BSJProject
//
//  Created by NShunJian on 2018/9/18.
//  Copyright © 2018年 superMan. All rights reserved.
//

#import "SUPAudioVoiceViewController.h"
#import <FSAudioStream.h>
#import <AVFoundation/AVFoundation.h>
@interface SUPAudioVoiceViewController ()
//音频播放器
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property(nonatomic, strong)AVPlayer *player;
@property (nonatomic, strong) FSAudioStream *audioStream;
@end

@implementation SUPAudioVoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self buildStreamer];
   
}
- (void)buildStreamer
{
    weakSELF;
    // 网络文件
    NSURL *url = [NSURL URLWithString:@"http://wvoice.spriteapp.cn/voice/2018/0914/5b9b62cb390a8.mp3"];
    
    if (!_audioStream) {
        
        // 创建FSAudioStream对象
        _audioStream = [[FSAudioStream alloc] initWithUrl:url];
        _audioStream.onFailure = ^(FSAudioStreamError error,NSString *description){
            NSLog(@"播放过程中发生错误，错误信息：%@",description);
            
            [weakSelf showAlertMsg:description];
            
        };
        _audioStream.onCompletion=^(){
            
//            [weakSelf autoPlayNext];
        };
        
        [_audioStream play];
    }
    else
    {
        _audioStream.url = url;
        [_audioStream play];
    }
    
//    self.sliderView.nowTimeLabel.text = @"00:00";
//    self.sliderView.totalTimeLabel.text = @"00:00";
//
//    if (!self.timer) {
//        //进度条
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(playerProgress) userInfo:nil repeats:YES];
//    }
//    else
//    {
//        [self.timer setFireDate:[NSDate distantPast]];// 计时器开始
//    }
}

- (void)playerProgress
{
    FSStreamPosition position = self.audioStream.currentTimePlayed;
    
//    self.playTime = round(position.playbackTimeInSeconds);//四舍五入整数值
//
//    double minutes = floor(fmod(self.playTime/60.0,60.0));//返回不大于()中的最大整数值
//    double seconds = floor(fmod(self.playTime,60.0));
//
//    self.sliderView.nowTimeLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f",minutes, seconds];
//    self.sliderView.slider.value = position.position;//播放进度
//
//    self.totalTime = position.playbackTimeInSeconds/position.position;
//    //判断分母为空时的情况
//    if ([[NSString stringWithFormat:@"%ld",self.totalTime] isEqualToString:@"nan"]) {
//
//        self.sliderView.totalTimeLabel.text = @"00:00";
//    }
//    else
//    {
//
//        double minutes2 = floor(fmod(self.totalTime/60.0,60.0));
//        double seconds2 = floor(fmod(self.totalTime,60.0));
//        self.sliderView.totalTimeLabel.text = [NSString stringWithFormat:@"%02.0f:%02.0f",minutes2, seconds2];
//    }
//
//
    
}

@end
