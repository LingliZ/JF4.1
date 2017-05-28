//
//  GXCustomerInfoController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/5.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXCustomerInfoController.h"

@interface GXCustomerInfoController ()

@end

@implementation GXCustomerInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createData];
    [self createUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self getUserInfo];
}
-(void)createUI
{
    self.title=@"个人信息";
    [self.view addSubview:self.tableView_bottom];
}
-(void)createData
{
    self.arr_dataSource=[[NSMutableArray alloc]init];
    NSArray*arr_title=@[@"头像",@"昵称",@"姓名"];
    for(int i=0;i<arr_title.count;i++)
    {
        GXCustomerInfoCellModel*model=[[GXCustomerInfoCellModel alloc]init];
        model.title=arr_title[i];
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
#pragma mark--UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arr_dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellName=@"cell";
    GXCustomerInfoCell*cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GXCustomerInfoCell" owner:self options:nil]lastObject];
    }
    cell.indexPath=indexPath;
    [cell setModel:self.arr_dataSource[indexPath.row]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        if (indexPath.row==0) {
            return WidthScale_IOS6(64);
        }
    }
    return WidthScale_IOS6(50);
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*headView=[[UIView alloc]init];
    return headView;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==0)
    {
        //头像
        GXPickerImageController*pickerVC=[[GXPickerImageController alloc]init];
        pickerVC.view.backgroundColor=[UIColor clearColor];
        __weak typeof(self)wealSelf=self;
        pickerVC.resultImage=^(NSData*imageData){
            [wealSelf commiteHeadImageWithData:imageData];
        };
        [self presentViewController:pickerVC animated:YES completion:nil];
    }
    if(indexPath.row>0)
    {
        GXChangeNameOrNickNameController*changeVC=[[GXChangeNameOrNickNameController alloc]init];
        changeVC.model=self.arr_dataSource[indexPath.row];
        if(indexPath.row==1)
        {
            changeVC.isChangeNickName=YES;
        }
        [self.navigationController pushViewController:changeVC animated:YES];
    }
}
#pragma mark--上传头像
-(void)commiteHeadImageWithData:(NSData*)imageData
{
    //使用时间生成照片的名字
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",[formatter stringFromDate:[NSDate date]]];
    [self.view showLoadingWithTitle:@"正在上传头像"];
    if(![GXUserInfoTool isConnectToNetwork])
    {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"头像上传失败，请检查网络设置"];
        return;
    }
    [GXHttpTool post:GXUrl_updateAvatar image:imageData name:fileName success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]integerValue])
        {
            [self.view showSuccessWithTitle:@"头像提交成功，请等待审核"];
            GXLog(@"头像更换成功");
            NSDictionary*imgDic=@{@"img":imageData};
            [GXNotificationCenter postNotificationName:Mine_Notify_portraitUploadSuccessed object:nil userInfo:imgDic];
        }
        else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        [self.view removeTipView];
        [self.view showFailWithTitle:@"头像上传失败，请检查网络设置"];
        
    }];
}

#pragma mark--获取用户信息
-(void)getUserInfo
{
    [GXAddAccountTool getUserInfoSuccess:^(GXUserInfoModel *userInfoModel) {
        if(userInfoModel)
        {
            GXLog(@"%@",userInfoModel);
            [self dealWithUserInfoWithObject:userInfoModel];
        }
    } Failure:^(NSError *error) {
        

    }];
}
-(void)dealWithUserInfoWithObject:(GXUserInfoModel*)model
{
    if(model.realName==nil)
    {
        model.realName=@"未设置姓名";
    }
    if(model.nickname==nil)
    {
        model.nickname=@"未设置昵称";
    }
    NSArray*arr_content=@[@"",model.nickname,model.realName];
    for(int i=0;i<arr_content.count;i++)
    {
        GXCustomerInfoCellModel*infoModel=self.arr_dataSource[i];
        infoModel.content=arr_content[i];
        infoModel.avatar=[NSString stringWithFormat:@"%@%@",baseImageUrl,model.avatar];
        [self.arr_dataSource replaceObjectAtIndex:i withObject:infoModel];
    }
    [self.tableView_bottom reloadData];
}


@end
