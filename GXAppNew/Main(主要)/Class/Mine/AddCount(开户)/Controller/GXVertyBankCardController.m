//
//  GXVertyBankCardController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/24.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXVertyBankCardController.h"

@interface GXVertyBankCardController ()

@end

@implementation GXVertyBankCardController
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
    self.title=@"银行验证";
    [UIView setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
//    [self.btn_next setBackgroundImage:ImageFromHex(Color_btn_next_enabled) forState:UIControlStateDisabled];
    [self.btn_next setBtn_nextControlStateDisabled];
    self.TF_bankCardNum.delegate=self;
}
-(void)editClick
{
    if(self.TF_bankCardNum.text.length==0)
    {
        self.btn_next.enabled=NO;
    }
    else
    {
        self.btn_next.enabled=YES;
    }
}
- (IBAction)btnClick_next:(UIButton *)sender {

    if(self.TF_bankCardNum.text.length<15)
    {
        [self.view showFailWithTitle:@"请输入正确的银行卡号"];
        return;
    }
    [self commitDataForAddCount];
}
-(void)commitDataForAddCount
{
    NSMutableDictionary*commiteparamsDic=[[NSMutableDictionary alloc]initWithDictionary:[GXUserdefult objectForKey:AddCountParams]];
    commiteparamsDic[@"bankAcc"]=[self bankNumToNormalNumWithBankNum:self.TF_bankCardNum.text];
    [self.view showLoadingWithTitle:@"正在提交数据……"];
    [GXHttpTool POST:GXUrl_openAccount parameters:commiteparamsDic success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            [self.view showSuccessWithTitle:responseObject[@"value"][@"msg"]];
            GXAddCountSucessModel*model=[GXAddCountSucessModel mj_objectWithKeyValues:responseObject[@"value"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                GXAddCountSuccessController*successVC=[[GXAddCountSuccessController alloc]init];
                successVC.model=model;
                [self.navigationController pushViewController:successVC animated:YES];
            });
        }
        else
        {
            if([[GXUserdefult objectForKey:AddCountFor]isEqual:ForQilu])
            {
                [MobClick event:@"uc_qlsp_open_an_account_defeat"];
            }
            if([[GXUserdefult objectForKey:AddCountFor]isEqual:ForTianjin])
            {
                [MobClick event:@"uc_jgs_open_an_account_defeat"];
            }
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
        
        
        
    } failure:^(NSError *error) {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"请求失败，请检查网络设置"];
    }];

}
#pragma mark--UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.text.length==0)
    {
        self.btn_next.enabled=NO;
    }
    else
    {
        self.btn_next.enabled=YES;
    }
    if(textField.text.length>30)
    {
        textField.text=[textField.text substringWithRange:NSMakeRange(0, 30)];
    }
    NSString *text = [textField text];
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *newString = @"";
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, 4)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == 4) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, 4)];
    }
    
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    
    if (newString.length > 37) {
        return NO;
    }
    
    [textField setText:newString];
    
    return NO;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [super textFieldDidBeginEditing:textField];
    [self editClick];
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [super textFieldDidEndEditing:textField];
    [self editClick];
}
#pragma mark--银行卡号转正常号 － 去除4位间的空格
-(NSString *)bankNumToNormalNumWithBankNum:(NSString*)bankNum
{
    return [bankNum stringByReplacingOccurrencesOfString:@" " withString:@""];
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
