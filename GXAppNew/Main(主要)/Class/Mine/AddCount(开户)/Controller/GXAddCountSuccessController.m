//
//  GXAddCountSuccessController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/24.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXAddCountSuccessController.h"

@interface GXAddCountSuccessController ()

@end

@implementation GXAddCountSuccessController
{
    NSString*password_deal;
    NSString*password_phone;
}
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
    // Do any additional setup after loading the view from its nib.
    [self createUI];
}
-(void)createUI
{
    self.title=@"开户成功";
    [UIView setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
    UIBarButtonItem*backBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationbar_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
    self.navigationItem.leftBarButtonItem=backBtn;
    self.label_account.text=self.model.account;
    if(self.model.bankCardStatus.intValue==1)
    {
        //银行卡验证成功
        self.label_bankCard_normal.hidden=NO;
        self.label_bankCard_failed.hidden=YES;
        [self.btn_next setTitle:@"下一步(激活账户)" forState:UIControlStateNormal];
    }
    else
    {
        self.label_bankCard_normal.hidden=YES;
        self.label_bankCard_failed.hidden=NO;
        [self.btn_next setTitle:@"验证银行" forState:UIControlStateNormal];
    }
}
-(void)backClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (IBAction)btnClick_next:(UIButton *)sender {
    if(self.model.bankCardStatus.intValue==1)
    {
        //银行卡验证通过
        GXAccountDetailViewController*detailVC=[[GXAccountDetailViewController alloc]init];
        if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForQilu])
        {
            detailVC.exType=0;
        }
        if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForTianjin])
        {
            detailVC.exType=1;
        }
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    else
    {
        [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count-3] animated:YES];
    }
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
