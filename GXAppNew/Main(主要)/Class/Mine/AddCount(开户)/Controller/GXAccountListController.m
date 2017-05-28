//
//  GXAccountListController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/3/3.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXAccountListController.h"

@interface GXAccountListController ()

@end

@implementation GXAccountListController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isForAddAccount=YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
    [self loadDataForCountStatus];
}
-(void)createData
{
    self.arr_dataSource=[[NSMutableArray alloc]init];
}
-(void)createUI
{
    self.title=@"交易所选择";
    [self.view addSubview:self.tableView_bottom];
}
-(GXMineBaseTableView*)tableView_bottom
{
    if(_tableView_bottom==nil)
    {
        _tableView_bottom=[[GXMineBaseTableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64) style:UITableViewStylePlain];
        _tableView_bottom.delegate=self;
        _tableView_bottom.dataSource=self;
        _tableView_bottom.separatorColor=[UIColor clearColor];
        _tableView_bottom.backgroundColor=[UIColor colorWithHexString:@"E6E9F5"];
    }
    return _tableView_bottom;
}
#pragma mark--UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr_dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellName=@"cell";
    GXAddAccountListCell*cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GXAddAccountListCell" owner:self options:nil]lastObject];
    }
    cell.indexPath=indexPath;
    cell.delegate=self;
    GXAddAccountListModel*model=self.arr_dataSource[indexPath.row];
    [cell setModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXAddAccountListModel*model=self.arr_dataSource[indexPath.row];
    return model.hight;
    return 212+10;
}
 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark--GXAddAccountListCellDelegate
-(void)addAccountCellBtnDidTouchedWith:(NSIndexPath *)indexPatch
{
    GXAddAccountListModel*model=self.arr_dataSource[indexPatch.row];
    if(model.account.length==0)
    {
        //去开户
        if([model.type isEqualToString:AccountTypeQilu])
        {
            //齐鲁
            [MobClick event:@"quickness_qlsp_sp"];
            [GXUserdefult setObject:ForQilu  forKey:AddCountFor];
        }
        if([model.type isEqualToString:AccountTypeTianjin])
        {
            //津贵所
            [MobClick event:@"quickness_jgs_sp"];
            [GXUserdefult setObject:ForTianjin forKey:AddCountFor];
        }
        if([model.type isEqualToString:AccountTypeShanxi])
        {
            //陕西一带一路
             [MobClick event:@"quickness_sxydyl_sp"];
            [GXUserdefult setObject:ForShanxi forKey:AddCountFor];
            GXAddCountIdentityForShanxiController*shanxiVC=[[GXAddCountIdentityForShanxiController alloc]init];
            [self.navigationController pushViewController:shanxiVC animated:YES];
            return;
        }
        if([model.type isEqualToString:AccountTypeGuanggui])
        {
            //广贵中心
            [GXUserdefult setObject:ForGuanggui forKey:AddCountFor];
            GXAddAccountIdentifyForGuangguiController*guangguiVC=[[GXAddAccountIdentifyForGuangguiController alloc]init];
            [self.navigationController pushViewController:guangguiVC animated:YES];
            return;
        }
        GXAddCountIdentityController*identityVC=[[GXAddCountIdentityController alloc]init];
        [self.navigationController pushViewController:identityVC animated:YES];
    }
    else
    {
        //已开户
        GXAccountDetailViewController*detailVC=[[GXAccountDetailViewController alloc]init];
        if([model.type isEqualToString:AccountTypeQilu])
        {
            detailVC.exType=0;
        }
        if([model.type isEqualToString:AccountTypeTianjin])
        {
            detailVC.exType=1;
        }
        if([model.type isEqualToString:AccountTypeShanxi])
        {
            detailVC.exType=2;
        }
        if([model.type isEqualToString:AccountTypeGuanggui])
        {
            detailVC.exType=3;
        }
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
#pragma mark--请求账户状态相关的数据
-(void)loadDataForCountStatus
{
    NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
    params[@"type"]=@"qiluce,tjpme,sxbrme";
    [self.view showLoadingWithTitle:@"正在获取账户状态"];
    [GXHttpTool POST:GXUrl_get_open_account parameters:params success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            self.arr_dataSource=[[NSMutableArray alloc]initWithArray:[GXAddAccountListModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]]];
            for(GXAddAccountListModel*model in self.arr_dataSource)
            {
                if([model isKindOfClass:[GXAddAccountListModel class]])
                {
                    NSString*content=[NSString stringWithFormat:@"%@\n%@\n%@",model.banks,model.produces,model.requirement];
                    model.hight=[model getHeightWithContent:content andFontSize:14 andWidth:(GXScreenWidth-40)]+[model getHeightWithContent:model.subtitle andFontSize:12 andWidth:(GXScreenWidth-100)]+[model getHeightWithContent:model.title andFontSize:18 andWidth:(GXScreenWidth-100)]+121;
                }
            }
            [self.arr_dataSource exchangeObjectAtIndex:2 withObjectAtIndex:0];
            [self.arr_dataSource exchangeObjectAtIndex:1 withObjectAtIndex:2];
            
            for(GXAddAccountListModel*model in self.arr_dataSource)
            {
                if([model isKindOfClass:[GXAddAccountListModel class]])
                {
                    if(model.account.length==0&&[model.type isEqualToString:AccountTypeQilu])
                    {
                        [self.arr_dataSource removeObject:model];
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView_bottom reloadData];
            });
        }
        else
        {
            [self.view showFailWithTitle:@"状态获取失败"];
        }
        
    } failure:^(NSError *error) {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"请求失败，请检查网络设置"];
    }];
}

@end
