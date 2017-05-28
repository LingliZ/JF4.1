//
//  GXSyllabusDetailController.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/15.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXSyllabusDetailController.h"
#import <WebKit/WebKit.h>
#import "GXSyllabusModel.h"

@interface GXSyllabusDetailController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic,strong)WKWebView *wkWebView;
@property (nonatomic,strong)GXSyllabusModel *model;
@end

@implementation GXSyllabusDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    self.wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64)];
    self.wkWebView.navigationDelegate = self;
    [self.view addSubview:self.wkWebView];
    [self loadDataFromServer];
}
-(void)loadDataFromServer{
    NSDictionary *parameter = @{@"id":self.recieveModel.ID};
    [GXHttpTool POSTCache:GXUrl_findInvestSchoolDetails parameters:parameter success:^(id responseObject) {
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            self.model = [GXSyllabusModel new];
            [self.model setValuesForKeysWithDictionary:responseObject[@"value"]];
            NSString *htmlStr = [GXAdaptiveHeightTool syllabusHtmlWithContent:self.model.content title:self.model.title];
            [self.wkWebView loadHTMLString:htmlStr baseURL:nil];
        }
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


@end
