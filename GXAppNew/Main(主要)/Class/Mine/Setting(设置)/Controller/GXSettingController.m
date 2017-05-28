//
//  GXSettingController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/21.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXSettingController.h"

@interface GXSettingController ()

@end

@implementation GXSettingController
-(void)viewWillAppear:(BOOL)animated
{
    [self isLogin];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createData];
    [self createUI];
}
-(void)createUI
{
    self.title=@"设置";
    [self.view addSubview:self.tableView_bottom];
}
-(void)createData
{
    self.arr_dataSource=[[NSMutableArray alloc]init];
    NSArray*arr_Section0=@[@"隐私与安全"];
    NSArray*arr_Section1= @[@"推送设置",@"短信提示",@"清理缓存",@"给我评分"];
    NSArray*arr_Section2=@[@"关于国鑫"];
    
    NSMutableArray*arr_tmp=[[NSMutableArray alloc]initWithObjects:arr_Section0,arr_Section1,arr_Section2, nil];
    for(NSArray*arr in arr_tmp)
    {
        NSMutableArray*arr_model=[[NSMutableArray alloc]init];
        for(int i=0;i<arr.count;i++)
        {
            GXSetModel*model=[[GXSetModel alloc]init];
            model.title=arr[i];
            [arr_model addObject:model];
        }
        [self.arr_dataSource addObject:arr_model];
    }
    
    GXSetModel*model=self.arr_dataSource[1][2];
    SDImageCache*tmpSD=[SDImageCache sharedImageCache];
    NSInteger cacheSize=[tmpSD getSize];
    model.content=@"0";
    if(cacheSize>0)
    {
        model.content=[NSString stringWithFormat:@"%.2f",cacheSize/1024.0/1024.0];
    }
    
    [self.arr_dataSource[1] replaceObjectAtIndex:2 withObject:model];

}
-(void)isLogin
{
    if([GXUserInfoTool isLogin])
    {
        self.btn_LoginOut.hidden=NO;
    }
    else
    {
        self.btn_LoginOut.hidden=YES;
    }
    [self.tableView_bottom reloadData];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0||section==2)
    {
        return 1;
    }
    if(section==1)
    {
        return 4;
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*cellName=@"cell";
    GXSetCell*cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GXSetCell" owner:self options:nil]lastObject];
    }
    cell.indexPath=indexPath;
    [cell setModel:self.arr_dataSource[indexPath.section][indexPath.row]];
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
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view_header=[[UIView alloc]init];
    view_header.backgroundColor=[UIColor getColor:@"EFEFF4"];
    return view_header;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton*btn=[UIButton buttonWithType:UIButtonTypeSystem];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTintColor:[UIColor redColor]];
    btn.titleLabel.textColor=[UIColor redColor];
    [btn setTitle:@"退出我的账号" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick_LogOut:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section==3)
    {
        if([GXUserInfoTool isLogin])
        {
            return WidthScale_IOS6(50);
        }
        return 0;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
            [MobClick event:@"account_security"];
            if(![GXUserInfoTool isLogin])
            {
                [MobClick event:@"uc_set_account_safe_login"];
                GXLoginByVertyViewController*logVC=[[GXLoginByVertyViewController alloc]init];
                logVC.type=@"uc_set_account_safe_login";
                [self.navigationController pushViewController:logVC animated:YES];
                return;
            }
            GXSecurityController*securityVC=[[GXSecurityController alloc]init];
            [self.navigationController pushViewController:securityVC animated:YES];
        }
    }
    if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            [MobClick event:@"message_warn_set"];
            //推送设置
            GXPushSetViewController*pushVC=[[GXPushSetViewController alloc]init];
            [self.navigationController pushViewController:pushVC animated:YES];
        }
        if(indexPath.row==1)
        {
            [MobClick event:@"SMS_alert"];
            if(![GXUserInfoTool isLogin])
            {
                [MobClick event:@"uc_set_SMS_login"];
                GXLoginByVertyViewController*logVC=[[GXLoginByVertyViewController alloc]init];
                logVC.type=@"uc_set_SMS_login";
                [self.navigationController pushViewController:logVC animated:YES];
                return;
            }
            //短信提示
            GXShortMsgAlertController*msgVC=[[GXShortMsgAlertController alloc]init];
            [self.navigationController pushViewController:msgVC animated:YES];
        }
        if(indexPath.row==2)
        {
            //清理缓存
            [MobClick event:@"clear_cache"];
            [self clearCache];
        }
        if(indexPath.row==3)
        {
            //给我评分
            [MobClick event:@"evaluate"];
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=744653970&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
        }
    }
    if(indexPath.section==2)
    {
        if(indexPath.row==0)
        {
            [MobClick event:@"about_us"];
            GXAboutUsViewController*aboutVC=[[GXAboutUsViewController alloc]init];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
    }
}
- (IBAction)btnClick_LogOut:(UIButton *)sender {
    [MobClick event:@"logout"];
    UIActionSheet*actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"退出登录", nil];
    [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        //退出登录
        [GXUserInfoTool loginOut];
        [self.navigationController popViewControllerAnimated:YES];

    }
}
-(void)clearCache
{
    [GXAdaptiveHeightTool cleanWKWebViewCache];
    SDImageCache*sd=[SDImageCache sharedImageCache];
    NSInteger num=[sd getDiskCount];
    NSInteger size=[sd getSize];
    if(size ==0)
    {
        [self.view showFailWithTitle:@"已是最佳状态，无需清理"];
    }
    else
    {
        [self.view showLoadingWithTitle:@"正在清理缓存"];
        [sd cleanDiskWithCompletionBlock:^{
            [self.view removeTipView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.view showSuccessWithTitle:@"清理完毕"];
                [sd clearDisk];
                NSInteger sizeTmp=[sd getSize];
//                self.label_cach.text=[NSString stringWithFormat:@"%ldM",sizeTmp/1024/1024];
                GXSetModel*model=self.arr_dataSource[1][2];
                model.content=[NSString stringWithFormat:@"%ld",sizeTmp/1024/1024];
                [self.arr_dataSource[1] replaceObjectAtIndex:2 withObject:model];
                [self.tableView_bottom reloadData];
            });
        }];
    }
}

@end
