//
//  GXSetPasswordController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"

@interface GXSetPasswordController : GXMineBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *TF_password;
@property(nonatomic,strong)NSString*phoneNum;
@property(nonatomic,strong)NSString*verCode;
@property (weak, nonatomic) IBOutlet UIButton *btn_finishRegist;

@property (nonatomic,strong)NSString *registerStr;
@end
