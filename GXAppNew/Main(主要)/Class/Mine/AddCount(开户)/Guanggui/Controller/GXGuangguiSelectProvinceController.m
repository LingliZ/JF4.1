//
//  GXGuangguiSelectProvinceController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/3/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXGuangguiSelectProvinceController.h"

@interface GXGuangguiSelectProvinceController ()

@end

@implementation GXGuangguiSelectProvinceController
{
    NSMutableArray*arr_tableViewIndexTitles;//索引标题数组
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadDataForProvinces];
}
-(void)createUI
{
    self.title=@"选择开户行所在省份";
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arr_dataSource.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GXGuangguiProvince_sectionModel*model=self.arr_dataSource[section];
    return model.provinces.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXGuangguiProvince_sectionModel*model_section=self.arr_dataSource[indexPath.section];
    GXGuangguiProvince_rowModel*model_row=model_section.provinces[indexPath.row];
    static NSString*cellName=@"cell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.textLabel.text=model_row.provinceName;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXGuangguiProvince_sectionModel*model_section=self.arr_dataSource[section];
    UIView*view_sectionHeader=[[UIView alloc]init];
    view_sectionHeader.backgroundColor=RGBACOLOR(241, 243, 248, 1.0);
    UILabel*label_sectionName=[[UILabel alloc]init];
    label_sectionName.text=model_section.chineseKey;
    label_sectionName.textColor=[UIColor blackColor];
    label_sectionName.font=[UIFont systemFontOfSize:17];
    [view_sectionHeader addSubview:label_sectionName];
    [label_sectionName mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(@15);
        make.top.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
    }];
    return view_sectionHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    __weak typeof (self)weakSelf=self;
    GXGuangguiProvince_sectionModel*model_section=self.arr_dataSource[indexPath.section];
    GXGuangguiProvince_rowModel*model_row=model_section.provinces[indexPath.row];
    GXGuangguiSelectCityController*selectCityVC=[[GXGuangguiSelectCityController alloc]init];
    selectCityVC.model=model_row;
    selectCityVC.selectCity=^(GXGuangguiCityModel*model){
        weakSelf.selectProvinceAndCity(model_row,model);
    };
    [self.navigationController pushViewController:selectCityVC animated:YES];
}
#pragma tableView索引相关
-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return arr_tableViewIndexTitles;
}
#pragma mark--获取省份相关的数据
-(void)loadDataForProvinces
{
    NSDictionary*params=@{@"type":AccountTypeGuanggui};
    [GXHttpTool POST:@"/province-list" parameters:params
 success:^(id responseObject) {
     if([responseObject[@"success"]integerValue]==1)
     {
         self.arr_dataSource=[GXGuangguiProvince_sectionModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
         arr_tableViewIndexTitles=[[NSMutableArray alloc]init];
         for(GXGuangguiProvince_sectionModel*model in self.arr_dataSource)
         {
             if([model isKindOfClass:[GXGuangguiProvince_sectionModel class]])
             {
                 model.provinces=[GXGuangguiProvince_rowModel mj_objectArrayWithKeyValuesArray:model.provinces];
                 [arr_tableViewIndexTitles addObject:model.chineseKey];
             }
         }
         dispatch_async(dispatch_get_main_queue(), ^{
             
             [self.tableView_bottom reloadData];
         });
     }
     
 } failure:^(NSError *error) {
     
     
 }];
}


@end
