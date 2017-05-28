//
//  GXMineController.m
//  GXAppNew
//
//  Created by futang yang on 2016/11/28.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineController.h"
#import "GXMineBaseTableView.h"
@interface GXMineController ()
@property(nonatomic,strong)GXMineBaseTableView*tableView_bottom;
@end
@implementation GXMineController
{
    UILabel*label_onlineMsgCount;
    UILabel*label_messageCount;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavAlpha:0];
    self.navigationController.navigationBar.translucent=YES;
    [self isLogin];
    [self getOnlineServiceMsgCount];
    [self getMessageCount];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setNavAlpha:1.0];
    self.navigationController.navigationBar.translucent=NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createData];
    [self createUI];
    [self isLogin];
}
-(void)createData
{
    self.arr_dataSource=[[NSMutableArray alloc]init];
    NSArray*arr_Section0=[[NSArray alloc]init];
    NSArray*arr_Section1=[[NSArray alloc]init];
    
    arr_Section0=@[@{@"name_markImg":@"mine_homeCellMark_Shanxi",
                     @"name_markImg_night":@"mine_homeCellMark_Shanxi_night",
                     @"name_title":@"陕西一带一路大宗商品交易中心",
                     },
                   @{@"name_markImg":@"mine_homeCellMark_Tianjin",
                     @"name_markImg_night":@"mine_homeCellMark_Tianjin_night",
                     @"name_title":@"天津贵金属交易所",
                     }];
    
    arr_Section1=@[@{@"name_markImg":@"mine_homeCellMark_Help",
                     @"name_markImg_night":@"mine_homeCellMark_Help_night",
                     @"name_title":@"帮助中心",
                     },
                   @{@"name_markImg":@"mine_homeCellMark_FeedBack",
                     @"name_markImg_night":@"mine_homeCellMark_FeedBack_night",
                     @"name_title":@"意见反馈",
                     },
                   @{@"name_markImg":@"mine_homeCellMark_NightModel",
                     @"name_markImg_night":@"mine_homeCellMark_NightModel_night",
                     @"name_title":@"夜间模式",
                     },
                   @{@"name_markImg":@"mine_homeCellMark_Set",
                     @"name_markImg_night":@"mine_homeCellMark_Set_night",
                     @"name_title":@"设置",
                     }];
   
    [self.arr_dataSource addObject:[GXmine_HomeModel mj_objectArrayWithKeyValuesArray:arr_Section0]];
    [self.arr_dataSource addObject:[GXmine_HomeModel mj_objectArrayWithKeyValuesArray:arr_Section1]];
}
-(void)createUI
{
    [self setNaviagtionBar];
    [self.view addSubview:self.tableView_bottom];
}
-(void)setNaviagtionBar
{
    UIButton*btn_back=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn_back addTarget:self action:@selector(btnClick_back) forControlEvents:UIControlEventTouchUpInside];
    [btn_back setImage:[UIImage imageNamed:@"mine_close"] forState:UIControlStateNormal];
    [btn_back sizeToFit];
    UIBarButtonItem*item_back=[[UIBarButtonItem alloc]initWithCustomView:btn_back];
    self.navigationItem.leftBarButtonItem=item_back;
    
    
    UIView*view_onlineService=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 64)];
    UIButton*btn_onlineService=[UIButton buttonWithType:UIButtonTypeCustom];
    btn_onlineService.frame=CGRectMake(0, 20, 44, 44);
    [btn_onlineService addTarget:self action:@selector(btnClick_onlineService) forControlEvents:UIControlEventTouchUpInside];
    [btn_onlineService setImage:[UIImage imageNamed:@"home_rightservice_pic"] forState:UIControlStateNormal];
    [btn_onlineService sizeToFit];
    [view_onlineService addSubview:btn_onlineService];
    label_onlineMsgCount = [[UILabel alloc]initWithFrame:CGRectMake(15, -5, 15, 15)];
    label_onlineMsgCount.text = @"";
    label_onlineMsgCount.textColor = [UIColor whiteColor];
    label_onlineMsgCount.backgroundColor=[UIColor redColor];
    label_onlineMsgCount.textAlignment = NSTextAlignmentCenter;
    label_onlineMsgCount.layer.cornerRadius=7.5;
    label_onlineMsgCount.layer.masksToBounds =YES;
    label_onlineMsgCount.font = [UIFont systemFontOfSize:11];
    [btn_onlineService addSubview:label_onlineMsgCount];
    label_onlineMsgCount.hidden=YES;
    UIBarButtonItem*item_onlineService=[[UIBarButtonItem alloc]initWithCustomView:view_onlineService];
    
    UIButton*btn_mssage=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn_mssage addTarget:self action:@selector(btnClick_message) forControlEvents:UIControlEventTouchUpInside];
    [btn_mssage setImage:[UIImage imageNamed:@"home_messages_pic"] forState:UIControlStateNormal];
    [btn_mssage sizeToFit];
    label_messageCount = [[UILabel alloc]initWithFrame:CGRectMake(15, -5, 15, 15)];
    label_messageCount.text = @"";
    label_messageCount.textColor = [UIColor whiteColor];
    label_messageCount.backgroundColor=[UIColor redColor];
    label_messageCount.textAlignment = NSTextAlignmentCenter;
    label_messageCount.layer.cornerRadius=7.5;
    label_messageCount.layer.masksToBounds =YES;
    label_messageCount.font = [UIFont systemFontOfSize:11];
    [btn_mssage addSubview:label_messageCount];
    label_messageCount.hidden=YES;
    UIBarButtonItem*item_message=[[UIBarButtonItem alloc]initWithCustomView:btn_mssage];
    
    self.navigationItem.rightBarButtonItems=@[item_message,item_onlineService];
    
}
-(void)btnClick_back
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)btnClick_onlineService
{
     [MobClick event:@"uc_online_service"];
    ChatViewController *onlineVC = [[ChatViewController alloc] initWithChatter:EaseMobCusterKey type:eAfterSaleType];
    [self.navigationController pushViewController:onlineVC animated:YES];
}
-(void)btnClick_message
{
    [MobClick event:@"uc_message"];
    if(![GXUserInfoTool isLogin])
    {
        [MobClick event:@"message_login"];
        GXLoginByVertyViewController*loginVC=[[GXLoginByVertyViewController alloc]init];
        loginVC.type=@"message_login";
        [self.navigationController pushViewController:loginVC animated:YES];
        return;
    }
    GXHomeMsgCenterController *msgCenterVC = [[GXHomeMsgCenterController alloc]init];
    [self.navigationController pushViewController:msgCenterVC animated:YES];
}
-(GXMineBaseTableView*)tableView_bottom
{
    if(_tableView_bottom==nil)
    {
        _tableView_bottom=[[GXMineBaseTableView alloc]initWithFrame:CGRectMake(0, -64, GXScreenWidth, GXScreenHeight+64) style:UITableViewStylePlain];
        _tableView_bottom.dk_separatorColorPicker=DKColorPickerWithColors(RGBACOLOR(242, 242, 242, 1),RGBACOLOR(40, 40, 54, 1));
        _tableView_bottom.dk_backgroundColorPicker=DKColorPickerWithColors(RGBACOLOR(241, 241, 245, 1),RGBACOLOR(42, 43, 56, 1));
        _tableView_bottom.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
        _tableView_bottom.delegate=self;
        _tableView_bottom.dataSource=self;
    }
    return _tableView_bottom;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(![GXUserInfoTool isShowOpenAccount])
    {
        if(section==0)
        {
            return 0;
        }
    }
    return [self.arr_dataSource[section]count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arr_dataSource.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXmine_HomeModel*model=self.arr_dataSource[indexPath.section][indexPath.row];
    static NSString*cellName=@"cell";
    GXMine_HomeCell*cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"GXMine_HomeCell" owner:self options:nil]lastObject];
    }
    cell.indexPath=indexPath;
    cell.delegate=self;
    [cell setModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return WidthScale_IOS6(50);
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==1||[GXUserInfoTool isShowOpenAccount])
    {
        return 15;
    }
    return 0;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_tableView_bottom respondsToSelector:@selector(setSeparatorInset:)])
    {
        [_tableView_bottom setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
    }
    if([_tableView_bottom respondsToSelector:@selector(setLayoutMargins:)])
    {
        [_tableView_bottom setLayoutMargins:UIEdgeInsetsZero];
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView*view=[[UIView alloc]init];
    view.dk_backgroundColorPicker=DKColorPickerWithColors(RGBACOLOR(241, 241, 245, 1),RGBACOLOR(42, 43, 56, 1));

    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section==0)
    {
    /*
         //用于调试界面
        GXAddCountController*addCountVC=[[GXAddCountController alloc]init];
        GXAddCountSelectBankController*selectBankVC=[[GXAddCountSelectBankController alloc]init];
        GXCustomerSurveyThreeController*threeVC=[[GXCustomerSurveyThreeController alloc]init];
        GXVertyBankCardController*vertyBankVC=[[GXVertyBankCardController alloc]init];
        GXAddShanxiAccountSuccessController*shanxiVC=[[GXAddShanxiAccountSuccessController alloc]init];
        GXCustomerSurveyTwoController*twoVC=[[GXCustomerSurveyTwoController alloc]init];
        GXAddAccountIdentifyForGuangguiController*idetify_guanguiVC=[[GXAddAccountIdentifyForGuangguiController alloc]init];
        GXAddAccountSuccessForGuangguiController*sucessVC=[[GXAddAccountSuccessForGuangguiController alloc]init];
        GXGuangguiSelectProvinceController*selectProvinceVC=[[GXGuangguiSelectProvinceController alloc]init];
        GXAddAccountSetKeywordsForGuangguiController*setKeyWords=[[GXAddAccountSetKeywordsForGuangguiController alloc]init];
        GXAddAccountVertyBankForGuangguiController*vertyBank_guangguiVC=[[GXAddAccountVertyBankForGuangguiController alloc]init];
        [self.navigationController pushViewController:idetify_guanguiVC animated:YES];
       
         return;
*/
        
        GXmine_HomeModel*model=self.arr_dataSource[indexPath.section][indexPath.row];
        if(model.account.length)
        {
            GXAccountDetailViewController*detailVC=[[GXAccountDetailViewController alloc]init];
            if([model.type isEqualToString:@"qiluce"])
            {
                detailVC.exType=0;
            }
            if([model.type isEqualToString:@"tjpme"])
            {
                detailVC.exType=1;
            }
            if([model.type isEqualToString:AccountTypeShanxi])
            {
                detailVC.exType=2;
            }
            [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
            //帮助中心
            [MobClick event:@"help_center"];
            GXHelpCenterController*helpVC=[[GXHelpCenterController alloc]init];
            [self.navigationController pushViewController:helpVC animated:YES];
        }
        if(indexPath.row==1)
        {
            //意见反馈
            [MobClick event:@"feedback"];
            GXFeedBackController*feedVC=[[GXFeedBackController alloc]init];
            [self.navigationController pushViewController:feedVC animated:YES];
        }
        if(indexPath.row==3)
        {
            //设置
            [MobClick event:@"set"];
            GXSettingController*setVC=[[GXSettingController alloc]init];
            [self.navigationController pushViewController:setVC animated:YES];
        }
        
    }
}
#pragma mark--GXMine_HomeCellDelegate
-(void)addCountBtnDidSelectedWithIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        GXmine_HomeModel*model=self.arr_dataSource[indexPath.section][indexPath.row];
        if(![GXUserInfoTool isLogin])
        {
            GXLoginByVertyViewController*loginVC=[[GXLoginByVertyViewController alloc]init];
            loginVC.registerStr = GXDefaultSiteExchange;
            [self.navigationController pushViewController:loginVC animated:YES];
            return;
        }
        
        if(![model.accountStatus isEqualToString:@"正常"]&&model.account.length)
        {
            GXAccountDetailViewController*detailVC=[[GXAccountDetailViewController alloc]init];
            if([model.type isEqualToString:@"qiluce"])
            {
                detailVC.exType=0;
            }
            if([model.type isEqualToString:@"tjpme"])
            {
                detailVC.exType=1;
            }
            if([model.type isEqualToString:AccountTypeShanxi])
            {
                detailVC.exType=2;
            }
            [self.navigationController pushViewController:detailVC animated:YES];
            return;
        }
        if(indexPath.row==2)
        {
            //齐鲁开户
            [MobClick event:@"uc_qlsp_open_an_account"];
            [GXUserdefult setObject:ForQilu forKey:AddCountFor];
        }
        if(indexPath.row==1)
        {
            //津贵所开户
            [MobClick event:@"uc_jgs_open_an_account"];
            [GXUserdefult setObject:ForTianjin forKey:AddCountFor];
        }
        if(indexPath.row==0)
        {
            //一带一路开户
            [MobClick event:@"uc_sxydyl_open_an_account"];
            [GXUserdefult setObject:ForShanxi forKey:AddCountFor];
            [GXUserdefult synchronize];
            GXAddCountIdentityForShanxiController*addCountVC=[[GXAddCountIdentityForShanxiController alloc]init];
            [self.navigationController pushViewController:addCountVC animated:YES];
            return;
        }
        [GXUserdefult synchronize];
        GXAddCountIdentityController*identiVC=[[GXAddCountIdentityController alloc]init];
        [self.navigationController pushViewController:identiVC animated:YES];
    }
}
-(GXMine_HeadView_Login*)view_login
{
    if(_view_login==nil)
    {
        _view_login=[[[NSBundle mainBundle]loadNibNamed:@"GXMine_HeadView_Login" owner:self options:nil]lastObject];
        _view_login.frame=CGRectMake(0, 0, GXScreenWidth, WidthScale_IOS6(230));
        __weak typeof(GXMineController*)  weakSelf=self;
        _view_login.seeCustomInfo=^{
            [MobClick event:@"personal_information"];
            GXCustomerInfoController*infoVC=[[GXCustomerInfoController alloc]init];
            [weakSelf.navigationController pushViewController:infoVC animated:YES];
        };
    }
    [_view_login setModel:self.model_userInfo];
    return _view_login;
}
-(GXMine_HeadView_noLogin*)view_noLogin
{
    if(_view_noLogin==nil)
    {
        _view_noLogin=[[[NSBundle mainBundle]loadNibNamed:@"GXMine_HeadView_noLogin" owner:self options:nil]lastObject];
        _view_noLogin.frame=CGRectMake(0, 0, GXScreenWidth, WidthScale_IOS6(230));
        __weak typeof (GXMineController*) weakSelf=self;
        _view_noLogin.toLogin=^{
            [MobClick event:@"uc_login"];
            GXLoginByVertyViewController*loginVC=[[GXLoginByVertyViewController alloc]init];
            loginVC.type=@"uc_login";
            [weakSelf.navigationController pushViewController:loginVC animated:YES];
        };
    }
    return _view_noLogin;
}
-(void)isLogin
{
    if([GXUserInfoTool isLogin])
    {
        self.tableView_bottom.tableHeaderView=self.view_login;
        [self getUserInfo];
    }
    else
    {
        self.tableView_bottom.tableHeaderView=self.view_noLogin;
        [self createData];
    }
    [self.tableView_bottom reloadData];
}
#pragma mark--获取用户信息
-(void)getUserInfo
{
    [GXHttpTool POST:GXUrl_customerInfo parameters:nil success:^(id responseObject) {
        if([responseObject[@"success"]intValue]==1)
        {
            [self dealUsetInfoWithObject:responseObject[@"value"]];
            self.tableView_bottom.tableHeaderView=self.view_login;
            [self.tableView_bottom reloadData];
        }
    } failure:^(NSError *error) {
        
        [self showErrorNetMsg:nil withView:self.tableView_bottom];

        
    }];
}
-(void)dealUsetInfoWithObject:(id)responseObject
{
    self.model_userInfo=[[GXUserInfoModel alloc]init];
    self.model_userInfo=[GXUserInfoModel mj_objectWithKeyValues:responseObject];
    for(NSDictionary*dic in self.model_userInfo.customerAccount)
    {
        GXmine_HomeModel*model=[[GXmine_HomeModel alloc]init];
        model=[GXmine_HomeModel mj_objectWithKeyValues:dic];
        /*
        if([model.type isEqualToString:@"qiluce"])
        {
            //齐鲁
            GXmine_HomeModel*model1=self.arr_dataSource[0][2];
            model.name_title=model1.name_title;
            model.name_markImg=model1.name_markImg;
            model.name_markImg_night=model1.name_markImg_night;
            [self.arr_dataSource[0] replaceObjectAtIndex:2 withObject:model];
        }
         */
        if([model.type isEqualToString:@"tjpme"])
        {
            //津贵所
            GXmine_HomeModel*model1=self.arr_dataSource[0][1];
            model.name_title=model1.name_title;
            model.name_markImg=model1.name_markImg;
            model.name_markImg_night=model1.name_markImg_night;
            [self.arr_dataSource[0] replaceObjectAtIndex:1 withObject:model];
        }
        if([model.type isEqualToString:AccountTypeShanxi])
        {
            //一带一路
            GXmine_HomeModel*model1=self.arr_dataSource[0][0];
            model.name_title=model1.name_title;
            model.name_markImg=model1.name_markImg;
            model.name_markImg_night=model1.name_markImg_night;
            [self.arr_dataSource[0] replaceObjectAtIndex:0 withObject:model];
        }

    }
}
-(void)getOnlineServiceMsgCount
{
    NSInteger count = [GXUserInfoTool getCutomerNum];
    if (count > 0) {
        label_onlineMsgCount.hidden = NO;
        label_onlineMsgCount.text = [NSString stringWithFormat:@"%ld", [GXUserInfoTool getCutomerNum]];
    } else {
        label_onlineMsgCount.hidden = YES;
    }
}
-(void)getMessageCount
{
    int msgCounts = [GXUserInfoTool getSuggestNum] + [GXUserInfoTool getReplyNum] + [GXUserInfoTool getAlarmNum];
    if (msgCounts > 0) {
        label_messageCount.hidden = NO;
        label_messageCount.text = [NSString stringWithFormat:@"%d",msgCounts];
    }else{
        label_messageCount.hidden = YES;
    }
}

@end
