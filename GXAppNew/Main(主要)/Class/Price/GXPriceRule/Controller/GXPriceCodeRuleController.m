//
//  GXPriceCodeRuleController.m
//  GXAppNew
//
//  Created by futang yang on 2017/1/14.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXPriceCodeRuleController.h"

@interface GXPriceCodeRuleController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation GXPriceCodeRuleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.973 alpha:1.000];
    self.title = self.marketModel.name;
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.view addSubview:self.webView];
    NSString *str = [NSMutableString stringWithFormat:@"http://image.91guoxin.com/html5/"];
    NSString *url = [NSString stringWithFormat:@"%@%@",str,self.marketModel.tradeDetail];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
}


- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 64)];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor colorWithWhite:0.973 alpha:1.000];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scalesPageToFit = YES;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([GXUserInfoTool isConnectToNetwork]) {
        [self.view showLoadingWithTitle:@"正在努力加载"];
    }
    webView.scrollView.scrollEnabled = YES;
    self.view.userInteractionEnabled = YES;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)erro {
    if ([GXUserInfoTool isConnectToNetwork]) {
        
    } else {
        webView.scrollView.scrollEnabled = NO;
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.view removeTipView];
    
    self.view.userInteractionEnabled = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [webView stringByEvaluatingJavaScriptFromString:
     @"var script = document.createElement('script');"
     "script.type = 'text/javascript';"
     "script.text = \"function ResizeImages() { "
     "var myimg,oldwidth;"
     "var maxwidth=350;" //缩放系数
     "for(i=0;i <document.images.length;i++){"
     "myimg = document.images[i];"
     "if(myimg.width > maxwidth){"
     "oldwidth = myimg.width;"
     "myimg.width = maxwidth;"
     "myimg.height = myimg.height * (maxwidth/oldwidth);"
     "}"
     "}"
     "}\";"
     "document.getElementsByTagName('head')[0].appendChild(script);"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
}

@end
