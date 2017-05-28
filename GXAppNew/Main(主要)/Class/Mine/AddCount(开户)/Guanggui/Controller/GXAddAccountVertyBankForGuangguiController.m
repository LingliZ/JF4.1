//
//  GXAddAccountVertyBankForGuangguiController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/3/6.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXAddAccountVertyBankForGuangguiController.h"

@interface GXAddAccountVertyBankForGuangguiController ()

@end

@implementation GXAddAccountVertyBankForGuangguiController
{
    GXVertyBankPhoneNumForGuangguiView*view_vertyBankPhoneNum;
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
    [self createUI];
}
-(void)createUI
{
    self.title=@"广贵中心开户";
    self.TF_cardOwner.delegate=self;
    self.TF_cardNum.delegate=self;
    self.TF_cardPhoneNum.delegate=self;
    self.label_agreement.attributedText=[UILabel getAttributedStringFromString:self.label_agreement.text withColor:GXRGBColor(145, 145, 145) andRange:NSMakeRange(0, 7)];
    [self.btn_next setBtn_nextControlStateDisabled];
    view_vertyBankPhoneNum=[[[NSBundle mainBundle]loadNibNamed:@"GXVertyBankPhoneNumForGuangguiView" owner:self options:nil]lastObject];
    view_vertyBankPhoneNum.frame=CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64);
    view_vertyBankPhoneNum.hidden=YES;
    view_vertyBankPhoneNum.delegate=self;
    [self.view addSubview:view_vertyBankPhoneNum];
}
-(void)editClick
{
    if(self.TF_cardOwner.text.length==0||self.TF_cardNum.text.length==0||self.TF_cardPhoneNum.text.length==0||self.btn_bankName.titleLabel.text.length==0||self.btn_bankAddress.titleLabel.text.length==0||[self.btn_bankName.titleLabel.text containsString:@"请选择"]||[self.btn_bankAddress.titleLabel.text containsString:@"请选择"])
    {
        self.btn_next.enabled=NO;
    }
    else
    {
        self.btn_next.enabled=YES;
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTF=textField;
}
#pragma mark--选择银行
- (IBAction)btnClick_selectBank:(UIButton *)sender {
    GXAddAccountBankListForGuangguiController*bankListVC=[[GXAddAccountBankListForGuangguiController alloc]init];
    __weak typeof(self)weakSelf=self;
    bankListVC.selectBank=^(GXMineBankModel*model){
        dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.btn_bankName setTitle:model.name forState:UIControlStateNormal];
        [weakSelf editClick];
        });
    };
    [self.navigationController pushViewController:bankListVC animated:YES];
}
#pragma mark--选择省市
- (IBAction)btnClick_selectAddress:(UIButton *)sender {
    GXGuangguiSelectProvinceController*selectProvinceVC=[[GXGuangguiSelectProvinceController alloc]init];
    __weak typeof (self)weakSelf=self;
    selectProvinceVC.selectProvinceAndCity=^(GXGuangguiProvince_rowModel*model_province,GXGuangguiCityModel*model_city){
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.btn_bankAddress setTitle:[NSString stringWithFormat:@"%@-%@",model_province.provinceName,model_city.cityName] forState:UIControlStateNormal];
            [weakSelf editClick];
        });
    };
    [self.navigationController pushViewController:selectProvinceVC animated:YES];
}

- (IBAction)btnClick_next:(UIButton *)sender {
    view_vertyBankPhoneNum.hidden=NO;
    [view_vertyBankPhoneNum.btn_timeMark turnModeForSendVertyCodeWithTimeInterval:30];
}
#pragma mark-GXVertyBankPhoneNumForGuangguiViewDelegate
-(void)vertyBankPhoneNumConfirm
{
    GXAddAccountSuccessForGuangguiController*successVC=[[GXAddAccountSuccessForGuangguiController alloc]init];
    [self.navigationController pushViewController:successVC animated:YES];
}
@end
