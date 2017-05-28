//
//  GXSignAgreementFinishedController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXSignAgreementFinishedController.h"

@interface GXSignAgreementFinishedController ()

@end

@implementation GXSignAgreementFinishedController
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
    self.title=@"协议签署";
    [UIView setBorForView:self.btn_finish withWidth:0 andColor:nil andCorner:5];
//    [self.btn_finish setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self.btn_finish setBtn_nextControlStateDisabled];
    if([[GXUserdefult objectForKey:AddCountFor] isEqualToString:ForTianjin])
    {
        self.label_agree1.text=@"我已阅读并同意《风险提示书》、《客户协议书》、《承诺保证书》";
        NSString*userAge=[GXUserInfoTool getUserAgeWithID_CardNum:[GXUserInfoTool getIDCardNum]];
        if(userAge.intValue>=60)
        {
            self.view_agree2.hidden=NO;
        }
    }
    NSMutableAttributedString*str=[[NSMutableAttributedString alloc]initWithString:self.label_agree1.text];
    [str addAttribute:NSForegroundColorAttributeName value:GXColor(145, 145, 145, 1.0) range:NSMakeRange(0, 7)];
    self.label_agree1.attributedText=str;
    self.btn_agree.selected=YES;
    self.btn_agrees.selected=YES;
    [self editClick];
}
-(void)editClick
{
    if(self.btn_agrees.selected==NO||self.btn_agree.selected==NO)
    {
        self.btn_finish.enabled=NO;
    }
    else
    {
        self.btn_finish.enabled=YES;
    }
}
- (IBAction)btnClick_finish:(UIButton *)sender {
    GXCustomerSurveyOneController*surveyVC=[[GXCustomerSurveyOneController alloc]init];
    [self.navigationController pushViewController:surveyVC animated:YES];
}
- (IBAction)btnClick_agreement:(UIButton *)sender {
    sender.selected=!sender.selected;
    [self editClick];
}
- (IBAction)btnClick_agree:(UIButton *)sender {
    GXAgreementController*agreeVC=[[GXAgreementController alloc]init];
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForQilu])
    {
        //齐鲁
        if(sender.tag==0)
        {
            //风险提示书
            agreeVC.urlString=AgreeType_QILU_RISKWARNING;
        }
        if(sender.tag==1)
        {
            //客户协议书
            agreeVC.urlString=AgreeType_QILU_CLIENTAGREEMENT;
        }
        if(sender.tag==2)
        {
            //客户确认函
            agreeVC.urlString=AgreeType_QILU_CLIENTCONFIRM;
        }
        if(sender.tag==3)
        {
            //投资风险特别提示
        }
    }
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForTianjin])
    {
        //津贵所
        if(sender.tag==0)
        {
            //风险提示书
            agreeVC.urlString=AgreeType_TJPME_RISKWARNING;
        }
        if(sender.tag==1)
        {
            //客户协议书
            agreeVC.urlString=AgreeType_TJPME_CLIENTAGREEMENT;
        }
        if(sender.tag==2)
        {
            //承诺保证书
            agreeVC.urlString=AgreeType_TJPME_COMMITMENTLETTER;
        }
        if(sender.tag==3)
        {
            //投资风险特别提示
            agreeVC.urlString=AgreeType_TJPME_RISKSPECIAlTIPS;
        }
    }
    [self.navigationController pushViewController:agreeVC animated:YES];
}


@end
