//
//  GXChangeNameOrNickNameController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/5.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXCustomerInfoCellModel.h"
@interface GXChangeNameOrNickNameController : GXMineBaseViewController
@property(nonatomic,strong)GXCustomerInfoCellModel*model;
@property(nonatomic,assign)BOOL isChangeNickName;
@property (weak, nonatomic) IBOutlet UITextField *TF_content;


@end
