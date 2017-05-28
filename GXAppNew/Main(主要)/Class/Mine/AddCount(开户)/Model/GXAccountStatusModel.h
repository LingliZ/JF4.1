//
//  GXAccountStatusModel.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/31.
//  Copyright © 2016年 futang yang. All rights reserved.
//
//账户状态
#import "GXMineBaseModel.h"

@interface GXAccountStatusModel : GXMineBaseModel
@property(nonatomic,strong)NSString*account;
@property(nonatomic,strong)NSString*accountStatus;
@property(nonatomic,strong)NSNumber*bankCardStatus;
@property(nonatomic,strong)NSString*bankName;
@property(nonatomic,strong)NSString*customerName;
@property(nonatomic,strong)NSString*idNumber;
@property(nonatomic,strong)NSString*type;

@end
