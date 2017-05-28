//
//  GXBanAnaRemImpDetailController.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/14.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXBanAnaRemImpDetailController.h"
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



@interface GXBanAnaRemImpDetailController ()<WKUIDelegate,WKNavigationDelegate>
@property (nonatomic,strong)WKWebView *wkWebView;
@property WKWebViewJavascriptBridge * bridge;

@end

@implementation GXBanAnaRemImpDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 64)];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    [self.view addSubview:self.wkWebView];
    //广告model
    if (self.bannerModel) {
        
        self.title = self.bannerModel.name;
        self.webUrl = self.bannerModel.clickurl;
        self.shareTitle = self.bannerModel.name;
        self.shareImage = self.bannerModel.imgurl;
        self.shareUrl = self.bannerModel.clickurl;
        self.shareDesc = self.title;
    }//分析师
    else if (self.analystModel.userName){
        self.title = self.analystModel.userName;
        self.webUrl = self.analystModel.url;
        self.webUrl = @"http://www.m91jin.com";
    }//推荐播间
    else if (self.remindModel.name){
        self.title = self.remindModel.name;
        //self.webUrl = self.remindModel.url;
        self.webUrl = @"http://www.m91jin.com";
        self.shareTitle = self.remindModel.name;
        self.shareImage = self.remindModel.imgUrl;
        self.shareDesc = self.remindModel.intro;
        self.shareUrl = self.remindModel.url;
    }//重要事件提醒
    else if (self.countDownModel.title){
        self.title = self.countDownModel.title;
        self.webUrl = self.countDownModel.url;

        self.shareTitle = self.countDownModel.title;
        self.shareImage = self.countDownModel.imgurl;
        self.shareDesc = self.countDownModel.desc;
        self.shareUrl = self.countDownModel.url;
    }//发现广告
    else if (self.disBannerModel.name){
        self.title = self.disBannerModel.name;
        self.webUrl = self.disBannerModel.clickurl;
        
        self.shareTitle = self.disBannerModel.name;
        self.shareImage = self.disBannerModel.imgurl;
        self.shareDesc = self.disBannerModel.name;
        self.shareUrl =self.disBannerModel.clickurl;
    }//浮窗广告
    else if (self.airModel.name){
        self.title = self.airModel.name;
        self.webUrl = self.airModel.clickurl;
        self.shareTitle = self.airModel.name;
        self.shareImage = self.airModel.imgurl;
        self.shareDesc = self.airModel.name;
        self.shareUrl =self.airModel.clickurl;
    }
    else
    {
        if (self.webUrl == nil) {
            NSLog(@"参数错误");
            self.title = @"测试标题";
            _webUrl = @"http://m.91guoxin.com/";
            self.shareTitle = @"参数错误";
            self.shareImage = @"参数错误";
            self.shareUrl = @"http://m.91guoxin.com/";
            self.shareDesc = @"参数错误";
        }else{
            
        }
    }
    //测试
//    self.webUrl = @"http://www.baidu.com1";
    [self rightItem];
    [self loadData];
    [self registerBridge];
}

-(void)loadData{
    if ([self iSValidUrl:self.webUrl]) {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
        self.navigationItem.rightBarButtonItem = nil;
    }else{
        self.shareUrl = [NSString stringWithFormat:@"http://m.91guoxin.com/index/detail/i/%@.html",self.webUrl];
        [self loadArticleDetailDataFromServer];
    }
}

