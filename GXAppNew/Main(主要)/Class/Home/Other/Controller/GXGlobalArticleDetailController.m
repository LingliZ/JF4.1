//
//  GXGlobalArticleDetailController.m
//  GXApp
//
//  Created by GXJF on 16/7/4.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXGlobalArticleDetailController.h"
#import "GXArticleDetailModel.h"
#import "GXAdaptiveHeightTool.h"
#import "UIImageView+WebCache.h"
#import "GXActionSheetView.h"
#import "GXPhotoBrowseController.h"
#import "GXActivityShareController.h"
#import "WKWebView+ImageArray.h"
@interface GXGlobalArticleDetailController ()<UIScrollViewDelegate,WKUIDelegate,WKNavigationDelegate>
{
    UIView *bgView;
    UIImageView *imgView;
}
@property (nonatomic,strong)NSString *articleID;
@property (nonatomic,strong)GXArticleDetailModel *model;
@property (nonatomic,strong)NSString *webUrl;
@property (nonatomic,strong)NSString *articalGroupUrl;
//分享
@property (nonatomic,strong)NSString *shareUrl;
@property (nonatomic,strong)NSString *shareTitle;
@property (nonatomic,strong)NSString *shareImage;
@property (nonatomic,strong)NSString *shareDesc;
//保存图片的数组
@property (nonatomic,strong)NSMutableArray *mUrlArray;

@end

@implementation GXGlobalArticleDetailController
-(NSMutableArray *)mUrlArray{
    if (_mUrlArray == nil) {
        _mUrlArray = [NSMutableArray new];
    }return _mUrlArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"文章详情";
    
    [self rightItem];
    
    if (self.textModel != nil){
        if (self.textModel.url != nil) {
            self.webUrl = self.textModel.url;
            self.shareTitle = self.textModel.title;
            self.shareImage = self.textModel.imgUrl;
            self.shareDesc = self.textModel.metadesc;
            self.shareUrl = self.textModel.url;
        }else{
            self.articalGroupUrl = [NSString stringWithFormat:@"http://m.91guoxin.com/index/detail/i/%@.html",self.textModel.ID];
            self.articleID = self.textModel.ID;
            self.shareTitle = self.textModel.title;
            self.shareImage = self.textModel.imgUrl;
            self.shareDesc = self.textModel.metadesc;
            self.shareUrl = self.articalGroupUrl;
        }
    }else if (self.audioModel != nil){
        if (self.audioModel.url != nil) {
            self.webUrl = self.audioModel.url;
            self.shareTitle = self.audioModel.title;
            self.shareImage = self.audioModel.imgUrl;
            self.shareDesc = self.audioModel.metadesc;
            self.shareUrl = self.audioModel.url;
        }else{
            self.articalGroupUrl = [NSString stringWithFormat:@"http://m.91guoxin.com/index/detail/i/%@.html",self.audioModel.ID];
            self.articleID = self.audioModel.ID;
            self.shareTitle = self.audioModel.title;
            self.shareImage = self.audioModel.imgUrl;
            self.shareDesc = self.audioModel.metadesc;
            self.shareUrl = self.articalGroupUrl;
        }
    }else if (self.vedioModel != nil){
        if (self.vedioModel.url != nil) {
            self.webUrl = self.vedioModel.url;
            self.shareTitle = self.vedioModel.title;
            self.shareImage = self.vedioModel.imgUrl;
            self.shareDesc = self.vedioModel.metadesc;
            self.shareUrl = self.vedioModel.url;
        }else{
            self.articalGroupUrl = [NSString stringWithFormat:@"http://m.91guoxin.com/index/detail/i/%@.html",self.vedioModel.ID];
            self.articleID = self.vedioModel.ID;
            self.shareTitle = self.vedioModel.title;
            self.shareImage = self.vedioModel.imgUrl;
            self.shareDesc = self.vedioModel.metadesc;
            self.shareUrl = self.articalGroupUrl;
        }
    }else if (self.informationModel != nil){
        self.articalGroupUrl = [NSString stringWithFormat:@"http://m.91guoxin.com/index/detail/i/%@.html",self.informationModel.ID];
        self.articleID = self.informationModel.ID;
        self.shareTitle = self.informationModel.title;
        self.shareImage = self.informationModel.imgurl;
        self.shareDesc = self.informationModel.metadesc;
        self.shareUrl = self.articalGroupUrl;
        
        
        if(!self.shareTitle)
        {
            self.navigationItem.rightBarButtonItem=nil;
        }
    }
    else{
        self.title = @"测试标题";
        self.webUrl = @"http://www.baidu.com";
        NSLog(@"传参错误");
    }
    self.wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 64)];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    self.wkWebView.backgroundColor = UIColorFromRGB(0xF8F8F8);
