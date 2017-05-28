//
//  GXLiveCastViewController.m
//  GXApp
//
//  Created by zhudong on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXLiveCastViewController.h"
#import <RtSDK/RtSDK.h>
#import "GXQuestionView.h"
#import "GXLiveCommonSize.h"
#import "GXSuggestionView.h"
#import "GXLoginByVertyViewController.h"
#import "GXAddCountIndexController.h"
#import "GXNoviceTutorialController.h"

#define kLiveCastHeight 244
#define kVideoControlViewHeight 30


@interface GXLiveCastViewController ()<GSBroadcastRoomDelegate, GSBroadcastVideoDelegate, GSBroadcastDesktopShareDelegate, GSBroadcastAudioDelegate,UIAlertViewDelegate, GXBottomToastTitleDelegate>
@property (nonatomic,assign) BOOL hasOrientation;
@property (nonatomic,assign) CGRect videoViewRect;
@property (nonatomic,strong) GSVideoView *videoView;
@property (nonatomic,strong) UIView *videoControlView;
@property (nonatomic,strong) UIButton *controlBtn;
@property (nonatomic,strong) GSConnectInfo *connectInfo;
@property (strong, nonatomic) GSBroadcastManager *broadcastManager;
@property (assign, nonatomic)long long currentActiveUserID; // 当前激活的视频ID
@property (assign, nonatomic)BOOL isCameraVideoDisplaying;
@property (assign, nonatomic)BOOL isLodVideoDisplaying;
@property (assign, nonatomic)BOOL isDesktopShareDisplaying;
@property (nonatomic,strong) UIView *coverView;
@property (atomic,assign) BOOL isInvalidate;
@property (nonatomic,strong) UIButton *closeBtn;
@property (assign, nonatomic)BOOL isHidden;
@property (nonatomic,strong) GXQuestionView *questionView;

@end

@implementation GXLiveCastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频直播";
//    self.navigationController.navigationBar.translucent = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotifyDoing:) name:LoginNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openRealAccountNotify) name:GXOpenRealAccountNotify object:nil];
    [self setupUI];
}

- (void)makeGuideView{
    GXNoviceTutorialController *vc = [[GXNoviceTutorialController alloc]init];
    vc.styles = @[@"GuideViewCleanModeCycleRect",
                  @"GuideViewCleanModeRoundRect"];
    if (IS_IPHONE_6P) {
        vc.btnFrames = @[@"{{20, 238},{335,50}}",
                         @"{{10, 696},{40,40}}"];
        vc.imgFrames = @[@"{{0, 258}, {414,100}}",
                         @"{{-10,570},{375,80}}"];
    }else if (IS_IPHONE_6){
        vc.btnFrames = @[@"{{20, 228},{335,50}}",
                         @"{{10, 623},{40,40}}"];
        vc.imgFrames = @[@"{{0, 258}, {414,100}}",
                         @"{{-10,520},{375,80}}"];
    }else{
        vc.btnFrames = @[@"{{20, 228},{335,50}}",
                         @"{{10, 525},{40,40}}"];
        vc.imgFrames = @[@"{{0, 248}, {414,100}}",
                         @"{{-10,435},{375,80}}"];
    }
    vc.images = @[@"newbie_guide_pic3",
                  @"newbie_guide_pic4",];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.isInvalidate = NO;
//    self.navigationController.navigationBar.translucent = NO;
//    self.navigationController.navigationBar.hidden = YES;
    [self initBroadCastManager];
    [[NSNotificationCenter defaultCenter] postNotificationName:OpenTimerNotify object:nil];
    if (![GXUserInfoTool isLogin]) {
        self.questionView.bottomToastTitle.hidden = NO;
        self.questionView.bottomToastTitle.titleLabel.text = @"注册并立实盘账户后享受分析师服务";
    }else{
        self.questionView.bottomToastTitle.hidden = YES;
    }
    
}
- (void)initBroadCastManager
{
    self.broadcastManager = [GSBroadcastManager sharedBroadcastManager];
    self.broadcastManager.broadcastRoomDelegate = self;
    self.broadcastManager.videoDelegate = self;
    self.broadcastManager.desktopShareDelegate = self;
    self.broadcastManager.audioDelegate = self;
    //
    __weak typeof (self) weakSelf = self;
    [GXHttpTool POST:GXUrl_customerInfo parameters:nil success:^(id responseObject) {
        NSString *success = responseObject[@"success"];
        if(success.intValue==1)
        {
            NSDictionary*valueDic=[responseObject objectForKey:@"value"];
            NSString *nickName = valueDic[@"liveNickname"];
            NSString *customerLevel = valueDic[@"customerLevel"];
            if (customerLevel.integerValue >= 3) {
                [GXUserdefult setObject:@(YES) forKey:GXIsRealCustom];
            }else{
                [GXUserdefult setObject:@(NO) forKey:GXIsRealCustom];
            }
            if (nickName.length > 0) {
                weakSelf.connectInfo.nickName = nickName;
            }else{
                weakSelf.connectInfo.nickName = [NSString stringWithFormat:@"游客%04zd",arc4random_uniform(10000)];
            }
            
        }else{
            [GXUserdefult setObject:@(NO) forKey:GXIsRealCustom];
            weakSelf.connectInfo.nickName = [NSString stringWithFormat:@"游客%04zd",arc4random_uniform(10000)];
        }
        [GXUserdefult setObject:weakSelf.connectInfo.nickName forKey:GXVisitorName];
        [weakSelf connectBroadcast];
        [[NSNotificationCenter defaultCenter] postNotificationName:GXLoadAccount object:nil];
    } failure:^(NSError *error) {
        [GXUserdefult setObject:@(NO) forKey:GXIsRealCustom];
        weakSelf.connectInfo.nickName = [NSString stringWithFormat:@"游客%04zd",arc4random_uniform(10000)];
        [GXUserdefult setObject:weakSelf.connectInfo.nickName forKey:GXVisitorName];
        [weakSelf connectBroadcast];
    }];
}

