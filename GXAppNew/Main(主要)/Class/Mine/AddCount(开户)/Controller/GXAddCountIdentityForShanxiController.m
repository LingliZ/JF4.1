//
//  GXAddCountIdentityForShanxiController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/24.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXAddCountIdentityForShanxiController.h"

@interface GXAddCountIdentityForShanxiController ()

@end

@implementation GXAddCountIdentityForShanxiController
{
    BOOL isUploadSuccess_front;
    BOOL isUploadSuccess_behind;
    int currentUploadPic;//1正面    2背面
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
    self.title=@"填写资料";
    [UIButton setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
    [self.btn_next setBtn_nextControlStateDisabled];
    self.TF_userName.delegate=self;
    self.TF_IDCardNum.delegate=self;
    self.TF_userName.text=[GXUserInfoTool getUserReallyName];
    self.TF_IDCardNum.text=[GXUserInfoTool getIDCardNum];
    
    [self editClick];
}
-(void)editClick
{
    if(self.TF_IDCardNum.text.length==0||self.TF_userName.text.length==0)
    {
        self.btn_next.enabled=NO;
    }
    else
    {
        self.btn_next.enabled=YES;
    }
}
- (IBAction)btnClick_uploadIDPhoto:(UIButton *)sender {
    if(sender.tag==0)
    {
        //正面
        currentUploadPic=1;
    }
    if(sender.tag==1)
    {
        //背面
        currentUploadPic=2;
    }
    /*
    UIActionSheet*actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照", nil];
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册获取", nil];
    }
    actionSheet.tag=100;
    [actionSheet showInView:self.view];
     */
    GXPickerImageController*pickerVC=[[GXPickerImageController alloc]init];
    pickerVC.view.backgroundColor=[UIColor clearColor];
    pickerVC.resultImage=^(NSData*imageData){
        [self commiteHeadImageWithData:imageData];
    };
    [self presentViewController:pickerVC animated:NO completion:nil];
}

#pragma mark--上传头像
-(void)commiteHeadImageWithData:(NSData*)imageData
{
    //使用时间生成照片的名字
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:[NSDate date]]];
    if(currentUploadPic==1)
    {
        [self.view showLoadingWithTitle:@"正在上传身份证正面"];
    }
    if(currentUploadPic==2)
    {
        [self.view showLoadingWithTitle:@"正在上传身份证反面"];
    }
    if(![GXUserInfoTool isConnectToNetwork])
    {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"上传失败，请检查网络设置"];
        return;
    }
    NSString*uploadUrl=[[NSString alloc]init];
    if(currentUploadPic==1)
    {
        uploadUrl=GXUrl_updateIDCard_front;
    }
    if(currentUploadPic==2)
    {
        uploadUrl=GXUrl_updateIDCard_behind;
    }
    self.btn_uploadBehind.enabled=NO;
    self.btn_uploadFront.enabled=NO;
    [GXHttpTool post:uploadUrl image:imageData name:fileName success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]integerValue])
        {
            [self.view showSuccessWithTitle:@"上传成功"];
            self.btn_uploadFront.enabled=YES;
            self.btn_uploadBehind.enabled=YES;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if(![GXUserdefult objectForKey:AddCountParams])
                {
                    NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
                    [GXUserdefult setObject:dic forKey:AddCountParams];
                }
                NSMutableDictionary*dic_params=[[NSMutableDictionary alloc]initWithDictionary:[GXUserdefult objectForKey:AddCountParams]];
                if(currentUploadPic==1)
                {
                    self.img_front.image=[UIImage imageWithData:imageData];
                    isUploadSuccess_front=YES;
                    dic_params[@"idCardFrontImg"]=responseObject[@"value"][@"id"];
                }
                if(currentUploadPic==2)
                {
                    self.img_behind.image=[UIImage imageWithData:imageData];
                    isUploadSuccess_behind=YES;
                    dic_params[@"idCardBackImg"]=responseObject[@"value"][@"id"];
                }
                [GXUserdefult setObject:dic_params forKey:AddCountParams];
            });
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
            self.btn_uploadFront.enabled=YES;
            self.btn_uploadBehind.enabled=YES;
        }
        
        
    } failure:^(NSError *error) {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"上传失败，请检查网络设置"];
        self.btn_uploadFront.enabled=YES;
        self.btn_uploadBehind.enabled=YES;
    }];
}


- (IBAction)btnClick_next:(UIButton *)sender {
    [self.currentTF resignFirstResponder];
    if(![[self.TF_userName.text checkName]isEqualToString:Check_Name_Qualified])
    {
        [self.view showFailWithTitle:[self.TF_userName.text checkName]];
        return;
    }
    BOOL isTrueIDNum=[self vertyInfo];
    if(!isTrueIDNum)
    {
        return;
    }
    if(isUploadSuccess_behind==NO||isUploadSuccess_front==NO)
    {
        [self.view showFailWithTitle:@"请上传身份证照片"];
        return;
    }
    [GXUserInfoTool saveUserIDCardNum:self.TF_IDCardNum.text];
    [GXUserInfoTool saveUserReallyName:self.TF_userName.text];
    
    if(![GXUserdefult objectForKey:AddCountParams])
    {
        NSMutableDictionary*dic=[[NSMutableDictionary alloc]init];
        [GXUserdefult setObject:dic forKey:AddCountParams];
    }
    NSMutableDictionary*params=[[NSMutableDictionary alloc]initWithDictionary:[GXUserdefult objectForKey:AddCountParams]];
    params[@"customerName"]=self.TF_userName.text;
    params[@"idNumber"]=self.TF_IDCardNum.text;
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
    if(self.TF_IDCardNum.text.length==15||self.TF_IDCardNum.text.length==18)
    {
        NSString *emailRegex = @"^[0-9]*$";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        bool sfzNo = [emailTest evaluateWithObject:[self.TF_IDCardNum.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        if(self.TF_IDCardNum.text.length==15)
        {
            if(!sfzNo)
            {
                [self.view showFailWithTitle:@"请输入正确的身份证号"];
                return NO;
            }
        }
        else if (self.TF_IDCardNum.text.length==18)
        {
            BOOL sfz18NO=[self checkIdentityCardNo:self.TF_IDCardNum.text];
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
