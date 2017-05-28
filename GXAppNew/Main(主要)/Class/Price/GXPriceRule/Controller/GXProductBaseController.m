//
//  GXProductBaseController.m
//  GXApp
//
//  Created by GXJF on 16/7/15.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXProductBaseController.h"

@interface GXProductBaseController ()<UIWebViewDelegate>

@end

@implementation GXProductBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.GXProductWebView.backgroundColor = [UIColor colorWithWhite:0.973 alpha:1.000];
    self.GXProductWebView.delegate = self;
    self.GXProductWebView.scrollView.showsVerticalScrollIndicator = NO;
//    self.GXProductWebView.scalesPageToFit = NO;
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.GXProductWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.postUrlArray[self.type]]]];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)erro{
    if ([GXUserInfoTool isConnectToNetwork]) {
        
    }else{
        
        webView.scrollView.scrollEnabled = NO;
        
//        [self showErrorNetMsg:nil Handler:^{
//            [self viewWillAppear:YES];
//            
//            
//        }];
    }
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    if ([GXUserInfoTool isConnectToNetwork]) {
        [self.view showLoadingWithTitle:@"正在努力加载"];
    }
    webView.scrollView.scrollEnabled = YES;

    self.view.userInteractionEnabled = YES;
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.view removeTipView];
    self.view.userInteractionEnabled = YES;
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
