//
//  GXHomePageToH5PageController.m
//  GXAppNew
//
//  Created by 王振 on 2017/2/14.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXHomePageToH5PageController.h"
#import <WebKit/WebKit.h>
#import "GXActivityShareController.h"
#import "GXLoginByVertyViewController.h"
#import "GXAddCountIndexController.h"
#import "GXLiveDetailViewController.h"
#import "GXLiveController.h"
#import "GXDiscoverController.h"
#import "GXHomeCalendarController.h"
#import "GXPriceListController.h"
#import "GXLiveCastViewController.h"
#import "GXTabBarController.h"
#import "WKWebViewJavascriptBridge.h"
@interface GXHomePageToH5PageController ()<WKUIDelegate,WKNavigationDelegate,UIWebViewDelegate>
@property (nonatomic,strong)WKWebView *wkWebView;
@property (nonatomic,strong)WKWebViewJavascriptBridge *bridge;
@end

@implementation GXHomePageToH5PageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.secondTitle;
    self.shareUrl = self.webUrl;
    self.shareTitle = self.secondTitle;
    self.wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 64)];
    self.wkWebView.navigationDelegate = self;
    [self.view addSubview:self.wkWebView];
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    [self rightItem];
    //[self registerBridge];
}
-(void)registerBridge{
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    [_bridge setWebViewDelegate:self];
    [_bridge registerHandler:@"getUserToken" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *token = [GXUserInfoTool getUserTocken];
        if (token) {
            responseCallback(token);
        }else{
            responseCallback(@"");
        }
    }];
}
-(void)rightItem{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backItem;
}
//预留字段

//1视频直播     openLiveVideo
//2顾问平台     openDiscoverPlatform
//3单个老师播间  openSpecifyRoom/123456
//4资讯         openInformation
//5行情         openPriceList
//6财经日历      openFinancialCalendar
//7开户         openAccount
//8计算器       openProfitCounter
//9在线客服     openOnlineService
//10分享      openActivityShare
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *requestString = [[navigationAction.request URL] absoluteString];
    NSArray *components = [requestString componentsSeparatedByString:@"/"];
    // 开户
    if ([components count] > 1 && [(NSString *)[components objectAtIndex:[components count]-1] isEqualToString:@"openAccount"]) {
        if ([GXUserInfoTool isLogin]) {
            GXAddCountIndexController * addCountViewController=[[GXAddCountIndexController alloc] init];
            [self.navigationController pushViewController:addCountViewController animated:YES];
        }else{
            GXLoginByVertyViewController *longinVC = [[GXLoginByVertyViewController alloc] init];
            longinVC.recieveSiteUrl = GXSiteHomeBanner;
            [self.navigationController pushViewController:longinVC animated:YES];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    }// 在线客服
    else if ([components count] > 1 && [(NSString *)[components objectAtIndex:[components count]-1] isEqualToString:@"OnlineService"]) {
        //在线客服
        ChatViewController *onlineVC = [[ChatViewController alloc] initWithChatter:EaseMobCusterKey type:eAfterSaleType];
        [self.navigationController pushViewController:onlineVC animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    }// 视频直播
    else if ([components count] > 1 && [(NSString *)[components objectAtIndex:[components count]-1] isEqualToString:@"openLiveVideo"]) {
        GXLiveCastViewController *liveCastVC = [[GXLiveCastViewController alloc] init];
        [self.navigationController pushViewController:liveCastVC animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    // 顾问平台
    else if ([components count] > 1 && [(NSString *)[components objectAtIndex:[components count]-1] isEqualToString:@"openDiscoverPlatform"]) {
        GXTabBarController *tabbarVC = [[GXTabBarController alloc]init];
        tabbarVC.selectedIndex = 2;
        GXKeyWindow.rootViewController = tabbarVC;
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    // 单个老师播间
    else if ([components count] > 1 && [(NSString *)[components objectAtIndex:[components count]-2] isEqualToString:@"openSpecifyRoom"]) {
        if ([GXUserInfoTool isLogin]) {
            NSString *roomID = [components lastObject];
            GXLiveDetailViewController  *openSpecifyRoomVC = [[GXLiveDetailViewController alloc] init];
            openSpecifyRoomVC.roomID = roomID;
            [self.navigationController pushViewController:openSpecifyRoomVC animated:YES];
        }else{
            GXLoginByVertyViewController *longinVC = [[GXLoginByVertyViewController alloc] init];
            [self.navigationController pushViewController:longinVC animated:YES];
        }
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    // 资讯
    else if ([components count] > 1 && [(NSString *)[components objectAtIndex:[components count]-1] isEqualToString:@"openInformation"]) {
        GXDiscoverController *infoVC = [[GXDiscoverController alloc] init];
        [self.navigationController pushViewController:infoVC animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    // 行情
    else if ([components count] > 1 && [(NSString *)[components objectAtIndex:[components count]-1] isEqualToString:@"openPriceList"]) {
        GXPriceListController *priceVC = [[GXPriceListController alloc] init];
        [self.navigationController pushViewController:priceVC animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    //财经日历
    else if ([components count] > 1 && [(NSString *)[components objectAtIndex:[components count]-1] isEqualToString:@"openFinancialCalendar"]) {
        GXHomeCalendarController *FinancialCalendarVC = [[GXHomeCalendarController alloc] init];
        [self.navigationController pushViewController:FinancialCalendarVC animated:YES];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    //跳转原生分享
    else if ([components count] > 1 && [(NSString *)[components objectAtIndex:[components count]-1] isEqualToString:@"openActivityShare"]){
        GXActivityShareController *shareVC = [[GXActivityShareController alloc]init];
        [shareVC shareActiviyLinkUrl:self.shareUrl shareImage:self.shareImage shareTitleName:self.shareTitle shareDiscribContent:self.shareDesc];
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    // 跳转登录
    else if ([components count] > 1 && [(NSString *)[components objectAtIndex:[components count]-1] isEqualToString:@"openUserLogin"]){
        if (![GXUserInfoTool isLogin]) {
            GXLoginByVertyViewController *longinVC = [[GXLoginByVertyViewController alloc] init];
            //longinVC.recieveSiteUrl = GXSiteHomeBanner;
            [self.navigationController pushViewController:longinVC animated:YES];
            decisionHandler(WKNavigationActionPolicyCancel);
        } else {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
    // 跳转注册
    else if ([components count] > 1 && [(NSString *)[components objectAtIndex:[components count]-1] isEqualToString:@"openUserRegister"]){
        if (![GXUserInfoTool isLogin]) {
            GXRegisterViewController *registerVC = [[GXRegisterViewController alloc] init];
            [self.navigationController pushViewController:registerVC animated:YES];
            decisionHandler(WKNavigationActionPolicyCancel);
        } else {
            decisionHandler(WKNavigationActionPolicyAllow);
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
//开始加载页面
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.wkWebView.userInteractionEnabled = NO;
    [self.wkWebView showLoadingWithTitle:@"正在加载,请稍等"];
}
//页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    self.wkWebView.userInteractionEnabled = YES;
    [self.wkWebView removeTipView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
-(void)back:(UIBarButtonItem *)btn{
    if ([self.wkWebView canGoBack]) {
        [self.wkWebView goBack];
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
