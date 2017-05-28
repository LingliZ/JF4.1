//
//  GXAudioManager.h
//  GXAppNew
//
//  Created by 王振 on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol MusicPlayToolsDelegate <NSObject>


-(void)getCurTiem:(NSString *)curTime Totle:(NSString *)totleTime Progress:(CGFloat)progress;

-(void)endOfPlayAction;

@end


@interface GXAudioManager : NSObject
//播放器
@property (nonatomic,strong,readonly)AVPlayer *player;
//播放列表
@property (nonatomic,strong)NSMutableArray *itemArray;
//当前下标
@property (nonatomic,assign)NSInteger currentIndex;
//播放的音频url
@property (nonatomic,strong)NSString *audioUrl;

@property(nonatomic,weak)id<MusicPlayToolsDelegate> delegate;

//播放
-(void)play;
//暂停
-(void)pause;
// 准备播放
-(void)musicPrePlay;
//跳转进度
//-(void)seekToTime:(CMTime)time;
-(void)seekToTimeWithValue:(CGFloat)value;
// 获取当前的播放时间
-(NSInteger)getCurTime;
// 获取总时长
-(NSInteger)getTotleTime;
-(CGFloat)getProgress;
//单利方法
+ (instancetype)shareManager;
-(NSString *)valueToString:(NSInteger)value;

@end
