//
//  GXHomeController.m
//  GXAppNew
//
//  Created by futang yang on 2016/11/28.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeController.h"
#import "SDCycleScrollView.h"
#import "GXHomeAdvertistsModel.h"
#import "GXHomeUserStatisticsCell.h"
#import "GXHomeRemindRoomCell.h"
#import "GXImpMsgPagerView.h"
#import "UIParameter.h"
#import "GXHomePriceCell.h"
#import "GXHomeGettingStartCell.h"
#import "GXHomeCountDownCell.h"
#import "GXHomeUserStatisticsModel.h"
#import "GXHomeAnalystModel.h"
#import "GXHomeRemindRoomModel.h"
#import "GXHomeCountDownModel.h"
#import "GXHomeMsgCenterController.h"
#import "GXBanAnaRemImpDetailController.h"
#import "GXPriceListAddCodeViewController.h"
#import "ChatViewController.h"
#import "GXAddCountIndexController.h"
#import "GXAlertToLoginOrAddCountView.h"
#import "GXAirView.h"
#import "GXAirAdModel.h"
#import "AppDelegate+AppService.h"
#import "GXTabBarController.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "UIViewController+NetErrorTips.h"
#import "GXPriceDetailController.h"
#import "GXHomeImportantMessageController.h"
#import "GXHomeCalendarController.h"
#import "GXHomeBackView.h"
#import "PricePlatformModel.h"
#import "GXFileTool.h"
#import "PriceProductModel.h"
#import "GXNoviceTutorialController.h"
#import "GXHomePageToH5PageController.h"
#import "GXHelpCenterController.h"
@interface GXHomeController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,GXImpMsgPagerViewDelegate,GXAlertToLoginOrAddCountDelegate,GXAirViewDelegate, UIGestureRecognizerDelegate>

//title
@property (nonatomic,strong) UILabel *titleLabel;
//获客首页
@property (nonatomic,strong)UITableView *homeGetCustomesTableView;
@property (nonatomic,strong)SDCycleScrollView *homeCycleView;
@property (nonatomic,strong)NSMutableArray *cycleImageArray;
@property (nonatomic,strong)NSMutableArray *cycleTitleArray;
@property (nonatomic,strong)NSMutableArray *cycleDataArray;
@property (nonatomic,strong)GXImpMsgPagerView *homeNinaView;
@property (nonatomic,strong)GXImpMsgPagerView *homeFormalNinaView;
//用户统计数组
@property (nonatomic,strong)NSMutableArray *homeUserArray;
@property (nonatomic,strong)GXHomeUserStatisticsModel *userModel;
//分析师资料
@property (nonatomic,strong)NSMutableArray *homeAnalystArray;
//推荐播间模型
@property (nonatomic,strong)GXHomeRemindRoomModel *remindRoomModel;
//重要事件模型
@property (nonatomic,strong)GXHomeCountDownModel *countDownModel;
//是否有重要事件倒计时
@property (nonatomic,assign)BOOL isImportantEnvet;
//导航栏颜色变化View
//@property (nonatomic,strong)UIView *alphaView;
@property (nonatomic,assign)CGFloat alaph;
@property (nonatomic,strong)UIView *msgView1;
@property (nonatomic,strong)UIView *msgView2;
@property (nonatomic,strong)GXHomePriceCell *PriceCellGet;
@property (nonatomic,strong)GXHomePriceCell *PriceCellFormal;
//lastCell在屏幕中位置;
@property (nonatomic,assign)CGFloat lastCellHeight;
@property (nonatomic,strong)NSIndexPath *countDownPath;
//消息红点儿
@property (nonatomic,strong)UILabel *seviceWarningLabel;
@property (nonatomic,strong)UILabel *messageWarningLabel;
@property(nonatomic,strong)GXAlertToLoginOrAddCountView*view_AlertToLoginOrAddCount;
//我的消息按钮
@property (nonatomic,strong)UIButton *homeMineBtn;
@property (nonatomic,strong)UIImageView *homeMineUserView;
//浮窗广告
@property (nonatomic,strong)GXAirAdModel *homeAirModel;
@property (nonatomic,strong)GXAirView *homeAirView;
//判断是否是实盘用户:1是,0不是
@property (nonatomic,strong)NSNumber *realNumber;
//非获客首页
@property (nonatomic,strong)UITableView *homeFormalTableView;
@property (nonatomic,strong)SDCycleScrollView *homeFormalCycleView;
@property (atomic,assign)BOOL isShow;
//获客页偏移量
@property (nonatomic,assign)CGFloat lastTableViewOffsetY;
@property (nonatomic,strong)NSMutableArray *tableViews;
//NiNaView相关
@property (nonatomic,strong)NSArray *inColorArray;
@property (nonatomic,strong)NSArray *messageTitleArray;
@property (nonatomic,strong)NSArray *MsgclassNameArray;

@property (nonatomic,assign)BOOL isEnableScroll;
@property (nonatomic,assign)BOOL isEnableScrollFormal;
//增加的行情model跳转属性
@property (nonatomic,strong)NSMutableArray *PricePlatformArray;
//
@property (nonatomic,strong)NSNumber *isShowOpenAccount;

@end

@implementation GXHomeController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.alphaView.hidden = NO;
    self.msgView1.hidden = NO;
    self.msgView2.hidden = NO;
//    self.navigationController.navigationBar.translucent = YES;
    [self setHomeCutemerWarn];
    [self setHomeMsgWarning];
    [self loadPriceData];
    [self setHomeUserImage];
    [self addHomeMsgsObserverOfViewWillAppear];
    [[NSNotificationCenter defaultCenter] postNotificationName:SonEndScroll object:nil];
}
-(void)addHomeMsgsObserverOfViewWillAppear{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setHomeCutemerWarn) name:GXOnlineServiceCountNotificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setHomeMsgCenterWarn:) name:GXHomeCountNotificationName object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadPriceData) name:@"LoadPriceData" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.alphaView.hidden = YES;
    self.msgView1.hidden = YES;
    self.msgView2.hidden = YES;
