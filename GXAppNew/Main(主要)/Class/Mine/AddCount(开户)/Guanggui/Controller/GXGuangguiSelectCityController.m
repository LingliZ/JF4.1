//
//  GXGuangguiSelectCityController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/3/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXGuangguiSelectCityController.h"

@interface GXGuangguiSelectCityController ()

@end

@implementation GXGuangguiSelectCityController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadDataForCity];
}
-(void)createUI
{
    self.title=@"选择开户行所在城市";
    [self.view addSubview:self.tableView_bottom];
}
-(GXMineBaseTableView*)tableView_bottom
{
    if(_tableView_bottom==nil)
    {
        _tableView_bottom=[[GXMineBaseTableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64) style:UITableViewStylePlain];
        _tableView_bottom.delegate=self;
        _tableView_bottom.dataSource=self;
        _tableView_bottom.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView_bottom;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr_dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXGuangguiCityModel*model=self.arr_dataSource[indexPath.row];
    static NSString*cellName=@"cell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.text=model.cityName;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GXGuangguiCityModel*model=self.arr_dataSource[indexPath.row];
    [self.navigationController popToViewController:self.navigationController.childViewControllers[self.navigationController.childViewControllers.count-3] animated:YES];
    self.selectCity(model);
}
#pragma mark--加载城市相关数据
-(void)loadDataForCity
{
    NSDictionary*params=@{@"type":AccountTypeGuanggui,
                          @"province":self.model.provinceCode,
                          };
    [GXHttpTool POST:@"/city-list" parameters:params success:^(id responseObject) {
        if([responseObject[@"success"]integerValue]==1)
        {
            self.arr_dataSource=[[NSMutableArray alloc]init];
            self.arr_dataSource=[GXGuangguiCityModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView_bottom reloadData];
            });
        }
        
    } failure:^(NSError *error) {
        
        
    }];
}
@end