- (void)connectBroadcast{
    if (![_broadcastManager connectBroadcastWithConnectInfo:self.connectInfo]) {
        [self.coverView removeFromSuperview];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"WrongConnectInfo", @"参数配置不正确") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"知道了") otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)openRealAccountNotify{
    GXAddCountIndexController *addC = [[GXAddCountIndexController alloc] init];
    [self.navigationController pushViewController:addC animated:true];
}

- (void)loginNotifyDoing:(NSNotification *)notify{
    GXLoginByVertyViewController *loginVC = [[GXLoginByVertyViewController alloc] init];
    loginVC.registerStr = GXSiteLiveSuggest;
    NSDictionary *dict = notify.userInfo;
    loginVC.type = dict[@"eventName"];
    [MobClick event:dict[@"eventName"]];
    [self.navigationController pushViewController:loginVC animated:true];
}

- (void)keyboardWillChangeFrameNotification:(NSNotification *)notify{
    NSDictionary *keyboardDict = notify.userInfo;
    CGRect keyboardFrame = [keyboardDict[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    ;
    CGFloat offsetY = keyboardFrame.origin.y - GXScreenHeight;
    self.view.transform = CGAffineTransformMakeTranslation(0, offsetY);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.hidden = false;
//    self.navigationController.navigationBar.translucent = false;
    [self.coverView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] postNotificationName:CloseTimerNotify object:nil];
    
    [self.broadcastManager leaveAndShouldTerminateBroadcast:NO];
    [self.broadcastManager invalidate];
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (GSConnectInfo *)connectInfo{
    if (_connectInfo == nil) {
        _connectInfo = [[GSConnectInfo alloc] init];
        _connectInfo.domain = @"guoxin.gensee.com";
        _connectInfo.serviceType = GSBroadcastServiceTypeWebcast;
        _connectInfo.loginName = @"nickName";
        _connectInfo.loginPassword = @"333333";
        
        _connectInfo.roomNumber = @"21119590";
//        26447339
//         _connectInfo.roomNumber = @"48690876";
        _connectInfo.watchPassword = @"333333";
        _connectInfo.oldVersion = YES;
    }
    return _connectInfo;
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.isInvalidate) {
            [self.broadcastManager invalidate];
            GXLog(@"self.broadcastManager invalidate");
        }
    });
