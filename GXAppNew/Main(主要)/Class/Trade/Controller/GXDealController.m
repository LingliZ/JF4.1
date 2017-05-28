//
//  GXDealController.m
//  demo
//
//  Created by yangfutang on 16/5/9.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXDealController.h"
//#import "GXAddCountViewController.h"
#import "GXDealDeailController.h"
#import <TMBSV3Trading/TMBSV3TradingManager.h>
#import <QiluTrade/DealLoginViewController.h>

@interface GXDealController ()<DealBackDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *upLine;
@property (nonatomic,strong)UIView * backView;
@property (nonatomic,strong)UIView * callView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openTopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *openBottomLine;

@property (weak, nonatomic) IBOutlet UILabel *describLabel1;
@property (weak, nonatomic) IBOutlet UILabel *describLabel2;
@property (weak, nonatomic) IBOutlet UIView *tradeView;
@property (weak, nonatomic) IBOutlet UIButton *qiluTradeBtn;
@property (weak, nonatomic) IBOutlet UIButton *tianjinTradeBtn;
@property (weak, nonatomic) IBOutlet UILabel *noOpenAccountLabel;
@property (weak, nonatomic) IBOutlet UIButton *goToOpenAccountLabel;
@property (weak, nonatomic) IBOutlet UIButton *shanXiYiDaiYiLuBtn;

@end

@implementation GXDealController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易";
    self.navigationController.navigationBar.translucent = NO;
    //self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xFF8C00);
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"电话下单" style:UIBarButtonItemStylePlain target:self action:@selector(didClickCall:)];
        [rightItem setTitleTextAttributes:@{NSFontAttributeName:GXFONT_PingFangSC_Light(GXFitFontSize14),NSForegroundColorAttributeName:UIColorFromRGB(0xFFFFFF)} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.upLine.constant = HeightLandScale_IOS6(85);
    [self.tradeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(GXScreenHeight - 49 - 64));
    }];
    //button圆角
    self.qiluTradeBtn.layer.cornerRadius = 5;
    self.qiluTradeBtn.layer.masksToBounds = YES;
    self.tianjinTradeBtn.layer.cornerRadius = 5;
    self.tianjinTradeBtn.layer.masksToBounds = YES;
    self.shanXiYiDaiYiLuBtn.layer.cornerRadius = 5;
    self.shanXiYiDaiYiLuBtn.layer.masksToBounds = YES;
    [self.shanXiYiDaiYiLuBtn setBackgroundImage: ImageFromHex(@"3B71B0")
forState:UIControlStateHighlighted];
    [self.qiluTradeBtn setBackgroundImage: ImageFromHex(@"3B71B0")
                                 forState:UIControlStateHighlighted];
    [self.tianjinTradeBtn setBackgroundImage:ImageFromHex(@"48A539") forState:UIControlStateHighlighted];
    
    
    
    self.noOpenAccountLabel.hidden = [GXUserInfoTool isShowOpenAccount] ? NO : YES;
    self.goToOpenAccountLabel.hidden = [GXUserInfoTool isShowOpenAccount] ? NO : YES;
    
    if (self.noOpenAccountLabel.hidden == NO && self.goToOpenAccountLabel.hidden == NO) {
        
        self.noOpenAccountLabel.font = GXFONT_PingFangSC_Light(GXFitFontSize14);
        self.noOpenAccountLabel.textColor = UIColorFromRGB(0x4A4A4A);
        NSMutableAttributedString *openAccountStr = [[NSMutableAttributedString alloc]initWithString:@"去开户"];
        NSString *goToOpenAccount = @"去开户";
        NSRange range =[goToOpenAccount rangeOfString:@"去开户"];
        [openAccountStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x4A90E2) range:range];
        [openAccountStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle | NSUnderlinePatternSolid) range:range];
        self.goToOpenAccountLabel.titleLabel.attributedText = openAccountStr;
    }
}
//陕西一带一路
- (IBAction)didClickShanXiYiDaiYiLuAction:(UIButton *)sender {
    [MobClick event:@"sxydyl_trading"];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/brme/id1130852014?mt=8"]];
}

