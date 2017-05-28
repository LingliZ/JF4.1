//
//  GXAddShanxiAccountSuccessModel.h
//  GXAppNew
//
//  Created by WangLinfang on 17/2/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseModel.h"

@interface GXAddShanxiAccountSuccessModel : GXMineBaseModel
@property(nonatomic,strong)NSString*account;//实盘账号
@property(nonatomic,strong)NSString*accountName;//真实姓名
@property(nonatomic,strong)NSString*customerId;//用户ID
@property(nonatomic,strong)NSString*depositHelpId;
@property(nonatomic,strong)NSString*fundPWD;//资金密码
@property(nonatomic,strong)NSString*helpId;
@property(nonatomic,strong)NSString*idNumber;//身份证号码
@property(nonatomic,strong)NSString*msg;
@property(nonatomic,strong)NSString*password;
@property(nonatomic,strong)NSString*result;
@property(nonatomic,strong)NSString*signHelpId;
@property(nonatomic,strong)NSString*tradePWD;//交易密码
@property(nonatomic,strong)NSString*type;//实盘账户类型


@end