#warning 调试
//    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark GSBroadcastRoomDelegate


// 直播初始化代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastConnectResult:(GSBroadcastConnectResult)result
{
    NSString *errorMsg = nil;
    
    [self.coverView removeFromSuperview];
    if ([[GXUserdefult objectForKey:GXIsFristLiveVideo] boolValue] == NO) {
        [self makeGuideView];
        [GXUserdefult setObject:@(YES) forKey:GXIsFristLiveVideo];
    }
    switch (result) {
        case GSBroadcastConnectResultSuccess:
            
            // 直播初始化成功，加入直播
            [self.broadcastManager setLogLevel:GSLogLevelError];
            [self.broadcastManager activateSpeaker];
            BOOL result = [self.broadcastManager join];
            if (!result) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:  @"操作过于频繁,请退出直播后重新进入" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                alertView.delegate = self;
                [alertView show];
            }
            break;
            
        case GSBroadcastConnectResultInitFailed:
        {
            errorMsg = @"初始化出错";
            break;
        }
            
        case GSBroadcastConnectResultJoinCastPasswordError:
        {
            errorMsg = @"口令错误";
            break;
        }
            
        case GSBroadcastConnectResultWebcastIDInvalid:
        {
            errorMsg = @"webcastID错误";
            break;
        }
            
        case GSBroadcastConnectResultRoleOrDomainError:
        {
            errorMsg = @"口令错误";
            break;
        }
            
        case GSBroadcastConnectResultLoginFailed:
        {
            errorMsg = @"登录信息错误";
            break;
        }
            
            
        case GSBroadcastConnectResultNetworkError:
        {
            errorMsg = @"网络错误";
            break;
        }
            
        case GSBroadcastConnectResultWebcastIDNotFound:
        {
            
            errorMsg = @"找不到对应的webcastID，roomNumber, domain填写有误";
            break;
        }
            
        case  GSBroadcastConnectResultThirdTokenError:
        {
            errorMsg = @"第三方验证错误";
            break;
        }
        default:
        {
            errorMsg = @"未知错误";
            break;
        }
            
    }
    
    
    if (errorMsg) {
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
        
    }
}

/*
 直播连接代理
 rebooted为YES，表示这次连接行为的产生是由于根服务器重启而导致的重连
 */
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveBroadcastJoinResult:(GSBroadcastJoinResult)joinResult selfUserID:(long long)userID rootSeverRebooted:(BOOL)rebooted;
{
    
    NSString * errorMsg = nil;
    
    switch (joinResult) {
            
            /**
             *  直播加入成功
             */
            
        case GSBroadcastJoinResultSuccess:
        {
            // 服务器重启导致重连的相应处理
            // 服务器重启的重连，直播中的各种状态将不再保留，如果想要实现重连后恢复之前的状态需要在本地记住，然后再重连成功后主动恢复。
            if (rebooted) {
                
                
            }
            
            break;
        }
            
            /**
             *  未知错误
             */
        case GSBroadcastJoinResultUnknownError:
            errorMsg = @"未知错误";
            break;
            /**
             *  直播已上锁
             */
        case GSBroadcastJoinResultLocked:
            errorMsg = @"直播已上锁";
            break;
            /**
             *  直播组织者已经存在
             */
        case GSBroadcastJoinResultHostExist:
            errorMsg = @"直播组织者已经存在";
            break;
            /**
             *  直播成员人数已满
             */
        case GSBroadcastJoinResultMembersFull:
            errorMsg = @"直播成员人数已满";
            break;
            /**
             *  音频编码不匹配
             */
        case GSBroadcastJoinResultAudioCodecUnmatch:
            errorMsg = @"音频编码不匹配";
            break;
            /**
             *  加入直播超时
             */
        case GSBroadcastJoinResultTimeout:
            errorMsg = @"加入直播超时";
            break;
            /**
             *  ip被ban
             */
        case GSBroadcastJoinResultIPBanned:
            errorMsg = @"ip地址被ban";
            
            break;
            /**
             *  组织者还没有入会，加入时机太早
             */
        case GSBroadcastJoinResultTooEarly:
            errorMsg = @"直播尚未开始";
            break;
            
        default:
            errorMsg = @"未知错误";
            break;
    }
    
    if (errorMsg) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alertView show];
        
    }
    
}