//    self.navigationController.navigationBar.translucent = NO;
    if (self.PriceCellGet != nil || self.PriceCellFormal != nil) {
        [self.PriceCellGet stop];
        [self.PriceCellFormal stop];
    }
    [self removeObserversOfWillDisappear];
}
-(void)removeObserversOfWillDisappear{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GXOnlineServiceCountNotificationName object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:GXHomeCountNotificationName object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"LoadPriceData" object:nil];
}
#pragma mark ----- AddNewGaysGuide -----
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self makeFunctionGuide];
}
- (void)makeFunctionGuide{
    NSString *firstComeInTeacherDetail = @"isFirstEnterHere";
    //    [GXUserdefult setBool:NO forKey:firstComeInTeacherDetail];
    if (![GXUserdefult boolForKey:firstComeInTeacherDetail]) {
        [GXUserdefult setBool:YES forKey:firstComeInTeacherDetail];
        [GXUserdefult synchronize];
        [self makeGuideView];
    }
}
- (void)makeGuideView{
    GXNoviceTutorialController *vc = [[GXNoviceTutorialController alloc]init];
    vc.styles = @[@"GuideViewCleanModeCycleRect",
                  @"GuideViewCleanModeRoundRect",
                  @"GuideViewCleanModeCycleRect"];
    if (IS_IPHONE_6P) {
        vc.btnFrames = @[@"{{5, 20},{50,50}}",
                         @"{{0,190},{375,80}}",
                         @"{{365,25},{40,40}}",];
    }else if (IS_IPHONE_6){
        vc.btnFrames = @[@"{{5, 20},{50,50}}",
                         @"{{0,190},{375,80}}",
                         @"{{330,25},{40,40}}",];
    }else{
        vc.btnFrames = @[@"{{5, 20},{50,50}}",
                         @"{{0,190},{375,80}}",
                         @"{{285,25},{40,40}}",];
    }
    vc.imgFrames = @[@"{{0,10},{375,200}}",
                     @"{{0,270},{375,80}}",
                     @"{{0,5},{100,80}}",];
    vc.images = @[@"newbie_guide_pic1",
                  @"newbie_guide_pic2",
                  @"newbie_guide_pic6",];
    [self presentViewController:vc animated:YES completion:nil];
}
#pragma mark ----- RefreshHomePagePriceMethod -----
-(void)loadPriceData{
    if (self.homeGetCustomesTableView.hidden == YES) {
        if (self.PriceCellGet != nil && self.PriceCellFormal != nil) {
            [self.PriceCellFormal initData];
            [self.PriceCellGet stop];
        }
    }else{
        if (self.PriceCellGet != nil && self.PriceCellFormal != nil) {
            [self.PriceCellGet initData];
            [self.PriceCellFormal stop];
        }
    }
}
#pragma mark ----- addHomePageUser'sPic -----
-(void)setHomeUserImage{
    if ([GXUserInfoTool isLogin]) {
        [GXAddAccountTool getUserInfoSuccess:^(GXUserInfoModel *userInfoModel) {
            if (userInfoModel.avatar != nil) {
                NSString *userImageStr = [NSString stringWithFormat:@"%@%@",baseImageUrl,userInfoModel.avatar];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.homeMineUserView sd_setImageWithURL:[NSURL URLWithString:userImageStr] placeholderImage:[UIImage imageNamed:@"home_mine_default_pic"]];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                     self.homeMineUserView.image = [UIImage imageNamed:@"home_mine_default_pic"];
                });
            }
        } Failure:^(NSError *error) {
            self.homeMineUserView.image = [UIImage imageNamed:@"home_mine_default_pic"];
        }];
    }else{
        self.homeMineUserView.image = [UIImage imageNamed:@"home_mine_default_pic"];
    }
}
- (void)setHomeCutemerWarn {
    NSInteger count = [GXUserInfoTool getCutomerNum];
    if (count > 0) {
        self.seviceWarningLabel.hidden = NO;
        self.seviceWarningLabel.text = [NSString stringWithFormat:@"%ld", [GXUserInfoTool getCutomerNum]];
    } else {
        self.seviceWarningLabel.hidden = YES;
    }
}
-(void)setHomeMsgWarning{
    int msgCounts = [GXUserInfoTool getSuggestNum] + [GXUserInfoTool getReplyNum] + [GXUserInfoTool getAlarmNum];
    if (msgCounts > 0) {
        self.messageWarningLabel.hidden = NO;
        self.messageWarningLabel.text = [NSString stringWithFormat:@"%d",msgCounts];
    }else{
        self.messageWarningLabel.hidden = YES;
    }
}
-(void)setHomeMsgCenterWarn:(NSNotification *)notification{
    NSNumber *numbers = notification.object;
    self.messageWarningLabel.hidden = NO;
    self.messageWarningLabel.text = [NSString stringWithFormat:@"%ld",numbers.integerValue];
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isEnableScroll = true;
    self.isEnableScrollFormal = true;
    self.navigationItem.titleView = self.titleLabel;
//    self.title = @"国鑫金服";
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.isImportantEnvet = NO;
    
    [self.view addSubview:self.homeFormalTableView];
    [self.view addSubview:self.homeGetCustomesTableView];
    [self.view bringSubviewToFront:self.homeGetCustomesTableView];
    //解决push无效
    [self.view addSubview:self.homeNinaView];
    self.homeNinaView.pushEnabled = YES;
    [self.homeNinaView removeFromSuperview];
    
    [self.view addSubview:self.homeFormalNinaView];
    self.homeFormalNinaView.pushEnabled = YES;
    [self.homeFormalNinaView removeFromSuperview];

    [self gxjfCycleView];
    [self gxjfCycleViewformal];
    [self creatHomeNavigationMessageButton];
    [self redWarningLabel];
//    [self navigationColorChange];
    [self registerKindsOfCell];
    [self refreshData];
    [self.view addSubview:self.view_AlertToLoginOrAddCount];
    [self addObserver];
}
#pragma mark ----- addObserver -----
-(void)addObserver{
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(showNetworkStatus:) name: AFNetworkingReachabilityDidChangeNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScroll) name:FatherBeginScroll object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginInSuccessAction) name:GXNotify_LoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOutAction) name:GXNotify_LoginOut object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:NotyFicationForDidEnterForeground object:nil];
}
- (void)changeScroll{
    self.isEnableScroll = true;
    self.isEnableScrollFormal = true;
}
#pragma mark ----- RegisterCell -----
-(void)registerKindsOfCell{
    [self.homeGetCustomesTableView registerNib:[UINib nibWithNibName:@"GXHomeUserStatisticsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GXHomeUserStatisticsCell"];
    [self.homeGetCustomesTableView registerNib:[UINib nibWithNibName:@"GXHomeRemindRoomCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GXHomeRemindRoomCell"];
    [self.homeGetCustomesTableView registerNib:[UINib nibWithNibName:@"GXHomeCountDownCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GXHomeCountDownCell"];
    [self.homeGetCustomesTableView registerNib:[UINib nibWithNibName:@"GXHomeGettingStartCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GXHomeGettingStartCell"];
    [self.homeFormalTableView registerNib:[UINib nibWithNibName:@"GXHomeCountDownCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GXHomeCountDownCell"];
}
#pragma mark ----- NoNetworkWarning -----
-(void)showNetworkStatus:(NSNotification *)notification
{
    if ([notification.userInfo[AFNetworkingReachabilityNotificationStatusItem] integerValue] == 0) {
        [self showTipView];
    }else {
        [self removeTipView];
    }
}
#pragma mark ----- NavigationChangeView -----
- (void)navigationColorChange{
    CGRect frame = self.navigationController.navigationBar.frame;
//    _alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, frame.size.width, frame.size.height+20)];
//    _alphaView.backgroundColor = [UIColor clearColor];
//    _alphaView.userInteractionEnabled = NO;
//    UIImageView *maskView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, frame.size.width, frame.size.height)];
//    maskView.image = [UIImage imageNamed:@"mask_layer"];
//    [_alphaView addSubview:maskView];
//    [self.navigationController.navigationBar insertSubview: _alphaView atIndex:0];
}
#pragma mark ----- NavigaitonMessageButton(Mine-Service-Messages) -----
-(void)creatHomeNavigationMessageButton{
    self.msgView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 10, 45, 30)];
    self.homeMineUserView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 30, 30)];
    self.homeMineUserView.layer.cornerRadius = 15;
    self.homeMineUserView.layer.masksToBounds = YES;
    self.homeMineUserView.backgroundColor = [UIColor clearColor];
    [self.msgView1 addSubview:self.homeMineUserView];
//    self.msgView1.backgroundColor = GXColor(151.0, 151.0, 151.0, 0.2);
    self.msgView1.backgroundColor = [UIColor clearColor];
    UIBezierPath *msgViewPath1 = [UIBezierPath bezierPathWithRoundedRect:self.msgView1.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(22, 22)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc]init];
    maskLayer1.frame = self.msgView1.bounds;
    maskLayer1.path = msgViewPath1.CGPath;
    _msgView1.layer.mask = maskLayer1;
    self.msgView2 = [[UIView alloc]initWithFrame:CGRectMake(GXScreenWidth - 70, 10, 70, 30)];
//    self.msgView2.backgroundColor = GXColor(151.0, 151.0, 151.0, 0.2);
    self.msgView2.backgroundColor = [UIColor clearColor];
    UIBezierPath *msgViewPaht2 = [UIBezierPath bezierPathWithRoundedRect:self.msgView2.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(22, 22)];
    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc]init];
    maskLayer2.frame = self.msgView2.bounds;
    maskLayer2.path = msgViewPaht2.CGPath;
    self.msgView2.layer.mask = maskLayer2;
    for (int i = 0; i < 3; i++) {
        UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        homeBtn.showsTouchWhenHighlighted = YES;
        homeBtn.tag = i + 1000;
        [homeBtn addTarget:self action:@selector(homeMsgBtnDidClickAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0) {
            self.homeMineBtn = homeBtn;
            homeBtn.frame = CGRectMake(15, 0, 30, 30);
            [self.msgView1 addSubview:homeBtn];
        }else if (i == 1){
            homeBtn.frame = CGRectMake(0, 0, 30, 30);
            [homeBtn setImage:[UIImage imageNamed:@"home_rightservice_pic"] forState:UIControlStateNormal];
            [self.msgView2 addSubview:homeBtn];
        }else{
            homeBtn.frame = CGRectMake(35, 0, 30, 30);
            [homeBtn setImage:[UIImage imageNamed:@"home_messages_pic"] forState:UIControlStateNormal];
            [self.msgView2 addSubview:homeBtn];
        }
    }
    [self.navigationController.navigationBar addSubview:self.msgView1];
    [self.navigationController.navigationBar addSubview:self.msgView2];
}
#pragma mark ----- WarningRedPoint -----
-(void)redWarningLabel{
    self.seviceWarningLabel = [[UILabel alloc]init];
    self.seviceWarningLabel.backgroundColor = [UIColor redColor];
    self.seviceWarningLabel.layer.cornerRadius = 7.5;
    self.seviceWarningLabel.layer.masksToBounds = YES;
    self.seviceWarningLabel.textColor = [UIColor whiteColor];
    self.seviceWarningLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize9);
    self.seviceWarningLabel.textAlignment = NSTextAlignmentCenter;
    [self.msgView2 addSubview:self.seviceWarningLabel];
    [self.msgView2 bringSubviewToFront:self.seviceWarningLabel];
    self.messageWarningLabel = [[UILabel alloc]init];
    self.messageWarningLabel.backgroundColor = [UIColor redColor];
    self.messageWarningLabel.layer.cornerRadius = 7.5;
    self.messageWarningLabel.layer.masksToBounds = YES;
    self.messageWarningLabel.textColor = [UIColor whiteColor];
    self.messageWarningLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize8);
    self.messageWarningLabel.textAlignment = NSTextAlignmentCenter;
    [self.msgView2 addSubview:self.messageWarningLabel];
    [self.msgView2 bringSubviewToFront:self.messageWarningLabel];
    [self.seviceWarningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@-35);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    [self.messageWarningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
}
#pragma mark ----- navigationClickBtnAction -----
-(void)homeMsgBtnDidClickAction:(UIButton *)sender{
    switch (sender.tag) {
        case 1000:
        {   //我的模块
            GXMineController *mineVC = [[GXMineController alloc]init];
            [self.navigationController pushViewController:mineVC animated:YES];
            break;
        }
        case 1001:
        {
            [MobClick event:@"online_service_dh"];
            if ([GXUserInfoTool isLogin]) {
                [self.view showLoadingWithTitle:@"正在加载"];
                [GXAddAccountTool getUserInfoSuccess:^(GXUserInfoModel *userInfoModel) {
                    [self.view removeTipView];
                    NSString *headImageName = nil;
                    if (userInfoModel.avatar.length != 0) {
                        headImageName =  [NSString stringWithFormat:@"%@%@",baseImageUrl,userInfoModel.avatar];
                    }
                    [GXUserInfoTool saveUserHeadImage:headImageName];
                    //在线客服
                    ChatViewController *onlineVC = [[ChatViewController alloc] initWithChatter:EaseMobCusterKey type:eAfterSaleType];
                    [self.navigationController pushViewController:onlineVC animated:YES];
                } Failure:^(NSError *error) {
                    [self.view removeTipView];
                }];
            } else {
                //在线客服
                ChatViewController *onlineVC = [[ChatViewController alloc] initWithChatter:EaseMobCusterKey type:eAfterSaleType];
                [self.navigationController pushViewController:onlineVC animated:YES];
            }
        }
            break;
        case 1002:
        {   //消息中心
            [MobClick event:@"message"];
            if ([GXUserInfoTool isLogin]) {
                GXHomeMsgCenterController *msgCenterVC = [[GXHomeMsgCenterController alloc]init];
                [self.navigationController pushViewController:msgCenterVC animated:YES];
            }else{
                [self.navigationController pushViewController:[[GXLoginByVertyViewController alloc]init] animated:YES];
            }
        }
            break;
        default:
            break;
    }
}
#pragma mark - CutGXImpMsgPagerViewDelegate
-(void)ninaCurrentPageIndex:(NSString *)currentPage{
    switch ([currentPage integerValue]) {
        case 0:
            [MobClick event:@"important_message"];
            break;
        case 1:
            [MobClick event:@"calendar"];
            break;
        default:
            break;
    }
    if ([currentPage isEqualToString:@"1"] || [currentPage isEqualToString:@"2"]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SwitchThePageToStopPlaying" object:nil];
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(BOOL)deallocVCsIfUnnecessary{
    return YES;
}
#pragma mark ----- CreatedAirViewWindow -----
-(void)setAirViewWindow{
    if (_isShow) {
        return;
    }
    NSString *lastAirViewImgUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"lastImgUrl"];
    GXTabBarController *activityController = (GXTabBarController *)[AppDelegate activityViewController];
    NSString *currentAirViewImgUrl = self.homeAirModel.imgurl;
    self.homeAirView = [[GXAirView alloc]initWithAirViewImageStr:self.homeAirModel.imgurl];
    self.homeAirView.delegate = self;
    [self.homeAirView show];
    if(![currentAirViewImgUrl isEqualToString:lastAirViewImgUrl])
    {
        if (activityController.selectedIndex == 0) {
            [GXKeyWindow addSubview:self.homeAirView];
            self.isShow = YES;
        }else{
            [self.view addSubview:self.homeAirView];
            [self.view bringSubviewToFront:self.homeAirView];
            self.isShow = YES;
        }
        [GXUserdefult setObject:currentAirViewImgUrl forKey:@"lastImgUrl"];
        [GXUserdefult synchronize];
    }
}
#pragma mark ----- getIntheAirView -----
-(void)didClickGetInToAdViewAction{
    [MobClick event:@"AD_popup"];
    GXBanAnaRemImpDetailController *detailVC = [[GXBanAnaRemImpDetailController alloc]init];
    detailVC.airModel = self.homeAirModel;
    [self.navigationController pushViewController:detailVC animated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"HomeCancelNewGuide" object:nil];
}
#pragma mark - CacelGXAirViewDelegate
-(void)didClickCancelAirViewAction: (GXAirView *)airView{
    [UIView animateWithDuration:0.2 animations:^{
        self.homeAirView.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.homeAirView removeFromSuperview];
            self.isShow = NO;
        }
    }];
}
#pragma mark--GXAlertToLoginOrAddCountDelegate
-(void)gotoLoginOrAddCount{
    [MobClick event:@"quickness_open_an_account"];
    if([GXUserInfoTool isLogin]){
        GXAddCountIndexController *addCountVC=[[GXAddCountIndexController alloc]init];
        [self.navigationController pushViewController:addCountVC animated:YES];
    }else{
        [MobClick event:@"home_quickness_login"];
        GXLoginByVertyViewController *logVC=[[GXLoginByVertyViewController alloc]init];
        logVC.registerStr = GXSiteHomeReal;
        logVC.type = @"home_quickness_login";
        [self.navigationController pushViewController:logVC animated:YES];
    }
}
#pragma mark ----- estimate IsLogin -----
-(void)isLogin{

    if([GXUserInfoTool isLogin]){
        if (self.realNumber.integerValue == 1) {
            self.homeGetCustomesTableView.hidden=YES;
            self.homeFormalTableView.hidden = NO;
            self.view_AlertToLoginOrAddCount.hidden=YES;
        }else{
            self.homeFormalTableView.hidden = YES;
            self.homeGetCustomesTableView.hidden=NO;
            
            
            if ([GXUserInfoTool isShowOpenAccount]) {
                self.view_AlertToLoginOrAddCount.hidden=NO;
                [self.view_AlertToLoginOrAddCount.btn setTitle:@"安全开户" forState:UIControlStateNormal];
            }else{
                self.view_AlertToLoginOrAddCount.hidden = YES;
            }
            
        }
    }else{
        self.homeGetCustomesTableView.hidden=NO;
        if ([GXUserInfoTool isShowOpenAccount]) {
            self.view_AlertToLoginOrAddCount.hidden=NO;
            [self.view_AlertToLoginOrAddCount.btn setTitle:@"登录/注册" forState:UIControlStateNormal];
        }else{
            self.view_AlertToLoginOrAddCount.hidden = YES;
        }
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:@"LoadPriceData" object:nil];
}
#pragma mark ----- getHomeCycleView -----
- (void)gxjfCycleView{
    self.homeCycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, GXScreenWidth,180) delegate:self placeholderImage:[UIImage imageNamed:@"cycle_Banner_placeholder_pic"]];
    self.homeCycleView.currentPageDotImage = [UIImage imageNamed:@"cycle_now"];
    self.homeCycleView.pageDotImage = [UIImage imageNamed:@"cycle_other"];
    self.homeCycleView.delegate = self;
    self.homeCycleView.autoScrollTimeInterval = 4.0;
    self.homeGetCustomesTableView.tableHeaderView = self.homeCycleView;
    [self.homeGetCustomesTableView addSubview:self.homeCycleView];
    __weak typeof(self) weakSelf = self;
    self.homeCycleView.clickItemOperationBlock = ^(NSInteger index) {
        [MobClick event:@"AD"];
        GXBanAnaRemImpDetailController *bannerVC = [[GXBanAnaRemImpDetailController alloc]init];
        bannerVC.bannerModel = weakSelf.cycleDataArray[index];
        [weakSelf.navigationController pushViewController:bannerVC animated:YES];
    };
}
#pragma mark ----- formalCycleView -----
- (void)gxjfCycleViewformal{
    self.homeFormalCycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, GXScreenWidth,180) delegate:self placeholderImage:[UIImage imageNamed:@"cycle_Banner_placeholder_pic"]];
    self.homeFormalCycleView.currentPageDotImage = [UIImage imageNamed:@"cycle_now"];
    self.homeFormalCycleView.pageDotImage = [UIImage imageNamed:@"cycle_other"];
    self.homeFormalCycleView.delegate = self;
    self.homeFormalCycleView.autoScrollTimeInterval = 4.0;
    self.homeFormalTableView.tableHeaderView = self.homeFormalCycleView;
    [self.homeFormalTableView addSubview:self.homeFormalCycleView];
    __weak typeof(self) weakSelf = self;
    self.homeFormalCycleView.clickItemOperationBlock = ^(NSInteger index) {
        [MobClick event:@"AD"];
        GXBanAnaRemImpDetailController *bannerVC = [[GXBanAnaRemImpDetailController alloc]init];
        bannerVC.bannerModel = weakSelf.cycleDataArray[index];
        [weakSelf.navigationController pushViewController:bannerVC animated:YES];
    };
}
#pragma mark ----- RefreshData -----
- (void)refreshData {
    self.homeGetCustomesTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataFromServer)];
    self.homeGetCustomesTableView.mj_header.automaticallyChangeAlpha = YES;
    [self.homeGetCustomesTableView.mj_header beginRefreshing];
    
    self.homeFormalTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadDataFromServer)];
    self.homeFormalTableView.mj_header.automaticallyChangeAlpha = YES;
    [self.homeFormalTableView.mj_header beginRefreshing];
}
-(void)loginInSuccessAction{
    int msgCounts = [GXUserInfoTool getSuggestNum] + [GXUserInfoTool getReplyNum] + [GXUserInfoTool getAlarmNum];
    if (msgCounts > 0) {
        self.messageWarningLabel.hidden = NO;
    }else{
        self.messageWarningLabel.hidden = YES;
    }
    [self refreshData];
}
-(void)loginOutAction{
    self.messageWarningLabel.hidden = YES;
    [self refreshData];
}
#pragma mark ----- loading Data -----
- (void)loadDataFromServer{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"homeMsgloadData" object:nil];
    if (![GXUserInfoTool isConnectToNetwork]) {
        [GXUserdefult setBool:NO forKey:IsShowOpenAccount];
    }
    [GXHttpTool POSTCache:GXUrl_home parameters:nil success:^(id responseObject) {
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            self.isShowOpenAccount = responseObject[@"value"][@"showOpenAccount"];
            if (self.isShowOpenAccount.integerValue == 1) {
                [GXUserdefult setBool:YES forKey:IsShowOpenAccount];
            }else{
                [GXUserdefult setBool:NO forKey:IsShowOpenAccount];
            }
            [self removeAllObjectsFromArray];
            [self parmarterDataWith:responseObject];
            self.homeCycleView.imageURLStringsGroup = self.cycleImageArray.mutableCopy;
            self.homeFormalCycleView.imageURLStringsGroup = self.cycleImageArray.mutableCopy;
            self.homeCycleView.titlesGroup = self.cycleTitleArray.mutableCopy;
            self.homeFormalCycleView.titlesGroup = self.cycleTitleArray.mutableCopy;
            [self setAirViewWindow];
            [self isLogin];
            [self.homeGetCustomesTableView reloadData];
            [self.homeFormalTableView reloadData];
            [self.homeFormalTableView.mj_header endRefreshing];
            [self.homeGetCustomesTableView.mj_header endRefreshing];
        }else{
            [self showEmptyMsg:@"网络错误,请重试!" dataSourceCount:self.cycleImageArray.count superView:self.homeGetCustomesTableView];
            [self showEmptyMsg:@"网络错误,请重试!" dataSourceCount:self.cycleImageArray.count superView:self.homeFormalTableView];
            [self.homeFormalTableView.mj_header endRefreshing];
            [self.homeGetCustomesTableView.mj_header endRefreshing];
        }
    } failure:^(NSError *error) {
        //[self showNetError];
        [self.homeGetCustomesTableView.mj_header endRefreshing];
        [self.homeFormalTableView.mj_header endRefreshing];
    }];
}
- (void)removeAllObjectsFromArray{
    [self.cycleImageArray removeAllObjects];
    [self.homeAnalystArray removeAllObjects];
    [self.cycleTitleArray removeAllObjects];
}
-(void)saveSeviceInfo:(NSMutableDictionary *)dict{
    NSString *conStr = [dict[@"content"] stringByReplacingOccurrencesOfString:@"nn" withString:@"\n"];
    [GXUserdefult setObject:conStr forKey:HomeSeviceInfo];
    [GXUserdefult synchronize];
}
#pragma mark ----- data analysis -----
- (void)parmarterDataWith:(NSDictionary *)responseObject{
    if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
        NSDictionary *valueDict = responseObject[@"value"];
        [self saveSeviceInfo:valueDict[@"kefuInfo"]];
        //解析浮窗广告数据
        NSDictionary *airDict = valueDict[@"pushAdvertisements"][0];
        self.homeAirModel = [GXAirAdModel new];
        [self.homeAirModel setValuesForKeysWithDictionary:airDict];
        self.realNumber = valueDict[@"realCustomer"];
        //轮播数据解析
        NSArray *valuesKeysArray = [valueDict allKeys];
        if ([valuesKeysArray containsObject:@"importEvent"]) {
            self.isImportantEnvet = YES;
        }else{
            self.isImportantEnvet = NO;
        }
        for (NSDictionary *advDict in valueDict[@"banner"]) {
            [self.cycleImageArray addObject:advDict[@"imgurl"]];
            [self.cycleTitleArray addObject:advDict[@"name"]];
            GXHomeAdvertistsModel *model = [GXHomeAdvertistsModel new];
            [model setValuesForKeysWithDictionary:advDict];
            [self.cycleDataArray addObject:model];
        }
        //用户数量模型
        self.userModel = [GXHomeUserStatisticsModel new];
        [self.userModel setValuesForKeysWithDictionary:valueDict];
        //推荐播间模型
        self.remindRoomModel = [GXHomeRemindRoomModel new];
        [self.remindRoomModel setValuesForKeysWithDictionary:valueDict[@"commendVIPRoom"]];
        //倒计时事件
        self.countDownModel = [GXHomeCountDownModel new];
        [self.countDownModel setValuesForKeysWithDictionary:valueDict[@"importEvent"]];
        //分析师数据解析
        for (NSDictionary *teacherDic in valueDict[@"teachers"]) {
            GXHomeAnalystModel *analystModel = [GXHomeAnalystModel new];
            [analystModel setValuesForKeysWithDictionary:teacherDic];
            [self.homeAnalystArray addObject:analystModel];
        }
    }
}
#pragma mark ----- numbersOfRow And numbersOfSections -----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.homeGetCustomesTableView]) {
                return 6;
    }
    if ([tableView isEqual:self.homeFormalTableView]) {
        return 3;
    }
    return 0;
}
#pragma mark ----- CellSettings -----
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    typeof(self) weakSelf = self;
    if ([tableView isEqual:self.homeGetCustomesTableView]) {
        if (indexPath.row == 0) {
            static NSString *identifier = @"GXHomePriceCell";
            self.PriceCellGet = [tableView dequeueReusableCellWithIdentifier:identifier];
            self.PriceCellGet.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.PriceCellGet == nil) {
                self.PriceCellGet = [[GXHomePriceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                self.PriceCellGet.contentView.dk_backgroundColorPicker =DKColorPickerWithColors(GXRGBColor(237, 237, 243),GXRGBColor(34, 35, 45));
                [self.PriceCellGet initData];
                //跳转行情详情
                self.PriceCellGet.didPriceDetailCellBlock = ^(NSInteger index){
                    [MobClick event:@"hot_market"];
                    weakSelf.PricePlatformArray = [GXFileTool readObjectByFileName:PricePlatformKey];
                    PriceMarketModel *model = weakSelf.PriceCellGet.priceListArray[index];
                    //遍历点击code属于哪个交易所
                    for (PricePlatformModel *PlatformModel in weakSelf.PricePlatformArray) {
                        if([[PlatformModel.excode lowercaseString] isEqualToString:[model.excode lowercaseString]]){
                            //遍历找到detail
                            NSArray *listAr = PlatformModel.tradeInfoList;
                            for (PriceProductModel *productModel in listAr) {
                                if([[productModel.code lowercaseString]isEqualToString:[model.code lowercaseString]]){
                                    model.tradeDetail=productModel.tradeDetail;
                                    break;
                                }
                            }
                            break;
                        }
                    }
                    GXPriceDetailController *detailVC = [[GXPriceDetailController alloc]init];
                    detailVC.marketModel = model;                 
                    [weakSelf.navigationController pushViewController:detailVC animated:YES];
                };
                //跳转自选行情
                self.PriceCellGet.didAddCellBlock = ^(NSInteger index){
                    [MobClick event:@"hot_market_add_self"];
                    GXPriceListAddCodeViewController *priceVC = [[GXPriceListAddCodeViewController alloc]init];
                    priceVC.delegate = (id)weakSelf;
                    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:priceVC];
                    [weakSelf presentViewController:naVC animated:YES completion:nil];
                };
            }
            return self.PriceCellGet;
        }else if (indexPath.row == 1){
            GXHomeUserStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXHomeUserStatisticsCell" forIndexPath:indexPath];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell setHomeBtnBlock:^(NSInteger tag){
                switch (tag) {
                    case 9527:
                    {//品牌优势
                        [MobClick event:@"superiority"];
                        GXHomePageToH5PageController *detailVC =[[GXHomePageToH5PageController alloc]init];
                        detailVC.webUrl = GXUrl_Brand_Advantage;
                        detailVC.secondTitle = @"品牌优势";
                        [self.navigationController pushViewController:detailVC animated:YES];
                    }
                        break;
                    case 9528:
                    {//盈利排行
                        [MobClick event:@"top"];
                        GXHelpCenterController *detailVC =[[GXHelpCenterController alloc]init];
                        [self.navigationController pushViewController:detailVC animated:YES];
                    }
                        break;
                    case 9529:
                    {//快速开户
                        [MobClick event:@"shortcut_open_an_account"];
//                        if ([GXUserInfoTool isLogin]) {
//                            [self.navigationController pushViewController:[[GXAddCountIndexController alloc]init] animated:YES];
//                        }else{
//                            GXLoginByVertyViewController *loginVC = [[GXLoginByVertyViewController alloc]init];
//                            loginVC.registerStr = GXSiteHomeReal;
//                            [self.navigationController pushViewController:loginVC animated:YES];
//                        }
                        GXTabBarController *tabbarVC = [[GXTabBarController alloc]init];
                        tabbarVC.selectedIndex = 1;
                        GXKeyWindow.rootViewController = tabbarVC;
                    }
                        break;
                    case 9530:
                    {//在线客服
                        [MobClick event:@"online_service"];
                        ChatViewController *onlineVC = [[ChatViewController alloc] initWithChatter:EaseMobCusterKey type:eAfterSaleType];
                        [self.navigationController pushViewController:onlineVC animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            }];
            return cell;
        }else if (indexPath.row == 2){
            GXHomeCountDownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXHomeCountDownCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.dk_backgroundColorPicker =  DKColorPickerWithColors(RGBACOLOR(241, 241, 245, 1),GXRGBColor(34, 35, 45));
            cell.model = self.countDownModel;
            if (self.isImportantEnvet) {
                cell.hidden = false;
            }else{
                cell.hidden = true;
            } return cell;
        }else if (indexPath.row == 3){
            
            GXHomeGettingStartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXHomeGettingStartCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //点击跳转详情
            [cell setDidNewOneClickAction:^(NSInteger tag) {
                [MobClick event:@"getting_started"];
                switch (tag) {
                    case 9527:
                    {//3分钟了解国鑫资料
                        GXHomePageToH5PageController *detailVC =[[GXHomePageToH5PageController alloc]init];
                        detailVC.webUrl = GXUrl_About_investment;
                        detailVC.secondTitle = @"了解现货投资";
                        [self.navigationController pushViewController:detailVC animated:YES];
                    }
                        break;
                    case 9528:
                    {//为何选择国鑫
                        GXHomePageToH5PageController *detailVC =[[GXHomePageToH5PageController alloc]init];
                        detailVC.webUrl = GXUrl_Brand_Advantage;
                        detailVC.secondTitle = @"了解国鑫";
                        [self.navigationController pushViewController:detailVC animated:YES];
                    }
                        break;
                    case 9529:
                    {//新人三分钟开户
                        GXHomePageToH5PageController *detailVC =[[GXHomePageToH5PageController alloc]init];
                        detailVC.webUrl = GXUrl_Threeminutes_open_account;
                        detailVC.secondTitle = @"极速开户";
                        [self.navigationController pushViewController:detailVC animated:YES];
                    }
                        break;
                    default:
                        break;
                }
            }];
            return cell;

        }else if(indexPath.row == 4){
            GXHomeRemindRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXHomeRemindRoomCell" forIndexPath:indexPath];
            cell.model = self.remindRoomModel;
            return cell;

        }else {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell.contentView addSubview:self.homeNinaView];
            [self.homeNinaView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@10);
                make.left.equalTo(@0);
                make.right.equalTo(@0);
                make.bottom.equalTo(@0);
            }];
            cell.contentView.dk_backgroundColorPicker = DKColorPickerWithColors(GXHomeDKWhiteColor,GXHomeDKBlackColor);
            return cell;
        }
    }
    if ([tableView isEqual:self.homeFormalTableView]) {
        if (indexPath.row == 0) {
            static NSString *identifier = @"GXHomePriceCell";
            self.PriceCellFormal = [tableView dequeueReusableCellWithIdentifier:identifier];
            self.PriceCellFormal.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.PriceCellFormal == nil) {
                self.PriceCellFormal = [[GXHomePriceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                self.PriceCellFormal.contentView.dk_backgroundColorPicker =DKColorPickerWithColors(GXRGBColor(237, 237, 243),GXRGBColor(34, 35, 45));
                [self.PriceCellFormal initData];
                //跳转行情详情
                self.PriceCellFormal.didPriceDetailCellBlock = ^(NSInteger index){
                    [MobClick event:@"hot_market"];
                    weakSelf.PricePlatformArray = [GXFileTool readObjectByFileName:PricePlatformKey];
                    PriceMarketModel *model = weakSelf.PriceCellFormal.priceListArray[index];
                    //遍历点击code属于哪个交易所
                    for (PricePlatformModel *PlatformModel in weakSelf.PricePlatformArray) {
                        if([[PlatformModel.excode lowercaseString] isEqualToString:[model.excode lowercaseString]]){
                            //遍历找到detail
                            NSArray *listAr = PlatformModel.tradeInfoList;
                            for (PriceProductModel *productModel in listAr) {
                                if([[productModel.code lowercaseString]isEqualToString:[model.code lowercaseString]]){
                                    model.tradeDetail=productModel.tradeDetail;
                                    break;
                                }
                            }
                            break;
                        }
                    }
                    GXPriceDetailController *detailVC = [[GXPriceDetailController alloc]init];
                    detailVC.marketModel = model;
                    [weakSelf.navigationController pushViewController:detailVC animated:YES];
                };
                //跳转自选行情
                self.PriceCellFormal.didAddCellBlock = ^(NSInteger index){
                    [MobClick event:@"hot_market_add_self"];
                    GXPriceListAddCodeViewController *priceVC = [[GXPriceListAddCodeViewController alloc]init];
                    priceVC.delegate = (id)weakSelf;
                    UINavigationController *naVC = [[UINavigationController alloc]initWithRootViewController:priceVC];
                    [weakSelf presentViewController:naVC animated:YES completion:nil];
                };
            }return self.PriceCellFormal;
        }else if(indexPath.row == 2){
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell.contentView addSubview:self.homeFormalNinaView];
            self.homeFormalNinaView.backgroundColor = [UIColor blueColor];
            [self.homeFormalNinaView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(@10);
                make.left.equalTo(@0);
                make.right.equalTo(@0);
                make.bottom.equalTo(@0);
            }];
            cell.contentView.dk_backgroundColorPicker = DKColorPickerWithColors(GXHomeDKWhiteColor,GXHomeDKBlackColor);
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            GXHomeCountDownCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXHomeCountDownCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.dk_backgroundColorPicker =  DKColorPickerWithColors(RGBACOLOR(241, 241, 245, 1),GXRGBColor(34, 35, 45));
            cell.model = self.countDownModel;
            if (self.isImportantEnvet) {
                cell.hidden = false;
            }else{
                cell.hidden = true;
            }
            return cell;
        }
    }return nil;
}
#pragma mark ----- HeightOfCell -----
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.homeGetCustomesTableView]) {
        if (indexPath.row == 0) {
            return 90;
        }else if (indexPath.row == 1){
            return 80;
        }else if (indexPath.row == 2){
            if (_isImportantEnvet == NO) {
                self.lastTableViewOffsetY = 535 + 180;
                return 0;
            }else{
                self.lastTableViewOffsetY = 535 + 180 + 170;
                return 160;
            }
        }
        else if (indexPath.row == 3){
            return 130;
        }else if (indexPath.row == 4){
            return 235;
        }else{
            return GXScreenHeight;
        }
    }
    if ([tableView isEqual:self.homeFormalTableView]) {
        if (indexPath.row == 0) {
            return 90;
        }
        else if (indexPath.row == 2){
            return GXScreenHeight;
        }else{
            if (_isImportantEnvet == NO) {
                self.lastCellHeight = 100 + 180;
                return 0;
            }else{
                self.lastCellHeight = 100 + 180 + 170;
                return 170;
            }
        }
    }return 0;
}
#pragma mark ----- didSelectCellAction -----
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.homeGetCustomesTableView]) {
        if (indexPath.row == 4) {
            [MobClick event:@"AD_H5"];
            GXHomePageToH5PageController *detailVC =[[GXHomePageToH5PageController alloc]init];
            detailVC.webUrl = GXUrl_GuoXin_research_institute;
            detailVC.secondTitle = @"国鑫研究院";
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        if (indexPath.row == 2) {
            [MobClick event:@"point_market"];
            GXBanAnaRemImpDetailController *detailVC = [[GXBanAnaRemImpDetailController alloc]init];
            detailVC.countDownModel = self.countDownModel;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    if ([tableView isEqual:self.homeFormalTableView]) {
        if (indexPath.row == 1) {
            [MobClick event:@"point_market"];
            GXBanAnaRemImpDetailController *detailVC = [[GXBanAnaRemImpDetailController alloc]init];
            detailVC.countDownModel = self.countDownModel;
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
}
#pragma mark - UITableViewScrollowViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    self.alaph = (scrollView.contentOffset.y + 20) / 20.0 - 1;
//            self.alaph = self.alaph < 0 ? 0 : self.alaph;
//            if (scrollView.contentOffset.y < - 70) {
//                [UIView animateWithDuration:0.3 animations:^{
//                    self.msgView1.alpha = 0;
//                    self.msgView2.alpha = 0;
//                }];
//            }else{
//                [UIView animateWithDuration:1 animations:^{
//                    self.msgView1.alpha = 1;
//                    self.msgView2.alpha = 1;
//                }];
//            }
//            self.alphaView.backgroundColor =GXColor(34, 35, 45, self.alaph);
//    GXLog(@"scrollView*******%@", NSStringFromCGPoint(scrollView.contentOffset));
    if (scrollView == self.homeGetCustomesTableView) {
        if (scrollView.contentOffset.y >= self.lastTableViewOffsetY) {
            self.isEnableScroll = false;
            scrollView.contentOffset = CGPointMake(0, self.lastTableViewOffsetY);
            [[NSNotificationCenter defaultCenter] postNotificationName:SonBeginScroll object:nil];
        }
        if (!self.isEnableScroll) {
            scrollView.contentOffset = CGPointMake(0, self.lastTableViewOffsetY);
        }
    }
    else if(scrollView == self.homeFormalTableView){
        CGFloat offSetY = self.lastCellHeight ;
        if (scrollView.contentOffset.y >= offSetY) {
            self.isEnableScrollFormal = false;
            [[NSNotificationCenter defaultCenter] postNotificationName:SonBeginScroll object:nil];
            scrollView.contentOffset = CGPointMake(0, offSetY);
        }
        if (!self.isEnableScrollFormal) {
            scrollView.contentOffset = CGPointMake(0, offSetY);
        }
    }
}
#pragma mark ----- Lazy loading -----
-(NSMutableArray *)cycleImageArray{
    if (!_cycleImageArray) {
        _cycleImageArray = [NSMutableArray new];
    }return _cycleImageArray;
}
-(NSMutableArray *)cycleDataArray{
    if (!_cycleDataArray) {
        _cycleDataArray = [NSMutableArray new];
    }return _cycleDataArray;
}
-(NSMutableArray *)homeUserArray{
    if (!_homeUserArray) {
        _homeUserArray = [NSMutableArray new];
    }return _homeUserArray;
}
-(NSMutableArray *)homeAnalystArray{
    if (!_homeAnalystArray) {
        _homeAnalystArray = [NSMutableArray new];
    }return _homeAnalystArray;
}
-(NSMutableArray *)tableViews{
    if (!_tableViews) {
        _tableViews = [NSMutableArray new];
    }return _tableViews;
}
-(NSMutableArray *)cycleTitleArray{
    if (!_cycleTitleArray) {
        _cycleTitleArray = [NSMutableArray new];
    }return _cycleTitleArray;
}
-(NSArray *)messageTitleArray{
    if (!_messageTitleArray) {
        _messageTitleArray = @[@"重要消息",@"财经日历"];
    }
    return _messageTitleArray;
}
-(NSArray *)inColorArray{
    if (!_inColorArray) {
        _inColorArray =@[GXRGBColor(64.0, 130.0, 244.0),GXRGBColor(161.0, 166.0, 187.0),GXRGBColor(64.0, 130.0, 244.0),GXRGBColor(34.0, 35.0, 45.0)];
    }return _inColorArray;
}
-(NSArray *)MsgclassNameArray{
    if (!_MsgclassNameArray) {
        _MsgclassNameArray = @[@"GXHomeImportantMessageController",@"GXHomeCalendarController"];
    }
    return _MsgclassNameArray;
}
//获客页重要消息View
-(GXImpMsgPagerView *)homeNinaView{
    if (!_homeNinaView) {
        _homeNinaView = [[GXImpMsgPagerView alloc]initWithNinaPagerStyle:NinaPagerStyleBottomLineWidthWithTitleWidth WithTitles:self.messageTitleArray WithVCs:self.MsgclassNameArray WithColorArrays:self.inColorArray WithDefaultIndex:0 WithTitleFontSize:18];
        _homeNinaView.titleScale = 1;
        _homeNinaView.delegate = self;
    }
    return _homeNinaView;
}
//非获客页重要消息View
-(GXImpMsgPagerView *)homeFormalNinaView{
    if (!_homeFormalNinaView) {
        self.homeFormalNinaView = [[GXImpMsgPagerView alloc]initWithNinaPagerStyle:NinaPagerStyleBottomLineWidthWithTitleWidth WithTitles:self.messageTitleArray WithVCs:self.MsgclassNameArray WithColorArrays:self.inColorArray WithDefaultIndex:0 WithTitleFontSize:18];
        _homeFormalNinaView.delegate = self;
        _homeFormalNinaView.titleScale = 1;
        
    }return _homeFormalNinaView;
}
//开户浮窗
-(GXAlertToLoginOrAddCountView*)view_AlertToLoginOrAddCount{
    if(_view_AlertToLoginOrAddCount==nil){
        _view_AlertToLoginOrAddCount=[[[NSBundle mainBundle]loadNibNamed:@"GXAlertToLoginOrAddCountView" owner:self options:nil]lastObject];
        _view_AlertToLoginOrAddCount.frame=CGRectMake(0, GXScreenHeight-49-57-64,GXScreenWidth, 57);
        _view_AlertToLoginOrAddCount.delegate=self;
    }
    return _view_AlertToLoginOrAddCount;
}
//获客首页
-(UITableView *)homeGetCustomesTableView{
    if (!_homeGetCustomesTableView) {
        _homeGetCustomesTableView = [[GXHomeBackView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight) style:UITableViewStylePlain];
        _homeGetCustomesTableView.backgroundColor = GXRGBColor(237, 237, 243);
        self.homeGetCustomesTableView.delegate = self;
        self.homeGetCustomesTableView.dataSource = self;
        self.homeGetCustomesTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.homeGetCustomesTableView.showsVerticalScrollIndicator = NO;
    }
    return _homeGetCustomesTableView;
}
//非获客页
-(UITableView *)homeFormalTableView{
    if (!_homeFormalTableView) {
        _homeFormalTableView = [[GXHomeBackView alloc]initWithFrame:CGRectMake(0,0, GXScreenWidth, GXScreenHeight + 20) style:UITableViewStylePlain];
        _homeFormalTableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
        _homeFormalTableView.delegate = self;
        _homeFormalTableView.dataSource = self;
        _homeFormalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeFormalTableView.showsVerticalScrollIndicator = NO;
    }
    return _homeFormalTableView;
}
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"国鑫金服";
        _titleLabel.font = GXFONT_PingFangSC_Regular(17);
        _titleLabel.textColor = [UIColor whiteColor];
    }return _titleLabel;
}

- (NSNumber *)isShowOpenAccount {
    if (!_isShowOpenAccount) {
        _isShowOpenAccount = [[NSNumber alloc] init];
    }
    return _isShowOpenAccount;
}

@end
