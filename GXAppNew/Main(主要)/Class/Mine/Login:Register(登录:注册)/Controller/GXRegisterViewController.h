//
//  GXRegisterViewController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXSetPasswordController.h"
@interface GXRegisterViewController : GXMineBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *TF_phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *TF_vertyNum;
@property (weak, nonatomic) IBOutlet UIButton *btn_getVerCode;
@property (weak, nonatomic) IBOutlet UIButton *btn_next;

@property (nonatomic,strong)NSString *registerStr;


@end