//齐鲁
- (IBAction)didClickQiLuDealAciton:(UIButton *)sender {
    [MobClick event:@"qisp_trading"];
    DealLoginViewController *deal = [[DealLoginViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:deal];
    [nav setNavigationBarHidden:YES];
    deal.delegate = self;
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark - DealBackDelegate
-(void)buttonBack:(DealLoginViewController *)dealLoginViewController {
    [dealLoginViewController dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)exchangePicture {}

//津贵
- (IBAction)didClickJinLuDealAction:(UIButton *)sender
{
    [MobClick event:@"jgs_trading"];
    [[TMBSV3TradingManager shareInstance] pushToTradingModule:self.navigationController];
}

//去开户
- (IBAction)didClickOpenAccountAction:(UIButton *)sender {
    [MobClick event:@"trading_open_an_account"];
    if(![GXUserInfoTool isLogin])
    {
        GXLoginByVertyViewController*logVC=[[GXLoginByVertyViewController alloc]init];
        logVC.registerStr = GXSiteTradeReal;
        [self.navigationController pushViewController:logVC animated:YES];
        return;
    }
    GXAddCountIndexController*indexVC=[[GXAddCountIndexController alloc]init];
    [self.navigationController pushViewController:indexVC animated:YES];
}

//电话下单事件
- (void)didClickCall:(UIBarButtonItem *)item{
    [MobClick event:@"telephone_orders"];
    [self remove];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.backView = [[UIView alloc]initWithFrame:screenRect];
    //self.backView.backgroundColor=[UIColor colorWithRed:103.0/255.0 green:104.0/255.0 blue:106.0/255.0 alpha:.5];
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissAction)];
    [self.backView addGestureRecognizer:tap];
    [GXKeyWindow addSubview:self.backView];
     //[MobClick event:@"telephone_orders"];
    
    [self showCallView];
}
//callView
- (void)showCallView{
    //展示视图
    self.callView = [[UIView alloc]initWithFrame:CGRectMake(WidthScale_IOS6(30), HeightScale_IOS6(143.5), GXScreenWidth - WidthScale_IOS6(60), HeightScale_IOS6(320))];
    self.callView.backgroundColor = [UIColor whiteColor];
    self.callView.alpha = 1;
    self.callView.layer.cornerRadius = 10;
    self.callView.layer.masksToBounds = YES;
    //津贵商品label,电话
    UILabel *jinguiLabel = [[UILabel alloc]initWithFrame:CGRectMake(WidthScale_IOS6(40), HeightScale_IOS6(60), self.callView.frame.size.width - WidthScale_IOS6(80), 14)];
    jinguiLabel.text = @"津贵所电话下单";
    jinguiLabel.textColor = [UIColor colorWithWhite:0.290 alpha:1.000];
    jinguiLabel.textAlignment = NSTextAlignmentCenter;
    jinguiLabel.font = GXFONT_PingFangSC_Light(GXFitFontSize14);
    [self.callView addSubview:jinguiLabel];
    //津贵Btn
    UIButton *jinguiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    jinguiBtn.frame = CGRectMake(jinguiLabel.frame.origin.x, jinguiLabel.frame.origin.y + jinguiLabel.frame.size.height + HeightScale_IOS6(10), jinguiLabel.frame.size.width, HeightScale_IOS6(44));
    jinguiBtn.backgroundColor = GXRGBColor(64, 130, 244);
    jinguiBtn.layer.cornerRadius = 5;
    jinguiBtn.layer.masksToBounds = YES;
    [jinguiBtn addTarget:self action:@selector(didClickJinGuiCallAction:) forControlEvents:UIControlEventTouchUpInside];
    jinguiBtn.titleLabel.font = GXFONT_PingFangSC_Light(20);
    [jinguiBtn setTitle:@"400-610-1155" forState:UIControlStateNormal];
    [jinguiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.callView addSubview:jinguiBtn];
    //齐鲁商品label,电话
    UILabel *qiluLabel = [[UILabel alloc]initWithFrame:CGRectMake(jinguiBtn.frame.origin.x, jinguiBtn.frame.size.height + jinguiBtn.frame.origin.y + HeightScale_IOS6(30), self.callView.frame.size.width - WidthScale_IOS6(80), 14)];
    qiluLabel.text = @"青岛齐鲁商品现货电话下单";
    qiluLabel.textColor = [UIColor colorWithWhite:0.290 alpha:1.000];
    qiluLabel.textAlignment = NSTextAlignmentCenter;
    qiluLabel.font = GXFONT_PingFangSC_Light(GXFitFontSize14);
    [self.callView addSubview:qiluLabel];
    
    UIButton *qiluBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    qiluBtn.frame = CGRectMake(qiluLabel.frame.origin.x, qiluLabel.frame.origin.y + qiluLabel.frame.size.height + HeightScale_IOS6(10), qiluLabel.frame.size.width, HeightScale_IOS6(44));
    qiluBtn.backgroundColor = GXRGBColor(230, 162, 34);
    qiluBtn.layer.cornerRadius = 5;
    qiluBtn.layer.masksToBounds = YES;
    [qiluBtn addTarget:self action:@selector(didClickQiluCallAction:) forControlEvents:UIControlEventTouchUpInside];
    qiluBtn.titleLabel.font = GXFONT_PingFangSC_Light(20);
    [qiluBtn setTitle:@"400-699-9255" forState:UIControlStateNormal];
    [qiluBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.callView addSubview:qiluBtn];
    //分割线
    UIView *separationLine = [[UIView alloc]initWithFrame:CGRectMake(0, self.callView.frame.size.height - HeightScale_IOS6(44), self.callView.frame.size.width, 0.5)];
    separationLine.backgroundColor = [UIColor colorWithWhite:0.933 alpha:1.000];
    [self.callView addSubview:separationLine];
    //取消按钮
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, self.callView.frame.size.height - HeightScale_IOS6(44), self.callView.frame.size.width, HeightScale_IOS6(44));
    cancelBtn.titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize17);
    [cancelBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.callView addSubview:cancelBtn];
    [[UIApplication sharedApplication].keyWindow addSubview:self.callView];
}
//齐鲁电话事件
- (void)didClickQiluCallAction:(UIButton *)button{
    [MobClick event:@"orders_qlsp"];
    NSURL *url = [NSURL URLWithString:@"telprompt://400-699-9255"];
    [[UIApplication sharedApplication] openURL:url];
}
//津贵电话事件
- (void)didClickJinGuiCallAction:(UIButton *)button{
    [MobClick event:@"orders_jgs"];
    NSURL *url = [NSURL URLWithString:@"telprompt://400-610-1155"];
    [[UIApplication sharedApplication] openURL:url];
}
-(void)remove{
    
    [GXKeyWindow removeFromSuperview];
    [self.backView removeFromSuperview];
    [self.callView removeFromSuperview];
}

-(void)dismissAction{
    [self remove];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
