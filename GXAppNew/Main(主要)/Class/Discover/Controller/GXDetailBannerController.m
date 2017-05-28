//
//  GXDetailBannerController.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/9.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXDetailBannerController.h"
#import <WebKit/WebKit.h>

@interface GXDetailBannerController ()

@end

@implementation GXDetailBannerController

- (void)loadView{
    self.view = [[WKWebView alloc] initWithFrame: [UIScreen mainScreen].bounds];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebView *webView = (WKWebView *)self.view;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}

@end
