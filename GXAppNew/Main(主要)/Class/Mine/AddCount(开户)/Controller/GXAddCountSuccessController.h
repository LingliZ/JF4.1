//
//  GXAddCountSuccessController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/24.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXAddCountSucessModel.h"
#import "GXAccountDetailViewController.h"
@interface GXAddCountSuccessController : GXMineBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *label_account;
@property (weak, nonatomic) IBOutlet UIButton *btn_next;
@property(nonatomic,strong)GXAddCountSucessModel*model;

@property (weak, nonatomic) IBOutlet UILabel *label_password_deal;//交易密码
@property (weak, nonatomic) IBOutlet UILabel *label_password_phone;//电话密码
@property (weak, nonatomic) IBOutlet UILabel *label_bankCard_normal;
@property (weak, nonatomic) IBOutlet UILabel *label_bankCard_failed;


@end
