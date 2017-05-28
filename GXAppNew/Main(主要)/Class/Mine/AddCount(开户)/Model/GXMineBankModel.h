//
//  GXMineBankModel.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseModel.h"

@interface GXMineBankModel : GXMineBaseModel
@property(nonatomic,strong)NSString*contract;
@property(nonatomic,strong)NSString*imageUrl;
@property(nonatomic,strong)NSString*introduce;
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*tradeTime;
@property(nonatomic,strong)NSString*value;
@property(nonatomic,strong)NSString*payType;
@property(nonatomic,strong)NSString*payTypeValue;
@end
