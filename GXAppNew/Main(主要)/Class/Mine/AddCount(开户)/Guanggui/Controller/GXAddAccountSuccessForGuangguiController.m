//
//  GXAddAccountSuccessForGuangguiController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/3/8.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXAddAccountSuccessForGuangguiController.h"

@interface GXAddAccountSuccessForGuangguiController ()

@end

@implementation GXAddAccountSuccessForGuangguiController
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
    self.title=@"广贵中心开户";
    [self.view_section1 setBorderWithView:self.view_section1 top:YES left:NO bottom:YES right:NO borderColor:[UIColor lightGrayColor] borderWidth:1 ];
    [self.view_section2 setBorderWithView:self.view_section2 top:YES left:NO bottom:YES right:NO borderColor:[UIColor lightGrayColor] borderWidth:1 ];
    [UIView setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
    [UIView setBorForView:self.view_accountInfo withWidth:0 andColor:nil andCorner:5];
}

@end
