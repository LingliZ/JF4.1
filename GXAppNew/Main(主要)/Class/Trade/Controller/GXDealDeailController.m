//
//  GXDealDeailController.m
//  GXApp
//
//  Created by 王振 on 16/7/22.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXDealDeailController.h"
#import "GXNavigationController.h"
//#import <TMBSV3Trading/TMBSV3TradingManager.h>


@interface GXDealDeailController ()
@property (weak, nonatomic) IBOutlet UILabel *descripLabel;
//现货交易系统
@property (weak, nonatomic) IBOutlet UILabel *spotTradingLabel;

@property (weak, nonatomic) IBOutlet UILabel *TradingModelLabel;

//现货延期交易系统
@property (weak, nonatomic) IBOutlet UILabel *spotDeferredLabel;
@property (weak, nonatomic) IBOutlet UILabel *deferredTradingModelLabel;
//牛人跟单
@property (weak, nonatomic) IBOutlet UILabel *bigManLabel;
@property (weak, nonatomic) IBOutlet UILabel *bigManTradingModelLabel;

@end

@implementation GXDealDeailController
-(void)viewWillAppear:(BOOL)animated
{
    //self.navigationController.navigationBar.translucent=YES;
    //[GXNavigationController initialize];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"天津贵金属交易所";
    self.descripLabel.font = GXFONT_PingFangSC_Light(GXFitFontSize14);
    self.descripLabel.textColor = UIColorFromRGB(0x9B9B9B);
    self.spotTradingLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize17);
    self.spotTradingLabel.textColor = UIColorFromRGB(0xF15B6F);
    self.spotDeferredLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize17);
    self.spotDeferredLabel.textColor = UIColorFromRGB(0xFF8C00);
    self.bigManLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize17);
    self.bigManLabel.textColor = UIColorFromRGB(0x4A4A4A);
    self.TradingModelLabel.font = GXFONT_PingFangSC_Light(GXFitFontSize14);
    self.TradingModelLabel.textColor =  UIColorFromRGB(0x9B9B9B);
    self.deferredTradingModelLabel.font = GXFONT_PingFangSC_Light(GXFitFontSize14);
    self.deferredTradingModelLabel.textColor = UIColorFromRGB(0x9B9B9B);
    self.bigManTradingModelLabel.font = GXFONT_PingFangSC_Light(GXFitFontSize14);
    self.bigManTradingModelLabel.textColor = UIColorFromRGB(0x9B9B9B);
    [self layOutSubViews];
}
-(void)layOutSubViews{
    if (IS_IPHONE_5_OR_LESS) {
        self.bottomLine.constant = 245;
    }else if (IS_IPHONE_6){
        self.bottomLine.constant = 344;
    }else if (IS_IPHONE_6P){
        self.bottomLine.constant = 413;
    }
}

//现货挂牌交易系统
- (IBAction)didClickListingTradeAction:(UIButton *)sender {
   
//    [MobClick event:@"jgs_gp"];
//    [[TMBSV3TradingManager shareInstance] pushToTradingModule: self.navigationController.parentViewController];
}
//现货延期交易系统
- (IBAction)didClickLaterTradeAction:(UIButton *)sender {
    
    //[MobClick event:@"jgs_yq"];

    NSURL * myURL_APP_A = [NSURL URLWithString:@"TMBS://"];

    if([[UIApplication sharedApplication] openURL:myURL_APP_A]){
    }
    else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/id575816603#"]];
    }
}
//牛人跟单
- (IBAction)didClickBigManListsAction:(UIButton *)sender {
//    TMBSNiuRenManager * niurenManager = [TMBSNiuRenManager shareInstance];
//    niurenManager.TMBSNiuRenDelegate = self;
//    TMBSMainGenDanViewController *login_view=[[TMBSMainGenDanViewController alloc] init];
//    [self.navigationController pushViewController: login_view animated:YES];
   // self.tabBarController.navigationController.navigationBarHidden=NO;
   // self.tabBarController.tabBar.hidden=YES;
   // [self.navigationController pushViewController:login_view animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
