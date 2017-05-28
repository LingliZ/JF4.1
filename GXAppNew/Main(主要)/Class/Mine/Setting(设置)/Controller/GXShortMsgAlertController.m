//
//  GXShortMsgAlertController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/14.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXShortMsgAlertController.h"

@interface GXShortMsgAlertController ()

@end

@implementation GXShortMsgAlertController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createData];
    [self createUI];
    [self getSmsStatus];
}


// 获取开关状态
- (void)getSmsStatus {
    
    // 及时建议
    [GXHttpTool POST:GXUrl_GetReceiveCallStatus parameters:nil success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            
            BOOL isON = [responseObject[@"value"] integerValue];
            
            GXPushSetModel*model=self.arr_dataSource[0];
            model.isOpened = isON;
            [self.arr_dataSource replaceObjectAtIndex:0 withObject:model];
            [self.tableView_bottom reloadData];
            
            // 保存
            [GXUserdefult setBool:isON forKey:@"isFirstReceiveShortMsg_Suggestion"];
            [GXUserdefult synchronize];
            
        } else {
            
        }
        
    } failure:^(NSError *error) {
    }];
    
    
    // 报价提醒
    [GXHttpTool POST:GXUrl_GetQuotationReminderSms parameters:nil success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            
            BOOL isON = [responseObject[@"value"] integerValue];
            
            GXPushSetModel*model=self.arr_dataSource[1];
            model.isOpened = isON;
            [self.arr_dataSource replaceObjectAtIndex:1 withObject:model];
            [self.tableView_bottom reloadData];
            
            // 保存
            [GXUserdefult setBool:isON forKey:@"isFirstReceiveShortMsg_PriceAlert"];
            [GXUserdefult synchronize];
            
        } else {

        }
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

-(void)createData
{
    self.arr_dataSource=[[NSMutableArray alloc]init];
    NSArray*arr_title=@[@"短信提示新即时建议",@"短信提示新报价提醒",];
    NSArray*arr_switch=@[@([GXUserInfoTool isReceiveShortMsg_Suggestion]),@([GXUserInfoTool isReceiveShortMsg_PriceAlert])];
    for(int i=0;i<arr_title.count;i++)
    {
        GXPushSetModel*model=[[GXPushSetModel alloc]init];
        model.title=arr_title[i];
        model.isOpened=[arr_switch[i]intValue];
        [self.arr_dataSource addObject:model];
    }

}
-(void)createUI
{
    self.title=@"短信提示";
    [self.view addSubview:self.tableView_bottom];
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
    GXShortMsgAlertCell*cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GXShortMsgAlertCell" owner:self options:nil]lastObject];
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
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel*label_alert=[[UILabel alloc]init];
    label_alert.text=@"\n   短信提示由第三方短信平台通过运营商发送，可能因网络或信号问题产生延误";
    label_alert.font=[UIFont systemFontOfSize:12];
    label_alert.textColor=[UIColor lightGrayColor];
    label_alert.numberOfLines=0;
    return label_alert;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark--GXShortMsgAlertCellDelegate
-(void)shortMsgSwitchValueChangedWithValue:(BOOL)value andIndexPath:(NSIndexPath *)indexPath
{
    GXPushSetModel*model=self.arr_dataSource[indexPath.row];
    model.isOpened=value;
    [self.arr_dataSource replaceObjectAtIndex:indexPath.row withObject:model];
    
    if (indexPath.row == 0) {
        [self setSuggestionSms:model];
    } else if (indexPath.row == 1) {
        [self setPriceAlertSms:model];
    }
    
}



// 设置即时建议
- (void)setSuggestionSms:(GXPushSetModel *)model {
    

    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"isReceiveCall"] = [NSNumber numberWithBool:model.isOpened];
    
    // 访问接口
    [GXHttpTool POST:GXUrl_SetReceiveCallStatus parameters:param success:^(id responseObject) {
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            DLog(@"设置即时建议成功");
        } else {

        }
    } failure:^(NSError *error) {
        
    }];
}


// 设置短信报价提醒
- (void)setPriceAlertSms:(GXPushSetModel *)model {
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"bySms"] = [NSNumber numberWithBool:model.isOpened];
    
    // 访问接口
    [GXHttpTool POST:GXUrl_SetQuotationReminderSms parameters:param success:^(id responseObject) {
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            DLog(@"设置报价提醒成功");
        } else {
   
        }
        
    } failure:^(NSError *error) {
        
    }];
}






@end
