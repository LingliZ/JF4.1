//
//  GXChangeNameOrNickNameController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/5.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXChangeNameOrNickNameController.h"

@interface GXChangeNameOrNickNameController ()

@end

@implementation GXChangeNameOrNickNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}
-(void)createUI
{
    if(self.isChangeNickName)
    {
        self.title=@"昵称";
    }
    else
    {
        self.title=@"姓名";
    }
    UIBarButtonItem*rightBtn=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem=rightBtn;
    self.TF_content.delegate=self;
    if([self.model.content isEqualToString:@"未设置昵称"]||[self.model.content isEqualToString:@"未设置姓名"])
    {
        self.TF_content.text=@"";
    }
    else
    {
        self.TF_content.text=self.model.content;
    }
}
-(void)save
{
    [self.currentTF resignFirstResponder];
    NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
    [params setObject:[GXUserInfoTool getUserTocken] forKey:@"X-IDENTIFY-TOKEN"];
    if(self.isChangeNickName)
    {
        if(![[self.TF_content.text checkNickName] isEqualToString:Check_NickName_Qualified])
        {
            [self.view showFailWithTitle:[self.TF_content.text checkNickName]];
            return;
        }
        [self.view showLoadingWithTitle:@"正在修改昵称"];
        [params setObject:self.TF_content.text forKey:@"nickname"];
        [GXHttpTool POST:GXUrl_updateNickname parameters:params success:^(id responseObject) {
            
            [self.view removeTipView];
            GXLog(@"%@",responseObject);
            NSString*success=[NSString stringWithFormat:@"%@",responseObject[@"success"]];
            if(success.intValue==1)
            {
                
                [self.view showSuccessWithTitle:@"昵称提交成功，请等待审核！"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }
            else
            {
                [self.view showFailWithTitle:responseObject[@"message"]];
            }
            
        } failure:^(NSError *error) {
            [self.view removeTipView];
            
            [self.view showFailWithTitle:@"昵称修改失败，请检查网络设置"];
        }];
    }
    else
    {
        if(![[self.TF_content.text checkName]isEqualToString:Check_Name_Qualified])
        {
            [self.view showFailWithTitle:[self.TF_content.text checkName]];
            return;
        }
        [self.view showLoadingWithTitle:@"正在修改姓名"];
        [params setObject:GXRsaEncryptor_string(self.TF_content.text) forKey:@"realName"];
        
        [GXHttpTool POST:GXUrl_updateRealName parameters:params success:^(id responseObject) {
            [self.view removeTipView];
            NSString*success=[NSString stringWithFormat:@"%@",responseObject[@"success"]];
            if(success.intValue)
            {
                
                //[self.delegate editNameFinshedWithName:self.TF_name.text];
                
                [self.view showSuccessWithTitle:@"姓名修改成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
            else
            {
                [self.view showFailWithTitle:responseObject[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
            [self.view removeTipView];
            [self.view showFailWithTitle:@"姓名修改失败，请检查网络设置"];
        }];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.currentTF=textField;
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
