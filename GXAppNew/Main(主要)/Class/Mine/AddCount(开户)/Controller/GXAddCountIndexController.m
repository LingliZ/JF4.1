//
//  GXAddCountIndexController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXAddCountIndexController.h"

@interface GXAddCountIndexController ()

@end

@implementation GXAddCountIndexController
-(void)viewWillAppear:(BOOL)animated
{
    [self  setNavAlpha:0];
    self.navigationController.navigationBar.translucent=YES;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self setNavAlpha:1.0];
    self.navigationController.navigationBar.translucent=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    [self.img_BG mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        make.top.mas_equalTo(@0);
        make.height.mas_equalTo(@(GXScreenWidth*(1473.0/1125.0)));
    }];
    [self.btn_addCount mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(@15);
        make.right.mas_equalTo(@(-15));
        make.top.mas_equalTo(self.img_BG.mas_bottom).mas_offset(26);
        make.height.mas_equalTo(@46);
    }];
    [UIView setBorForView:self.btn_addCount withWidth:0 andColor:nil andCorner:5];
    if([GXUserInfoTool isShowOpenAccount])
    {
        [self.btn_addCount setTitle:@"立即开户" forState:UIControlStateNormal];
        self.btn_addCount.enabled=YES;
    }
    else
    {
        [self.btn_addCount setTitle:@"暂停开户" forState:UIControlStateNormal];
        self.btn_addCount.enabled=NO;
    }
}
- (IBAction)btnClick_addCount:(UIButton *)sender {
    
    GXAddCountController*addcountVC=[[GXAddCountController alloc]init];
    addcountVC.isForAddAccount=YES;
    GXAccountListController*listVC=[[GXAccountListController alloc]init];
    [self.navigationController pushViewController:listVC animated:YES];
}


@end
