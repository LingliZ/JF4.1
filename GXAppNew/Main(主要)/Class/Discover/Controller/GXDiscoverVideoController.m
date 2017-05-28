//
//  GXDiscoverVideoController.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#if SIMULATOR == 0
#import "GXDiscoverVideoController.h"
#import <VodSDK/VodSDK.h>
#import "MBProgressHUD.h"

@interface GXDiscoverVideoController ()<VodDownLoadDelegate, VodPlayDelegate, UIAlertViewDelegate>
{
    BOOL isVideoFinished;
    float videoRestartValue;
    BOOL isDragging;
    BOOL isPlaying;
    int totalDuration;
}
@property (nonatomic, strong) VodDownLoader *voddownloader;
@property (nonatomic, strong) downItem *item;
@property (nonatomic, strong) VodPlayer *vodplayer;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *playBtn;
@end

@implementation GXDiscoverVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self changeOrientation:UIDeviceOrientationLandscapeLeft];
    self.navigationItem.title = self.title;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home_calendar_left_arrow_pic"] style:UIBarButtonItemStylePlain target:self action:@selector(btnClick)];
    [self setDownLoader];
    
}

- (void)btnClick{
    if (self.vodplayer) {
        [self.vodplayer stop];
    }
    [self changeOrientation:UIDeviceOrientationPortrait];
    self.navigationController.navigationBar.hidden = false;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:true];
    });
}

- (void)changeOrientation: (UIDeviceOrientation )position{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice] setValue:@(position) forKey:@"orientation"];
    }
}

- (BOOL)prefersStatusBarHidden{
    return true;
}

- (void)setDownLoader{
    if (!self.voddownloader) {
        self.voddownloader = [[VodDownLoader alloc] init];
    }
    self.voddownloader.delegate = self;
    [self.voddownloader addItem:@"guoxin.gensee.com" number:nil loginName:nil vodPassword:@"333333" loginPassword:nil vodid:self.videoAddress downFlag:1 serType:@"webcast" oldVersion:NO kToken:nil customUserID:0];
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
}

#pragma mark - VodDownLoadDelegate
//添加item的回调方法
- (void)onAddItemResult:(RESULT_TYPE)resultType voditem:(downItem *)item
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (resultType == RESULT_SUCCESS) {
        self.item = item;
        [self play];
    }else if (resultType == RESULT_ROOM_NUMBER_UNEXIST){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"点播间不存在" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_FAILED_NET_REQUIRED){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"网络请求失败" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_FAIL_LOGIN){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"用户名或密码错误" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_NOT_EXSITE){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"该点播的编号的点播不存在" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_INVALID_ADDRESS){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"无效地址" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_UNSURPORT_MOBILE){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"不支持移动设备" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }else if (resultType == RESULT_FAIL_TOKEN){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"口令错误" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
        [alertView show];
    }
    
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self btnClick];
}
- (void)play{
    downItem *Litem = [[VodManage shareManage]findDownItem:_item.strDownloadID];
    
    if (Litem) {
        if (self.vodplayer) {
            [self.vodplayer stop];
            self.vodplayer = nil;
        }
        
        if (!self.vodplayer) {
            self.vodplayer = [[VodPlayer alloc]init];
        }
        self.vodplayer.playItem = Litem;
        [self setupUI];
        self.vodplayer.delegate = self;
        [self.vodplayer OnlinePlay:YES audioOnly:NO];
        [VodManage shareManage];
    }
}

