//
//  GXHelpCenterController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/21.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHelpCenterController.h"

@interface GXHelpCenterController ()

@end

@implementation GXHelpCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createData];
    [self createUI];
}
-(void)createUI
{
    self.title=@"帮助中心";
    [self.view addSubview:self.tableView_bottom];
}
-(void)createData
{
    self.arr_DataSource=[[NSArray alloc]init];
    NSString*filePath=[[NSBundle mainBundle]pathForResource:@"help" ofType:@"txt"];
    NSFileManager*fm=[NSFileManager defaultManager];
    NSData*data=[[NSData alloc]init];
    data=[fm contentsAtPath:filePath];
    NSString*contentStr=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    self.arr_DataSource=[self arrayWithJsonString:contentStr];
}
- (NSArray *)arrayWithJsonString:(NSString *)jsonString{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray*arr= [NSJSONSerialization JSONObjectWithData:jsonData
                                                 options:NSJSONReadingMutableContainers
                                                   error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return arr;
}
-(GXMineBaseTableView*)tableView_bottom
{
    if(_tableView_bottom==nil)
    {
        _tableView_bottom=[[GXMineBaseTableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight) style:UITableViewStylePlain];
        _tableView_bottom.delegate=self;
        _tableView_bottom.dataSource=self;
        _tableView_bottom.backgroundColor=[UIColor getColor:@"EFEFF4"];
        _tableView_bottom.separatorColor=[UIColor getColor:@"E5E5E8"];
        _tableView_bottom.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    }
    return _tableView_bottom;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr_DataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellName=@"cell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text=self.arr_DataSource[indexPath.row][@"title"];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WidthScale_IOS6(56);
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view=[[UIView alloc]init];
    view.backgroundColor=self.tableView_bottom.backgroundColor;
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        [MobClick event:@"help_induction"];
    }
    if(indexPath.row==1)
    {
        [MobClick event:@"help_basic"];
    }
    if(indexPath.row==2)
    {
        [MobClick event:@"help_trading"];
    }
    if(indexPath.row==3)
    {
        [MobClick event:@"help_technical_indicator"];
    }
    if(indexPath.row==4)
    {
        [MobClick event:@"help_jgs"];
    }
    if(indexPath.row==5)
    {
        [MobClick event:@"help_qlsp"];
    }
    if(indexPath.row==6)
    {
//        [MobClick event:@""];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GXHelpCenterDetaiController*detailVC=[[GXHelpCenterDetaiController alloc]init];
    detailVC.title=[NSString stringWithFormat:@"帮助中心-%@",self.arr_DataSource[indexPath.row][@"title"]];
    detailVC.arr_dataSource=[GXHelpModel mj_objectArrayWithKeyValuesArray:self.arr_DataSource[indexPath.row][@"list"]];
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
