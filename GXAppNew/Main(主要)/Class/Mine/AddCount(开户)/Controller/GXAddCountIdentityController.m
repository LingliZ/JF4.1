//
//  GXAddCountIdentityController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/22.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXAddCountIdentityController.h"

@interface GXAddCountIdentityController ()

@end

@implementation GXAddCountIdentityController

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
    self.title=@"身份资料";
    [UIView setBorForView:self.btn_saveAndCommite withWidth:0 andColor:nil andCorner:5];
    self.TF_IDNum.delegate=self;
    self.TF_realName.delegate=self;
//    [self.btn_saveAndCommite setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self.btn_saveAndCommite setBtn_nextControlStateDisabled];
    
    self.TF_realName.text=[GXUserInfoTool getUserReallyName];
    self.TF_IDNum.text=[GXUserInfoTool getIDCardNum];
    [self editClick];
}
-(void)editClick
{
    if(self.TF_IDNum.text.length==0||self.TF_realName.text.length==0)
    {
        self.btn_saveAndCommite.enabled=NO;
    }
    else
    {
        self.btn_saveAndCommite.enabled=YES;
    }
}
- (IBAction)btnClick_SaveAndCommit:(UIButton *)sender {
    if(![[self.TF_realName.text checkName]isEqualToString:Check_Name_Qualified])
    {
        [self.view showFailWithTitle:[self.TF_realName.text checkName]];
        return;
    }
    BOOL isTrueIDNum=[self vertyInfo];
    if(!isTrueIDNum)
    {
        return;
    }
    [GXUserInfoTool saveUserIDCardNum:self.TF_IDNum.text];
    [GXUserInfoTool saveUserReallyName:self.TF_realName.text];
    /*
     交易密码：gx+身份证前4位
     电话密码：身份证前6位
     */
    NSString*password_deal=[NSString stringWithFormat:@"gx%@",[self.TF_IDNum.text substringToIndex:4]];
    NSString*password_phone=[self.TF_IDNum.text substringToIndex:6];
    NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
    params[@"customerName"]=self.TF_realName.text;
    params[@"idNumber"]=self.TF_IDNum.text;
    params[@"phonePWD"]=password_phone;
    params[@"phonePWD1"]=password_phone;
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForQilu])
    {
        params[@"password"]=password_deal;
        params[@"password1"]=password_deal;
        [params setObject:@"qiluce" forKey:@"type"];
    }
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForTianjin])
    {
        params[@"tradePWD"]=password_deal;
        params[@"tradePWD1"]=password_deal;
        [params setObject:@"tjpme" forKey:@"type"];
    }
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForShanxi])
    {
        params[@"type"]=AccountTypeShanxi;
    }

    [GXUserdefult setObject:params forKey:AddCountParams];
    GXSignAgreementController*signVC=[[GXSignAgreementController alloc]init];
    [self.navigationController pushViewController:signVC animated:YES];
}
#pragma mark--身份证校验
-(BOOL)vertyInfo
{
    
    if(self.TF_IDNum.text.length==15||self.TF_IDNum.text.length==18)
    {
        NSString *emailRegex = @"^[0-9]*$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        bool sfzNo = [emailTest evaluateWithObject:[self.TF_IDNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if(self.TF_IDNum.text.length==15)
        {
            if(!sfzNo)
            {
                [self.view showFailWithTitle:@"请输入正确的身份证号"];
                return NO;
            }
        }
        else if (self.TF_IDNum.text.length==18)
        {
            BOOL sfz18NO=[self checkIdentityCardNo:self.TF_IDNum.text];
            if(!sfz18NO)
            {
                [self.view showFailWithTitle:@"请输入正确的身份证号"];
                return NO;
            }
        }
    }
    else
    {
        [self.view showFailWithTitle:@"请输入正确的身份证号码"];
        return NO;
    }
    return YES;
}

#pragma mark - 身份证识别
- (BOOL)checkIdentityCardNo:(NSString*)cardNo
{
    if (cardNo.length != 18) {
        return  NO;
    }
    NSArray* codeArray = [NSArray arrayWithObjects:@"7",@"9",@"10",@"5",@"8",@"4",@"2",@"1",@"6",@"3",@"7",@"9",@"10",@"5",@"8",@"4",@"2", nil];
    NSDictionary* checkCodeDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"1",@"0",@"X",@"9",@"8",@"7",@"6",@"5",@"4",@"3",@"2", nil]  forKeys:[NSArray arrayWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil]];
    
    NSScanner* scan = [NSScanner scannerWithString:[cardNo substringToIndex:17]];
    
    int val;
    BOOL isNum = [scan scanInt:&val] && [scan isAtEnd];
    if (!isNum) {
        return NO;
    }
    int sumValue = 0;
    
    for (int i =0; i<17; i++) {
        sumValue+=[[cardNo substringWithRange:NSMakeRange(i , 1) ] intValue]* [[codeArray objectAtIndex:i] intValue];
    }
    
    NSString* strlast = [checkCodeDic objectForKey:[NSString stringWithFormat:@"%d",sumValue%11]];
    
    if ([strlast isEqualToString: [[cardNo substringWithRange:NSMakeRange(17, 1)]uppercaseString]]) {
        return YES;
    }
    return  NO;
}


@end
