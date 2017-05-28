//
//  GXGuangguiSelectCityController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/3/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXGuangguiProvince_rowModel.h"
#import "GXGuangguiCityModel.h"


typedef void(^CityBlock_guanggui)(GXGuangguiCityModel*model) ;
@interface GXGuangguiSelectCityController : GXMineBaseViewController
@property(nonatomic,strong)NSArray*arr_dataSource;
@property(nonatomic,strong)GXMineBaseTableView*tableView_bottom;
@property(nonatomic,strong)GXGuangguiProvince_rowModel*model;
@property(nonatomic,copy)CityBlock_guanggui selectCity;
@end