// 断线重连
- (void)broadcastManagerWillStartRoomReconnect:(GSBroadcastManager*)manager
{
    
}


// 直播状态改变代理
- (void)broadcastManager:(GSBroadcastManager *)manager didSetStatus:(GSBroadcastStatus)status
{
    
}

// 自己离开直播代理
- (void)broadcastManager:(GSBroadcastManager*)manager didSelfLeaveBroadcastFor:(GSBroadcastLeaveReason)leaveReason
{
    [_broadcastManager invalidate];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark GSBroadcastVideoDelegate

// 视频模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveVideoModuleInitResult:(BOOL)result
{
    
}

// 摄像头是否可用代理
- (void)broadcastManager:(GSBroadcastManager*)manager isCameraAvailable:(BOOL)isAvailable
{
    
}

// 摄像头打开代理
- (void)broadcastManagerDidActivateCamera:(GSBroadcastManager*)manager
{
    
}

// 摄像头关闭代理
- (void)broadcastManagerDidInactivateCamera:(GSBroadcastManager*)manager
{
    
}

// 收到一路视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserJoinVideo:(GSUserInfo *)userInfo
{
    // 判断是否是插播，插播优先级比摄像头视频大
    if (userInfo.userID == LOD_USER_ID)
    {
        //为了删掉最后一帧的问题， 收到新数据的时候GSVideoView的videoLayer自动创建
        [_videoView.videoLayer removeFromSuperlayer];
        _videoView.videoLayer = nil;
        
        // 如果之前有摄像头视频作为直播视频，先要取消订阅摄像头视频
        if (_isCameraVideoDisplaying) {
            [_broadcastManager undisplayVideo:_currentActiveUserID];
        }
        
        [_broadcastManager displayVideo:LOD_USER_ID];
        _isLodVideoDisplaying = YES;
    }
}

// 某个用户退出视频
- (void)broadcastManager:(GSBroadcastManager*)manager didUserQuitVideo:(long long)userID
{
    // 判断是否是插播结束
    if (userID == LOD_USER_ID)
    {
        //为了删掉最后一帧的问题， 收到新数据的时候GSVideoView的videoLayer自动创建
        [_videoView.videoLayer removeFromSuperlayer];
        _videoView.videoLayer = nil;
        
        _isLodVideoDisplaying = NO;
        
        // 如果之前有摄像头视频在直播，需要恢复之前的直播视频
        if (_currentActiveUserID != 0) {
            [_broadcastManager displayVideo:_currentActiveUserID];
        }
        
        
    }
    
}

// 某一路摄像头视频被激活
- (void)broadcastManager:(GSBroadcastManager*)manager didSetVideo:(GSUserInfo*)userInfo active:(BOOL)active
{
    
    if (active)
    {
        // 桌面共享和插播的优先级比摄像头视频大
        if (!_isDesktopShareDisplaying && !_isLodVideoDisplaying) {
            
            // 订阅当前激活的视频
            [_broadcastManager displayVideo:userInfo.userID];
            _currentActiveUserID = userInfo.userID;
            _isCameraVideoDisplaying = YES;
            _videoView.videoLayer.hidden = NO;
        }
    }
    else
    {
        if (userInfo.userID == _currentActiveUserID) {
            _isCameraVideoDisplaying = NO;
            _currentActiveUserID = 0;
            [_broadcastManager undisplayVideo:userInfo.userID];
            _videoView.videoLayer.hidden = YES;
        }
    }
}

// 某一路视频被订阅代理
- (void)broadcastManager:(GSBroadcastManager*)manager didDisplayVideo:(GSUserInfo*)userInfo
{
    
}

// 某一路视频取消订阅代理
- (void)broadcastManager:(GSBroadcastManager*)manager didUndisplayVideo:(long long)userID
{
}


// 摄像头或插播视频每一帧的数据代理，软解
- (void)broadcastManager:(GSBroadcastManager*)manager userID:(long long)userID renderVideoFrame:(GSVideoFrame*)videoFrame
{
    // 指定Videoview渲染每一帧数据
    @try {
         [_videoView renderVideoFrame:videoFrame];
    } @catch (NSException *exception) {
        GXLog(@"%@", exception);
    } @finally {
        
    }
   
}


// 硬解数据从这个代理返回
- (void)OnVideoData4Render:(long long)userId width:(int)nWidth nHeight:(int)nHeight frameFormat:(unsigned int)dwFrameFormat displayRatio:(float)fDisplayRatio data:(void *)pData len:(int)iLen
{
    
    
    // 指定Videoview渲染每一帧数据
    @try {
        [_videoView hardwareAccelerateRender:pData size:iLen dwFrameFormat:dwFrameFormat];
    } @catch (NSException *exception) {
        GXLog(@"%@", exception);
    } @finally {
        
    }
}

/**
 *  手机摄像头开始采集数据
 *
 *  @param manager 触发此代理的GSBroadcastManager对象
 */
- (BOOL)broadcastManagerDidStartCaptureVideo:(GSBroadcastManager*)manager
{
    return NO;
}

/**
 手机摄像头停止采集数据
 */
- (void)broadcastManagerDidStopCaptureVideo:(GSBroadcastManager*)manager
{
}
#pragma mark -
#pragma mark GSBroadcastDesktopShareDelegate

// 桌面共享视频连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveDesktopShareModuleInitResult:(BOOL)result;
{
}

// 开启桌面共享代理
- (void)broadcastManager:(GSBroadcastManager*)manager didActivateDesktopShare:(long long)userID
{
    _isDesktopShareDisplaying = YES;
    
    _videoView.videoLayer.hidden = YES;
    _videoView.movieASImageView.hidden = NO;
    
    // 桌面共享时，需要主动取消订阅当前直播的摄像头视频
    if (_currentActiveUserID != 0) {
        [_broadcastManager undisplayVideo:_currentActiveUserID];
    }
}


// 桌面共享视频每一帧的数据代理, 软解数据
- (void)broadcastManager:(GSBroadcastManager*)manager renderDesktopShareFrame:(UIImage*)videoFrame
{
    // 指定Videoview渲染每一帧数据
    if (_isDesktopShareDisplaying) {
        [_videoView renderAsVideoByImage:videoFrame];
    }
    
}

/**
 *  桌面共享每一帧的数据, 硬解； 暂不支持
 *
 */
- (void)OnAsData:(unsigned char*)data dataLen: (unsigned int)dataLen width:(unsigned int)width height:(unsigned int)height
{
    
}

// 桌面共享关闭代理
- (void)broadcastManagerDidInactivateDesktopShare:(GSBroadcastManager*)manager
{
    _videoView.videoLayer.hidden = YES;
    _videoView.movieASImageView.hidden = YES;
    
    // 如果桌面共享前，有摄像头视频在直播，需要在结束桌面共享后恢复
    if (_currentActiveUserID != 0)
    {
        _videoView.videoLayer.hidden = NO;
        [_broadcastManager displayVideo:_currentActiveUserID];
    }
    _isDesktopShareDisplaying = NO;
}

#pragma mark -
#pragma mark GSBroadcastAudioDelegate

// 音频模块连接代理
- (void)broadcastManager:(GSBroadcastManager*)manager didReceiveAudioModuleInitResult:(BOOL)result
{
    
}

#pragma mark - GXBottomToastTitleDelegate

- (void)gotoLoginOrOpenAcount {
    GXLoginByVertyViewController *loginVC = [[GXLoginByVertyViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
}

#pragma mark - setupUI
- (void)setupUI{
    [self setupPlayerVideo];
//    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    closeBtn.frame = CGRectMake(10, 20, 30, 30);
//    self.closeBtn = closeBtn;
//    [closeBtn setImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
//    closeBtn.titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
//    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.view addSubview:closeBtn];
//    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    GXQuestionView *questionView = [[GXQuestionView alloc] init];
    self.questionView = questionView;
    questionView.bottomToastTitle.delegate = self;
    
    [self.view addSubview:questionView];
    [self.view sendSubviewToBack:questionView];
    [questionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.videoView.mas_bottom);
    }];
    
    UIView *coverView = [[UIView alloc] initWithFrame:self.view.bounds];
    coverView.backgroundColor = [UIColor colorWithWhite:1 alpha:1];
    [coverView showLoadingWithTitle:@"正在加载中..."];
    self.coverView = coverView;
    [self.view addSubview:coverView];
    
}


- (void)setupPlayerVideo
{
    self.videoViewRect = CGRectMake(0, 0, GXScreenWidth, kLiveCastHeight);
    self.videoView = [[GSVideoView alloc]initWithFrame:self.videoViewRect];
    self.videoView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.videoView];
    UIView *controlV = [[UIView alloc] init];
    controlV.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:controlV];
    [controlV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.videoView);
        make.height.equalTo(@(kVideoControlViewHeight));
    }];
    [self.view bringSubviewToFront:controlV];
    controlV.hidden = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.controlBtn = btn;
    [btn setImage:[UIImage imageNamed:@"fullScreen_icon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(controlBtnClick) forControlEvents:UIControlEventTouchUpInside];
    btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [controlV addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(controlV);
        make.right.equalTo(controlV).offset(-GXMargin);
    }];

    self.videoControlView = controlV;
    
    self.hasOrientation = NO;
    //单击显示控制页面
    UITapGestureRecognizer *oneTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTapAction)];
    oneTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.videoView addGestureRecognizer:oneTapGestureRecognizer];
    //双击全屏
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rotationVideoView)];
    tapGes.numberOfTapsRequired = 2;
    [self.videoView addGestureRecognizer:tapGes];
    self.videoView.videoViewContentMode = GSVideoViewContentModeRatioFit;
}