//    self.wkWebView.scrollView.showsVerticalScrollIndicator = NO;
    self.wkWebView.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.wkWebView];
    if (self.webUrl != nil) {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    }else{
        [self loadArticleDetailDataFromServer];
    }
    
}
-(void)rightItem{
    //分享按钮
    UIImage *shareImage = [[UIImage imageNamed:@"share_pic"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc]initWithImage: shareImage style:UIBarButtonItemStylePlain target:self action:@selector(didClickShareItemAction:)];
    self.navigationItem.rightBarButtonItem = shareItem;
}
//分享事件
- (void)didClickShareItemAction:(UIBarButtonItem *)item{
    if ([GXUserInfoTool isConnectToNetwork]) {
        GXActivityShareController *shareVC = [[GXActivityShareController alloc]init];
        [shareVC shareActiviyLinkUrl:self.shareUrl shareImage:self.shareImage shareTitleName:self.shareTitle shareDiscribContent:self.shareDesc];
    }else{
        [self showErrorNetMsg:@"" withView:self.wkWebView];
    }
}
//先请求网络数据然后webView加载html
- (void)loadArticleDetailDataFromServer{
    if ([GXUserInfoTool isConnectToNetwork]) {
        [self.wkWebView showLoadingWithTitle:@"文章正在加载,请稍后"];
    }
    NSDictionary *idDict = @{@"id":self.articleID};
    [GXHttpTool POSTCache:GXUrl_articleDetail parameters:idDict success:^(id responseObject) {
        if ([(NSNumber *)responseObject[@"success"] intValue] == 1) {
            [self.wkWebView removeTipView];
            NSDictionary *valueDict = responseObject[@"value"];
            [self removeTipView];
            self.model = [GXArticleDetailModel new];
            [self.model setValuesForKeysWithDictionary:valueDict];
            NSString *dateStr = [GXAdaptiveHeightTool getDateStyle:self.model.created];
            NSString *htmlStr = [GXAdaptiveHeightTool htmlWithContent:self.model.introtext title:self.model.title adddate:dateStr author:self.model.author source:self.model.xreference];
            [self.wkWebView loadHTMLString:htmlStr baseURL:nil];
        }
    } failure:^(NSError *error) {
        [self.wkWebView removeTipView];
        [self showErrorNetMsg:@"" withView:self.wkWebView];
    }];
}
-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    [self showBigImage:navigationAction.request];
    decisionHandler(WKNavigationActionPolicyAllow);
}
//准备加载页面
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}
//开始加载页面
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    //self.view.userInteractionEnabled = NO;
    self.wkWebView.userInteractionEnabled = NO;
    [self.wkWebView showLoadingWithTitle:@"正在加载,请稍等"];
}
//页面加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    self.wkWebView.userInteractionEnabled = YES;
    [self.wkWebView removeTipView];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self getImageUrlByJS:self.wkWebView];
}
//页面加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self showErrorNetMsg:@"" withView:self.wkWebView];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}
/*
 *通过js获取htlm中图片url
 */
-(NSArray *)getImageUrlByJS:(WKWebView *)wkWebView
{
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgUrlStr='';\
    for(var i=0;i<objs.length;i++){\
    imgUrlStr += '#'+objs[i].src;\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return imgUrlStr;\
    };";
    //用js获取全部图片
    [wkWebView evaluateJavaScript:jsGetImages completionHandler:^(id Result, NSError * error) {
    }];
    NSString *js2=@"getImages()";
    __block NSArray *array=[NSArray array];
    [wkWebView evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {
        NSString *resurlt=[NSString stringWithFormat:@"%@",Result];
        if([resurlt hasPrefix:@"#"])
        {
            resurlt=[resurlt substringFromIndex:1];
        }
        array=[resurlt componentsSeparatedByString:@"#"];
        [wkWebView setMethod:array];
    }];
    return array;
}
//显示大图
-(BOOL)showBigImage:(NSURLRequest *)request
{//将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"])
    {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        NSArray *imgUrlArr=[self.wkWebView getImgUrlArray];
        NSInteger index=0;
        for (NSInteger i=0; i<[imgUrlArr count]; i++) {
            if([imageUrl isEqualToString:imgUrlArr[i]])
            {
                index=i;
                break;
            }
        }
        GXPhotoBrowseController *photoBrowseVC = [[GXPhotoBrowseController alloc]init];
        photoBrowseVC.imgUrlArray = imgUrlArr.mutableCopy;
        photoBrowseVC.imgUrl = imgUrlArr[index];
        photoBrowseVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:photoBrowseVC animated:YES completion:nil];
        return NO;
    }
    return YES;
}
@end
