//
//  GXAddShanxiAccountSuccessController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/2/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXAddShanxiAccountSuccessController.h"

@interface GXAddShanxiAccountSuccessController ()

@end

@implementation GXAddShanxiAccountSuccessController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.model=[[GXAddShanxiAccountSuccessModel alloc]init];
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
    self.title=@"获得实盘账号";
    self.label_account.text=self.model.account;
    self.label_fundPW.text=self.model.fundPWD;
    self.label_tradePW.text=self.model.tradePWD;
    [UIView setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
    NSMutableAttributedString*attributeInstrucStr=[[NSMutableAttributedString alloc]initWithString:self.label_instruct.text];
    [attributeInstrucStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 5)];
    self.label_instruct.attributedText=attributeInstrucStr;
}
- (IBAction)btnClick_next:(UIButton *)sender {
    GXAccountDetailViewController*detailVC=[[GXAccountDetailViewController alloc]init];
    detailVC.exType=2;
    [self.navigationController pushViewController:detailVC animated:YES];
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