- (void)setupUI{
    self.vodplayer.mVideoView = [[VodGLView alloc]initWithFrame:CGRectMake(0, -64, GXScreenWidth, GXScreenHeight)];
    self.vodplayer.mVideoView.movieASImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.vodplayer.mVideoView];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTapAction:)];
    [self oneTapAction:tapGes];
    [self.vodplayer.mVideoView addGestureRecognizer:tapGes];
    UIView *bottomV = [[UIView alloc] init];
    UISlider *slider = [[UISlider alloc] init];
    [slider setThumbImage:[UIImage imageNamed:@"home_slider_pic"] forState:UIControlStateNormal];
    [slider addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [slider addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventValueChanged];
    self.slider = slider;
    UIButton *playBtn = [[UIButton alloc] init];
    self.playBtn = playBtn;
    [playBtn setImage:[UIImage imageNamed:@"home_audio_stop_pic"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.text = @"00:00";
    timeLabel.textColor = [UIColor whiteColor];
    self.timeLabel = timeLabel;
    [bottomV addSubview:slider];
    [bottomV addSubview:playBtn];
    [bottomV addSubview:timeLabel];
    bottomV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [self.view addSubview:bottomV];
    self.bottomView = bottomV;
    
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@64);
    }];
    
    [slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@(0.3 * GXMargin));
    }];
    
    [playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(slider.mas_bottom).offset(0);
        make.left.equalTo(@(GXMargin));
        make.width.height.equalTo(@30);
    }];
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(playBtn);
        make.left.equalTo(playBtn.mas_right).offset(GXMargin);
    }];
}

- (void)playBtnClick: (UIButton *)btn{
    isPlaying = !isPlaying;
    if (isPlaying) {
        [self.vodplayer pause];
        self.slider.userInteractionEnabled = false;
        [btn setImage:[UIImage imageNamed:@"home_audio_play_pic"] forState:UIControlStateNormal];
    }else{
        [self.vodplayer resume];
        self.slider.userInteractionEnabled = true;
        [btn setImage:[UIImage imageNamed:@"home_audio_stop_pic"] forState:UIControlStateNormal];
    }
}

- (void)sliderTouchDown: (UISlider *)slider{
    isDragging = true;
    if (isPlaying) {
        [self playBtnClick:self.playBtn];
    }
}

- (void)sliderTouchUp:(UISlider *)slider{
    
    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", [self getTimeStr:slider.value], [self getTimeStr:totalDuration]];
    isDragging = false;
    [self oneTapAction:nil];
    if (isVideoFinished) {
        [self.vodplayer OnlinePlay: false audioOnly:NO];
    }
    float duration = slider.value;
    videoRestartValue = slider.value;
    [self.vodplayer seekTo:duration];
    
    [self.playBtn setImage:[UIImage imageNamed:@"home_audio_stop"] forState:UIControlStateNormal];
}
- (void)closeBtnClick{
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark -VodPlayDelegate
//初始化VodPlayer代理
- (void)onInit:(int)result haveVideo:(BOOL)haveVideo duration:(int)duration docInfos:(NSDictionary *)docInfos
{
    self.slider.minimumValue = 0;
    self.slider.maximumValue = duration;
    totalDuration = duration;
    self.timeLabel.text = [NSString stringWithFormat:@"00:00/%@", [self getTimeStr:duration]];
    
    if (isVideoFinished) {
        isVideoFinished = NO;
        [self.vodplayer seekTo:videoRestartValue];
    }

}

- (void) onPosition:(int) position{
    if (isDragging) {
        return;
    }
    self.slider.value = position;
    self.timeLabel.text = [NSString stringWithFormat:@"%@/%@", [self getTimeStr:position], [self getTimeStr:totalDuration]];
}

//播放完成停止通知，
- (void)onStop{
    isVideoFinished = YES;
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"播放结束" ,@"") delegate:self cancelButtonTitle:NSLocalizedString(@"知道了",@"") otherButtonTitles:nil, nil];
    [alertView show];
}

- (BOOL)shouldAutorotate{
    return true;
}

//消失
- (void)oneTapAction:(UIGestureRecognizer *)gestureRecognizer
{
    if (isDragging) {
        return;
    }
    self.bottomView.hidden = false;
    self.bottomView.alpha = 1;
    self.navigationController.navigationBar.hidden = false;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (isDragging) {
            return;
        }
        [UIView animateWithDuration:1 animations:^{
            self.bottomView.alpha = 0;
        } completion:^(BOOL finished) {
            self.bottomView.hidden = true;
            self.navigationController.navigationBar.hidden = true;
        }];
    });
}

- (NSString *)getTimeStr: (int)time{
    return [NSString stringWithFormat:@"%02zd:%02zd", time /60/60/60, (time/60/60)%60];
}
@end

#endif
