//
//  GXSignAgreementController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXSignAgreementController.h"

#define Agree_qilu_Agreement @"http://image.91guoxin.com/html5/agree-qilu-agreement.html" //齐鲁
#define Agree_tjpme_Agreement @"http://image.91guoxin.com/html5/agree-tjpme-agreement.html"//津贵所 <=60岁
#define Agree_tjpme_AgreementEx @"http://image.91guoxin.com/html5/agree-tjpme-agreementEx.html" //津贵所 >60岁
//#define Agree_shanxi_Agreement @"http://image.91guoxin.com/html5/agree-sxbrme-agreement.html?name=123&address=112321&idNumber=11111111111" //陕西一带一路
#define Agree_shanxi_Agreement  [NSString stringWithFormat:@"http://image.91guoxin.com/html5/agree-sxbrme-agreement.html?name=%@&address=112321&idNumber=%@",[[GXUserInfoTool getUserReallyName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[GXUserInfoTool getIDCardNum]]//陕西一带一路
@interface GXSignAgreementController ()

@end

@implementation GXSignAgreementController
{
    NSURL*agreeUrl;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isForAddAccount=YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
    [NSString stringWithFormat:@"http://image.91guoxin.com/html5/agree-sxbrme-agreement.html?name=%@&address=112321&idNumber=%@",[[GXUserInfoTool getUserReallyName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[GXUserInfoTool getIDCardNum]];
}
-(void)createUI
{
    self.title=@"协议签署";
    [UIView setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
//    [self.btn_next setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self.btn_next setBtn_nextControlStateDisabled];
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForQilu])
    {
        agreeUrl=[NSURL URLWithString:Agree_qilu_Agreement];
    }
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForTianjin])
    {
        if([[GXUserInfoTool getUserAgeWithID_CardNum:[GXUserInfoTool getIDCardNum]]intValue]>=60)
        {
            //开津贵所，年龄大于60
            agreeUrl=[NSURL URLWithString:Agree_tjpme_AgreementEx];
        }
        else
        {
            //年龄小于60
            agreeUrl=[NSURL URLWithString:Agree_tjpme_Agreement];
        }
    }
    
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForShanxi])
    {
        //陕西一带一路
        self.label_mark_step4.text=@"完成开户";
        NSString*urlStr=Agree_shanxi_Agreement;
        agreeUrl=[NSURL URLWithString:urlStr];
        [self getAddress];
        
        [self.view addSubview:self.webView_agree];
        [self.webView_agree mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(@5);
            make.right.mas_equalTo(@(-5));
            make.top.mas_equalTo(self.view_line.mas_bottom).mas_offset(0);
            make.bottom.mas_equalTo(@(0));
        }];

        return;
    }
    
    NSURLRequest*request=[NSURLRequest requestWithURL:agreeUrl];
    [self.view addSubview:self.webView_agree];
    [self.webView_agree loadRequest:request];
    [self.webView_agree mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(@5);
        make.right.mas_equalTo(@(-5));
        make.top.mas_equalTo(self.view_line.mas_bottom).mas_offset(0);
        make.bottom.mas_equalTo(@(0));
    }];
}
-(UIWebView*)webView_agree
{
    if(_webView_agree ==nil)
    {
        _webView_agree=[[UIWebView alloc]init];
        _webView_agree.delegate=self;
    }
    return _webView_agree;
}
- (IBAction)btnClick_next:(UIButton *)sender {
    
    GXSignAgreementFinishedController*finishVC=[[GXSignAgreementFinishedController alloc]init];
    [self.navigationController pushViewController:finishVC animated:YES];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.webView_agree showLoadingWithTitle:@"正在加载协议内容"];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.webView_agree removeTipView];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.webView_agree removeTipView];
    [self.webView_agree showFailWithTitle:@"协议加载失败"];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    GXLog(@"----%@",request.URL.absoluteString);
    if([request.URL.absoluteString isEqualToString:@"http://image.91guoxin.com/html5/agreement"])
    {
        if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForShanxi])
        {
            GXCustomerSurveyOneController*surveyVC=[[GXCustomerSurveyOneController alloc]init];
            [self.navigationController pushViewController:surveyVC animated:YES];
            return NO;
        }
        GXSignAgreementFinishedController*finishVC=[[GXSignAgreementFinishedController alloc]init];
        [self.navigationController pushViewController:finishVC animated:YES];
        return NO;
    }
    return YES;
}
-(void)getAddress
{
    NSDictionary*param=@{@"idNumber":[GXUserInfoTool getIDCardNum]};
    [GXHttpTool POST:@"/area" parameters:param success:^(id responseObject) {
        if([responseObject[@"success"]intValue]==1)
        {
            NSString*address=[NSString stringWithFormat:@"%@%@%@",responseObject[@"value"][@"province"],responseObject[@"value"][@"city"],responseObject[@"value"][@"district"]];
            NSString*urlStr=[NSString stringWithFormat:@"http://image.91guoxin.com/html5/agree-sxbrme-agreement.html?name=%@&address=%@&idNumber=%@",[[GXUserInfoTool getUserReallyName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[GXUserInfoTool getIDCardNum]];
            NSURL*url=[NSURL URLWithString:urlStr];
            NSURLRequest*request=[NSURLRequest requestWithURL:url];
            [self.webView_agree loadRequest:request];
        }
    } failure:^(NSError *error) {
        
        
    }];
}
@end