- (void)controlBtnClick{
    [self rotationVideoView];
}

#pragma mark - videoView
- (void)oneTapAction{
    [self.view endEditing:YES];
//    self.closeBtn.hidden = NO;
    self.videoControlView.hidden = NO;
    self.videoControlView.alpha = 1;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.25 animations:^{
            self.videoControlView.alpha = 0;
        } completion:^(BOOL finished) {
            self.videoControlView.hidden = YES;
//            self.closeBtn.hidden = true;
        }];
        
    });
}

- (void)rotationVideoView {
    [self.view endEditing:YES];//收起键盘
    self.isHidden = !self.isHidden;
    //强制旋转
    if (!self.hasOrientation) {
        [self.view bringSubviewToFront:self.videoView];
        [self.view bringSubviewToFront:self.videoControlView];
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformMakeRotation(M_PI/2);
            
            self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            self.videoView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
            
            UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            backBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.height - 50, 10, 40, 40);
            [backBtn setImage:[UIImage imageNamed:@"priceNoAdd"] forState:UIControlStateNormal];
            [backBtn addTarget:self action:@selector(backBtnDidClicked) forControlEvents:UIControlEventTouchUpInside];
//            [backBtn setBackgroundColor:[UIColor redColor]];
            [self.videoView addSubview:backBtn];
            self.navigationController.navigationBar.hidden = YES;

            self.hasOrientation = YES;
            [self.controlBtn setImage:[UIImage imageNamed:@"smallScreen"] forState:UIControlStateNormal];
            [self setNeedsStatusBarAppearanceUpdate];
            [self.view bringSubviewToFront:self.closeBtn];
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self.view.transform = CGAffineTransformInvert(CGAffineTransformMakeRotation(0));
            self.view.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            self.videoView.frame = self.videoViewRect;
            self.hasOrientation = NO;
            [self.controlBtn setImage:[UIImage imageNamed:@"fullScreen_icon"] forState:UIControlStateNormal];
            [self setNeedsStatusBarAppearanceUpdate];
            [self.view bringSubviewToFront:self.closeBtn];
            self.navigationController.navigationBar.hidden = NO;
        }];
    }
}

- (BOOL)prefersStatusBarHidden{
    return self.isHidden;
}

- (void)backBtnDidClicked {
    [self rotationVideoView];
}

//- (void)closeBtnClick{
//    [self.navigationController popViewControllerAnimated:true];
//}
@end
