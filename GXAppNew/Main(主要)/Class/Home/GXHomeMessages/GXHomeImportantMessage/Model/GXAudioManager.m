//
//  GXAudioManager.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXAudioManager.h"

static GXAudioManager *manager = nil;

@interface GXAudioManager ()

@property (nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)NSTimer * timer;

@end

@implementation GXAudioManager
+(instancetype)shareManager{
    if (manager == nil) {

        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[GXAudioManager alloc]init];
            manager.player = [[AVPlayer alloc]init];
        });
    }
    return manager;
}
-(AVPlayer *)player{
    if (!_player ) {
        _player = [[AVPlayer alloc]init];
    }
    return _player;
}
-(void)play{
//    AVPlayerItem *item = self.itemArray[self.currentIndex];
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.audioUrl]];
    [self.player replaceCurrentItemWithPlayerItem:item];
    // 如果计时器已经存在了,说明已经在播放中,直接返回.
    // 对于已经存在的计时器,只有musicPause方法才会使之停止和注销.
    if (self.timer != nil) {
        return;
    }
    [self.player play];

    //播放后,开启一个计时器.
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    
}
-(void)timerAction:(NSTimer * )sender
{
    // 计时器的处理方法中,不断的调用代理方法,将播放进度返回出去.
    // 一定要掌握这种形式.
    [self.delegate getCurTiem:[self valueToString:[self getCurTime]] Totle:[self valueToString:[self getTotleTime]] Progress:[self getProgress]];
}
// 获取当前的播放时间
-(NSInteger)getCurTime
{
    if (self.player.currentItem) {
        // 用value/scale,就是AVPlayer计算时间的算法. 它就是这么规定的.
        // 下同.
        return self.player.currentTime.value / self.player.currentTime.timescale;
    }
    return 0;
}
// 获取总时长
-(NSInteger)getTotleTime
{
    CMTime totleTime = [self.player.currentItem duration];
    if (totleTime.timescale == 0) {
        return 1;
    }else
    {
        return totleTime.value /totleTime.timescale;
    }
}

// 获取当前播放进度
-(CGFloat)getProgress
{
    return (CGFloat)[self getCurTime]/ (CGFloat)[self getTotleTime];
}

// 将整数秒转换为 00:00 格式的字符串
-(NSString *)valueToString:(NSInteger)value
{
    return [NSString stringWithFormat:@"%.2ld:%.2ld",value/60,value%60];
}

-(void)stop{
    [self.player pause];
}
-(void)pause{
    [self.timer invalidate];
    self.timer = nil;
    [self.player pause];
}
//-(void)seekToTime:(CMTime)time{
//    [self.player seekToTime:time];
//}
// 跳转方法
-(void)seekToTimeWithValue:(CGFloat)value
{
    // 先暂停
    [self stop];
    // 跳转
    
    [self.player seekToTime:CMTimeMake(value * [self getTotleTime], 1) completionHandler:^(BOOL finished) {
        if (finished == YES) {
            [self play];
        }
    }];
}
-(void) endOfPlay:(NSNotification *)sender
{
    // 为什么要先暂停一下呢?
    // 看看 musicPlay方法, 第一个if判断,你能明白为什么吗?
    [self pause];
    [self.delegate endOfPlayAction];
}
@end
