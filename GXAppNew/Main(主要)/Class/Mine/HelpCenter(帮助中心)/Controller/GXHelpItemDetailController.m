//
//  GXHelpItemDetailController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/18.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXHelpItemDetailController.h"

@interface GXHelpItemDetailController ()

@end

@implementation GXHelpItemDetailController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.urlStr=[[NSString alloc]init];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(void)createUI
{
    self.webView_content.delegate=self;
    NSURL*url=[NSURL URLWithString:self.urlStr];
    NSURLRequest*request=[NSURLRequest requestWithURL:url];
    [self.webView_content loadRequest:request];
}



@end
