//
//  GXMineInvestTypeModel.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/27.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseModel.h"

@interface GXMineInvestTypeModel : GXMineBaseModel
@property(nonatomic,strong)NSString*name;
@property(nonatomic,strong)NSString*value;

@property(nonatomic,assign)BOOL isSelect;
@end
