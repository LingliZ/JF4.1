//
//  GXGuangguiSelectProvinceController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/3/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXGuangguiProvince_sectionModel.h"
#import "GXGuangguiProvince_rowModel.h"
#import "GXGuangguiSelectCityController.h"

typedef void (^ProvinceBlock_guanggui)(GXGuangguiProvince_rowModel*model_province,GXGuangguiCityModel*model_city);
@interface GXGuangguiSelectProvinceController : GXMineBaseViewController
@property(nonatomic,strong)NSArray*arr_dataSource;
@property(nonatomic,strong)GXMineBaseTableView*tableView_bottom;
@property(nonatomic,copy) ProvinceBlock_guanggui selectProvinceAndCity;
@end
