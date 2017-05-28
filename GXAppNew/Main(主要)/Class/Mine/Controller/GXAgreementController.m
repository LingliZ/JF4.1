//
//  GXAgreementController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/11.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXAgreementController.h"

@interface GXAgreementController ()

@end

@implementation GXAgreementController
{
    UIWebView*webView_agree;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.urlString=[[NSString alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadDataForAgreement];
}
-(void)createUI
{
    webView_agree=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64)];
    webView_agree.delegate=self;
    [self.view addSubview:webView_agree];
}
-(void)loadDataForAgreement
{
    NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
    params[@"type"]=self.urlString;
    [self.view showLoadingWithTitle:@"正在请求协议数据"];
    [GXHttpTool POSTCache:GXUrl_agree parameters:params success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]integerValue])
        {
            [self loadViewWithUrlString:responseObject[@"value"]];
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
    } failure:^(NSError *error) {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"数据请求失败，请检查网络设置"];
    }];
}
-(void)loadViewWithUrlString:(NSString*)urlString
{
    NSURL*url=[NSURL URLWithString:urlString];
    NSURLRequest*request=[NSURLRequest requestWithURL:url];
    [webView_agree loadRequest:request];
}

@end
