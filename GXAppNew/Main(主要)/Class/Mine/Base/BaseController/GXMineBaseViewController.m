//
//  GXMineBaseViewController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/16.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"

@interface GXMineBaseViewController ()

@end

@implementation GXMineBaseViewController
{
    UILabel*label_onlineMsgCounts;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type=[[NSString alloc]init];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    if(self.isForAddAccount)
    {
        [self getMessageCounts];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.currentTF resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    AddObserver_EditingState_changeBtnState
    [self editClick];
    [self setUI];
    if(self.isForAddAccount)
    {
        [self addOnlineService];
    }
}
-(void)editClick{
}
-(void)addOnlineService
{
    UIButton*btn_onlineService=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn_onlineService addTarget:self action:@selector(btnClick_onlineServices) forControlEvents:UIControlEventTouchUpInside];
    [btn_onlineService setImage:[UIImage imageNamed:@"home_rightservice_pic"] forState:UIControlStateNormal];
    [btn_onlineService sizeToFit];
    label_onlineMsgCounts = [[UILabel alloc]initWithFrame:CGRectMake(15, -5, 15, 15)];
    label_onlineMsgCounts.text = @"";
    label_onlineMsgCounts.textColor = [UIColor whiteColor];
    label_onlineMsgCounts.backgroundColor=[UIColor redColor];
    label_onlineMsgCounts.textAlignment = NSTextAlignmentCenter;
    label_onlineMsgCounts.layer.cornerRadius=7.5;
    label_onlineMsgCounts.layer.masksToBounds =YES;
    label_onlineMsgCounts.font = [UIFont systemFontOfSize:11];
    [btn_onlineService addSubview:label_onlineMsgCounts];
    label_onlineMsgCounts.hidden=YES;
    UIBarButtonItem*item_onlineService=[[UIBarButtonItem alloc]initWithCustomView:btn_onlineService];
    self.navigationItem.rightBarButtonItem=item_onlineService;

}
-(void)btnClick_onlineServices
{
    [MobClick event:@"uc_online_service"];
    ChatViewController *onlineVC = [[ChatViewController alloc] initWithChatter:EaseMobCusterKey type:eAfterSaleType];
    [self.navigationController pushViewController:onlineVC animated:YES];

}
-(void)getMessageCounts
{
    int msgCounts = [GXUserInfoTool getSuggestNum] + [GXUserInfoTool getReplyNum] + [GXUserInfoTool getAlarmNum];
    if (msgCounts > 0) {
        label_onlineMsgCounts.hidden = NO;
        label_onlineMsgCounts.text = [NSString stringWithFormat:@"%d",msgCounts];
    }else{
        label_onlineMsgCounts.hidden = YES;
    }
}
-(void)setUI
{
//    self.view.backgroundColor=[UIColor getColor:@"2D2F3A"];
}
#pragma mark--UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTF =textField;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame=CGRectMake(0, -40, GXScreenWidth, GXScreenHeight-64);
    }];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame=CGRectMake(0,64, GXScreenWidth, GXScreenHeight-64);
    }];
    
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.currentTF resignFirstResponder];
}
#pragma mark--UIWebViewDelegate
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.view showLoadingWithTitle:@"正在加载内容……"];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.view removeTipView];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.view removeTipView];
    [self.view showFailWithTitle:@"加载失败"];
}

@end
