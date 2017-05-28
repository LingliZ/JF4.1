//
//  GXDetailWebController.m
//  GXApp
//
//  Created by zhudong on 16/8/17.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXDetailWebController.h"

@implementation GXDetailWebController
- (void)loadView{
    self.view = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}
- (void)viewDidLoad{
    [super viewDidLoad];
    UIWebView *webView = (UIWebView *)self.view;
    [webView loadRequest:[NSURLRequest requestWithURL:self.url]];
}
@end
