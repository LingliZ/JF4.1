//
//  GXAddShanxiAccountSuccessController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/2/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXAddShanxiAccountSuccessModel.h"
#import "GXAccountDetailViewController.h"
@interface GXAddShanxiAccountSuccessController : GXMineBaseViewController
@property(nonatomic,strong)GXAddShanxiAccountSuccessModel*model;
@property (weak, nonatomic) IBOutlet UILabel *label_instruct;
@property (weak, nonatomic) IBOutlet UILabel *label_account;
@property (weak, nonatomic) IBOutlet UILabel *label_fundPW;
@property (weak, nonatomic) IBOutlet UILabel *label_tradePW;
@property (weak, nonatomic) IBOutlet UIButton *btn_next;






@end
