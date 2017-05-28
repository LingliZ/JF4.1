//
//  GXAddAccountBankListForGuangguiController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/3/6.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXAddAccountBankListForGuangguiController.h"

@interface GXAddAccountBankListForGuangguiController ()

@end

@implementation GXAddAccountBankListForGuangguiController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self loadDataForBankList];
}
-(void)createUI
{
    self.title=@"选择银行";
    [self.view addSubview:self.tableView_bottom];
}
-(GXMineBaseTableView*)tableView_bottom
{
    if(_tableView_bottom==nil)
    {
        _tableView_bottom=[[GXMineBaseTableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64) style:UITableViewStylePlain];
        _tableView_bottom.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        _tableView_bottom.dataSource=self;
        _tableView_bottom.delegate=self;
    }
    return _tableView_bottom;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr_dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellName=@"cell";
    GXMineBankModel*model=self.arr_dataSource[indexPath.row];
    GXBankForGuangguiCell*cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GXBankForGuangguiCell" owner:self options:nil]lastObject];
    }
    cell.indexPath=indexPath;
    [cell setModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    GXMineBankModel*model=self.arr_dataSource[indexPath.row];
    self.selectBank(model);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)loadDataForBankList
{
    NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
    params[@"type"]=AccountTypeTianjin;
    [GXHttpTool POSTCache:GXUrl_getBankList parameters:params success:^(id responseObject) {
        NSString*success=[NSString stringWithFormat:@"%@",responseObject[@"success"]];
        if(success.intValue==1)
        {
            self.arr_dataSource=[[NSMutableArray alloc]init];
            self.arr_dataSource=[GXMineBankModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
            [self.tableView_bottom reloadData];
        }
    } failure:^(NSError *error) {
        [self loadDataForBankList];
    }];
}

@end
