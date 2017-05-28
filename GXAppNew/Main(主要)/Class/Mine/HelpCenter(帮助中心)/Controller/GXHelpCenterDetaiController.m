//
//  GXHelpCenterDetaiController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/10.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXHelpCenterDetaiController.h"

@interface GXHelpCenterDetaiController ()

@end

@implementation GXHelpCenterDetaiController
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.arr_dataSource=[[NSMutableArray alloc]init];
    }
    return self;
}
-(void)createData
{
    for(int i=0;i<self.arr_dataSource.count;i++)
    {
        GXHelpModel*model=self.arr_dataSource[i];
        model.hight=[model getHeightWithContent:model.content andFontSize:15 andWidth:GXScreenWidth-30];
        [self.arr_dataSource replaceObjectAtIndex:i withObject:model];
    }
    GXHelpModel*model=[[GXHelpModel alloc]init];
    [self.arr_dataSource insertObject:model atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
}
-(void)createUI
{
    [self.view addSubview:self.tableView_bottom];
}
-(GXMineBaseTableView*)tableView_bottom
{
    if(_tableView_bottom==nil)
    {
        _tableView_bottom=[[GXMineBaseTableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64) style:UITableViewStylePlain];
        _tableView_bottom.delegate=self;
        _tableView_bottom.dataSource=self;
        _tableView_bottom.backgroundColor=[UIColor getColor:@"EFEFF4"];
        _tableView_bottom.separatorColor=[UIColor getColor:@"E5E5E8"];
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
    if(section==0)
    {
        return 0;
    }
    return 1;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXHelpModel*model=self.arr_dataSource[indexPath.section];
    static NSString*cellName=@"cell";
    GXHelpDetailCell*cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GXHelpDetailCell" owner:self options:nil]lastObject];
    }
    [cell setModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        return 0;
    }
    GXHelpModel*model=self.arr_dataSource[indexPath.section];
    if(model.isSelected&&model.content.length)
    {
        if(model.certificatePic.length)
        {
            /*
             3:齐鲁，4：津贵所，5：一带一路
             */
            if(model.type.integerValue==3)
            {
                return (GXScreenWidth-30)*(757.0/1080);
            }
            if(model.type.integerValue==4)
            {
                return (GXScreenWidth-30)*(739.0/1080);
            }
            if(model.type.integerValue==5)
            {
                return (GXScreenWidth-30)*(1754.0/1240.0);
            }
            return (GXScreenWidth-30)*(757.0/1080);
        }
        return model.hight+36;
    }
    else
    {
        return 0;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        UIView*headView=[[UIView alloc]init];
        headView.backgroundColor=self.tableView_bottom.backgroundColor;
        return headView;
    }
    GXHelpDetaiSectionlHeaderView*headerView=[[[NSBundle mainBundle]loadNibNamed:@"GXHelpDetaiSectionlHeaderView" owner:self options:nil]lastObject];
    headerView.delegate=self;
    headerView.section=section;
    [headerView setModel:self.arr_dataSource[section]];
    return headerView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return 10;
    }
    return WidthScale_IOS6(56);
}

#pragma mark--GXHelpDetailSectionHeaderViewDelegate
-(void)helpSectionHeaderViewDidClickWithSection:(NSInteger)section
{
    GXHelpModel*model=self.arr_dataSource[section];
    if(model.content.length>0)
    {
        model.isSelected=!model.isSelected;
        [self.arr_dataSource replaceObjectAtIndex:section withObject:model];
        [self.tableView_bottom reloadData];
    }
    else
        if(model.url.length>0)
        {
            GXHelpItemDetailController*itemDetailVC=[[GXHelpItemDetailController alloc]init];
            itemDetailVC.title=model.title;
            itemDetailVC.urlStr=model.url;
            [self.navigationController pushViewController:itemDetailVC animated:YES];
        }
    if(model.exchangeType.integerValue>0)
    {
        [MobClick event:@"trading_detail"];
        GXInvestmentProductViewController*productVC=[[GXInvestmentProductViewController alloc]init];
        if(model.exchangeType.intValue==3)
        {
            //陕西
            productVC.index=2;
        }
        if(model.exchangeType.intValue==1)
        {
            //津贵所
            [MobClick event:@"jgs_gp_detail"];
            productVC.index=1;
        }
        if(model.exchangeType.intValue==2)
        {
            //齐鲁
            [MobClick event:@"qlsp_detail"];
            productVC.index=0;
        }
        [self.navigationController pushViewController:productVC animated:YES];
    }
}

@end
