//
//  GXAddAccountIllegalAgeForGuangguiController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/3/2.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXAddAccountIllegalAgeForGuangguiController.h"

@interface GXAddAccountIllegalAgeForGuangguiController ()

@end

@implementation GXAddAccountIllegalAgeForGuangguiController
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
    [self createUI];
}
-(void)createUI
{
    self.title=@"身份资料";
    [UIView setBorForView:self.btn_return withWidth:0 andColor:nil andCorner:5];
    UITapGestureRecognizer*tapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(customServiceClick)];
    self.label_customService.userInteractionEnabled=YES;
    [self.label_customService addGestureRecognizer:tapGestureRecognizer];
}
- (IBAction)btnClick_return:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)customServiceClick
{
    [UIButton callPhoneWithPhoneNum:GXPhoneNum atView:self.view];
}



@end
