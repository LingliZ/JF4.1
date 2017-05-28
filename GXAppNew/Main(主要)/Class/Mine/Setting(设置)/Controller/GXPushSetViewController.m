//
//  GXPushSetViewController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/5.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXPushSetViewController.h"

@interface GXPushSetViewController ()

@end

@implementation GXPushSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createData];
    [self createUI];
}
-(void)createUI
{
    self.title=@"推送设置";
    [self.view addSubview:self.tableView_bottom];
}
-(void)createData
{
    self.arr_dataSource=[[NSMutableArray alloc]init];
    NSArray*arr_title=@[@"即时建议",@"顾问回复",@"国鑫消息",@"报价提醒",];
    NSArray*arr_switch=@[@([GXUserInfoTool isReceiveAdviceMsg]),@([GXUserInfoTool isReceiveReplayMsg]),@([GXUserInfoTool isRecieveGuoXinMsg]),@([GXUserInfoTool isReceivePriceWarnMsg])];
    for(int i=0;i<arr_title.count;i++)
    {
        GXPushSetModel*model=[[GXPushSetModel alloc]init];
        model.title=arr_title[i];
        model.isOpened=[arr_switch[i]intValue];
        [self.arr_dataSource addObject:model];
    }
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
    return self.arr_dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellName=@"cell";
    GXPushSetCell*cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GXPushSetCell" owner:self options:nil]lastObject];
    }
    cell.delegate=self;
    cell.indexPath=indexPath;
    [cell setModel:self.arr_dataSource[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WidthScale_IOS6(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark--GXPushSetCellDeelgate
-(void)pushCellDidSwitchWithIndePatchx:(NSIndexPath *)indexPatch andValue:(BOOL)value
{
    GXPushSetModel*model=self.arr_dataSource[indexPatch.row];
    model.isOpened=value;
    [self.arr_dataSource replaceObjectAtIndex:indexPatch.row withObject:model];
}

@end