- (void)registerBridge {
    [WKWebViewJavascriptBridge enableLogging];
    _bridge = [WKWebViewJavascriptBridge bridgeForWebView:self.wkWebView];
    [_bridge setWebViewDelegate:self];
    [_bridge registerHandler:@"getUserToken" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSString *token = [GXUserInfoTool getUserTocken];
        if (token) {
            responseCallback(token);
        } else {
            responseCallback(@"");
        }
    }];
}
//判断是否是网址
-(BOOL)iSValidUrl:(NSString *)string{
    NSString *regex = @"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:string];
}
//如果不是网址则加载html
- (void)loadArticleDetailDataFromServer{
    if ([GXUserInfoTool isConnectToNetwork]) {
        [self.view showLoadingWithTitle:@"文章正在加载,请稍后"];
    }
    NSDictionary *idDict = @{@"id":self.webUrl};
    [GXHttpTool POSTCache:GXUrl_articleDetail parameters:idDict success:^(id responseObject) {
        [self.view removeTipView];
        if ([(NSNumber *)responseObject[@"success"] intValue] == 1) {
            NSDictionary *valueDict = responseObject[@"value"];
            self.model = [GXArticleDetailModel new];
            [self.model setValuesForKeysWithDictionary:valueDict];
            NSString *dateStr = [GXAdaptiveHeightTool getDateStyle:self.model.created];
            NSString *htmlStr = [GXAdaptiveHeightTool htmlWithContent:self.model.introtext title:self.model.title adddate:dateStr author:self.model.author source:self.model.xreference];
            [self.wkWebView loadHTMLString:htmlStr baseURL:nil];
        }
    } failure:^(NSError *error) {
        [self.view removeTipView];
        if (self.model == nil) {
            //[self showErrorNetMsg:nil Handler:^{
//                [self loadArticleDetailDataFromServer];
//            }];
        }
    }];
}
-(void)rightItem{
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"share_pic"] style:UIBarButtonItemStylePlain target:self action:@selector(shareAdvertisement)];
    [shareItem setTitleTextAttributes:@{NSFontAttributeName:GXFONT_PingFangSC_Light(GXFitFontSize14),NSForegroundColorAttributeName:UIColorFromRGB(0xFFFFFF)} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = shareItem;
}
//分享
-(void)shareAdvertisement{
    //分享
    GXActivityShareController *shareVC = [[GXActivityShareController alloc]init];
    [shareVC shareActiviyLinkUrl:self.shareUrl shareImage:self.shareImage shareTitleName:self.shareTitle shareDiscribContent:self.shareDesc];
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
            longinVC.registerStr = GXSiteHomeBanner;
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
            longinVC.registerStr = GXSiteHomeBanner;
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
//准备加载页面
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    // NSLog(@"webView:didStartProvisionalNavigation:  开始请求  \n\n");
}
//开始加载页面
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.wkWebView.userInteractionEnabled = NO;
    [self.wkWebView showLoadingWithTitle:@"正在加载,请稍等"];
    //NSLog(@"webView:didCommitNavigation:   响应的内容到达主页面的时候响应,刚准备开始渲染页面应用 \n\n");
}
//页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    self.wkWebView.userInteractionEnabled = YES;
    [self.wkWebView removeTipView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // NSLog(@"webView:didFinishNavigation:  响应渲染完成后调用该方法   webView : %@  -- navigation : %@  \n\n",webView,navigation);
}
//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self showErrorNetMsg:@"链接错误" withView:self.wkWebView];
    // 类似 UIWebView 的- webView:didFailLoadWithError:
    
    //NSLog(@"webView:didFailProvisionalNavigation:withError: 启动时加载数据发生错误就会调用这个方法。  \n\n");
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [self showErrorNetMsg:@"链接错误" withView:self.wkWebView];
    //NSLog(@"webView:didFailNavigation: 当一个正在提交的页面在跳转过程中出现错误时调用这个方法。  \n\n");
}

-(void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
    completionHandler(NSURLSessionAuthChallengeUseCredential, nil);
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    //NSLog(@"webViewWebContentProcessDidTerminate:  当Web视图的网页内容被终止时调用。");
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    //NSLog(@"返回响应前先会调用这个方法  并且已经能接收到响应webView:decidePolicyForNavigationResponse:decisionHandler: Response?%@  \n\n",navigationResponse.response);
    
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"webView:didReceiveServerRedirectForProvisionalNavigation: 重定向的时候就会调用  \n\n");
}

// Sent before a web view begins loading a frame.请求发送前都会调用该方法,返回NO则不处理这个请求
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return NO;
}

// Sent after a web view starts loading a frame. 请求发送之后开始接收响应之前会调用这个方法
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

// Sent after a web view finishes loading a frame. 请求发送之后,并且服务器已经返回响应之后调用该方法
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}

// Sent if a web view failed to load a frame. 网页请求失败则会调用该方法
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
//    
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
