//
//  GXGuangguiCityModel.h
//  GXAppNew
//
//  Created by WangLinfang on 17/3/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseModel.h"

@interface GXGuangguiCityModel : GXMineBaseModel
@property(nonatomic,strong)NSString*cityName;
@property(nonatomic,strong)NSString*cityCode;
@property(nonatomic,strong)NSString*provinceCode;
@property(nonatomic,strong)NSString*exchangeKey;
@property(nonatomic,copy)NSNumber*id;

@end
