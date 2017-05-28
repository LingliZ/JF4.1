//
//  GXAddCountController.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/21.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXAddCountController.h"

@interface GXAddCountController ()

@end

@implementation GXAddCountController
{
    int accountStatus_Qilu;//0：未开户，1：已激活，2：未激活
    int accountStatus_Tianjin;//0：未开户，1：已激活，2：未激活
    int accountStatus_Shanxi;//0：未开户，1：已激活，2：未激活
}
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
    // Do any additional setup after loading the view from its nib.
    [self createData];
    [self createUI];
    [self loadDataForCountStatus];
}
-(void)createData
{
    self.arr_dataSource=[[NSMutableArray alloc]init];
    NSArray*arr_title=@[@"天津贵金属交易所",
                                 @"陕西一带一路大宗商品交易中心",
                                 @"齐鲁商品交易中心"];
    NSArray*arr_content=@[@"国内现货交易所创新发展模范，适合资金量较大的专业投资者",
                                      @"国内现货交易所创新发展模范，适合资金量较大的专业投资者",
                                      @"入金门槛低，杠杆率高"];
    NSArray*arr_des=@[@"网上开户支持：工商银行、农业银行、光大银行/n交易品种：现货重油、现货银、现货铝、现货铜/n开户条件：开立实盘账户并入金2万",
                      @"网上开户支持：工商银行、农业银行、光大银行/n交易品种：现货重油、现货银、现货铝、现货铜/n开户条件：开立实盘账户并入金2万",
                      @"网上开户支持：工商银行、农业银行、光大银行/n交易品种：现货重油、现货银、现货铝、现货铜/n开户条件：开立实盘账户并入金2万"];
    NSArray*arr_logo=@[@"mine_logo_tianjin",@"mine_logo_shanxi",@"mine_logo_qilu"];
}
-(void)createUI
{
    self.title=@"交易所选择";
    [UIView setBorForView:self.view_addCountForQilu withWidth:0 andColor:nil andCorner:5];
    [UIView setBorForView:self.btn_addCountForQilu withWidth:0 andColor:nil andCorner:5];
    [UIView setBorForView:self.view_addCountForTianjin withWidth:0 andColor:nil andCorner:5];
    [UIView setBorForView:self.btn_AddCountForTianjin withWidth:0 andColor:nil andCorner:5];
    [UIView setBorForView:self.view_shanxi withWidth:0 andColor:nil andCorner:5];
    [UIView setBorForView:self.btn_addCountForShanxi withWidth:0 andColor:nil andCorner:5];
    
    [self.btn_addCountForQilu setBtn_nextControlStateDisabled];
    [self.btn_addCountForShanxi setBtn_nextControlStateDisabled];
    [self.btn_AddCountForTianjin setBtn_nextControlStateDisabled];
    
    [self.btn_addCountForQilu setTitle:@"暂停开户" forState:UIControlStateDisabled];
    self.btn_addCountForQilu.enabled=NO;
    [self.scrollView_bottom mas_remakeConstraints:^(MASConstraintMaker *make) {
        
//        make.height.mas_equalTo(@(GXScreenHeight-154));
    }];
    [self.view_bottom mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@0);
        make.left.mas_equalTo(@0);
        make.right.mas_equalTo(@0);
        make.bottom.mas_equalTo(@0);
        make.width.mas_equalTo(@(GXScreenWidth));
    }];
    if(self.arr_dataSource.count)
    {
        for(GXAccountStatusModel*model in self.arr_dataSource)
        {
            if([model.type isEqualToString:AccountTypeQilu])
            {
                if(model.account.length==0)
                {
                    //未开户
                    [self.btn_addCountForQilu setTitle:@"立即开户" forState:UIControlStateNormal];
                    accountStatus_Qilu=0;
                    self.btn_addCountForQilu.enabled=NO;
                }
                else
                {
                    //已开户
                    if(model.bankCardStatus.intValue==1)
                    {
                        //银行卡正常
//                        [self.btn_addCountForQilu setTitle:@"查看账户详情" forState:UIControlStateNormal];
                        accountStatus_Qilu=1;
                        self.btn_addCountForQilu.enabled=YES;
                         [self.btn_addCountForQilu setTitle:model.account forState:UIControlStateNormal];
                    }
                    else
                    {
                        //验卡未通过
                        [self.btn_addCountForQilu setTitle:@"实盘账户已开立，待激活" forState:UIControlStateNormal];
                        self.btn_addCountForQilu.enabled=NO;
                        accountStatus_Qilu=2;
                    }
                }
            }
            if([model.type isEqualToString:AccountTypeTianjin])
            {
                if(model.account.length==0)
                {
                    //未开户
                    [self.btn_AddCountForTianjin setTitle:@"立即开户" forState:UIControlStateNormal];
                    accountStatus_Tianjin=0;
                }
                else
                {
                    //已开户
                    
                    if(model.bankCardStatus.integerValue==-1)
                    {
                        [self.btn_AddCountForTianjin setTitle:@"实盘账户已开立，待验卡" forState:UIControlStateNormal];
                        accountStatus_Tianjin=1;
                    }
                    else
                    {
                        //验卡未通过
                        [self.btn_AddCountForTianjin setTitle:@"实盘账户已开立，待激活" forState:UIControlStateNormal];
                        accountStatus_Tianjin=2;
                    }
                    if(model.bankCardStatus.intValue==1)
                    {
                        //银行卡正常
                        [self.btn_AddCountForTianjin setTitle:@"查看账户详情" forState:UIControlStateNormal];
                        accountStatus_Tianjin=1;
                    }
                }

            }
            if([model.type isEqualToString:AccountTypeShanxi])
            {
                if(model.account.length==0)
                {
                    //未开户
                    [self.btn_addCountForShanxi setTitle:@"立即开户" forState:UIControlStateNormal];
                    accountStatus_Shanxi=0;
                }
                else
                {
                    //已开户
                    if(model.bankCardStatus.intValue==1)
                    {
                        //银行卡正常
                        [self.btn_addCountForShanxi setTitle:@"查看账户详情" forState:UIControlStateNormal];
                        accountStatus_Shanxi=1;
                    }
                    else
                    {
                        //验卡未通过
                        [self.btn_addCountForShanxi setTitle:@"实盘账户已开立，待激活" forState:UIControlStateNormal];
                        accountStatus_Shanxi=2;
                    }
                }
                
            }
        }
    }
}
#pragma mark--请求账户状态相关的数据
-(void)loadDataForCountStatus
{
    NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
    params[@"type"]=@"qiluce,tjpme,sxbrme";
    self.btn_AddCountForTianjin.enabled=NO;
    self.btn_addCountForQilu.enabled=NO;
    self.btn_addCountForShanxi.enabled=NO;
    self.view.frame = CGRectMake(0, 0, GXScreenWidth, GXScreenHeight);
    [self.view showLoadingWithTitle:@"正在获取账户状态"];
    [GXHttpTool POST:GXUrl_get_open_account parameters:params success:^(id responseObject) {
        [self.view removeTipView];
        if([responseObject[@"success"]intValue]==1)
        {
            [self dealWithDataForCountStatus:responseObject[@"value"]];
            self.btn_AddCountForTianjin.enabled=YES;
//            self.btn_addCountForQilu.enabled=YES;
            self.btn_addCountForShanxi.enabled=YES;
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
-(void)dealWithDataForCountStatus:(id)data
{
    self.arr_dataSource=[[NSMutableArray alloc]init];
    for(NSDictionary*dic in data)
    {
        GXAccountStatusModel*model=[GXAccountStatusModel mj_objectWithKeyValues:dic];
        [self.arr_dataSource addObject:model];
    }
    [self createUI];
}
- (IBAction)btnClick_next:(UIButton *)sender {
    if(sender.tag==0)
    {
        //齐鲁
        switch (accountStatus_Qilu) {
            case 0:
            {
                //开户
                [MobClick event:@"quickness_qlsp_sp"];
                [GXUserdefult setObject:ForQilu forKey:AddCountFor];
                GXAddCountIdentityController*identityVC=[[GXAddCountIdentityController alloc]init];
                identityVC.isForAddAccount=YES;
                [self.navigationController pushViewController:identityVC animated:YES];
            }
                break;
                
            default:
            {
                //激活/验卡
                GXAccountDetailViewController*detailVC=[[GXAccountDetailViewController alloc]init];
                detailVC.exType=0;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
                break;
        }
    }
    if(sender.tag==1)
    {
        //津贵所
        switch (accountStatus_Tianjin) {
            case 0:
            {
                //开户
                [MobClick event:@"quickness_jgs_sp"];
                [GXUserdefult setObject:ForTianjin forKey:AddCountFor];
                GXAddCountIdentityController*identityVC=[[GXAddCountIdentityController alloc]init];
                identityVC.isForAddAccount=YES;
                [self.navigationController pushViewController:identityVC animated:YES];
            }
                break;
            default:
            {
                //激活/验卡
                GXAccountDetailViewController*detailVC=[[GXAccountDetailViewController alloc]init];
                detailVC.exType=1;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
                break;
        }
    }
    if(sender.tag==2)
    {
        //陕西一带一路
        switch (accountStatus_Shanxi) {
            case 0:
            {
                //开户
                [MobClick event:@"quickness_sxydyl_sp"];
                [GXUserdefult setObject:ForShanxi forKey:AddCountFor];
                
//                GXCustomerSurveyTwoController*surveyVC=[[GXCustomerSurveyTwoController alloc]init];
//                [self.navigationController pushViewController:surveyVC animated:YES];
//                return;
                
                
                GXAddCountIdentityForShanxiController*identityVC=[[GXAddCountIdentityForShanxiController alloc]init];
                identityVC.isForAddAccount=YES;
                [self.navigationController pushViewController:identityVC animated:YES];
            }
                break;
                
            default:
            {
                //激活/验卡
                GXAccountDetailViewController*detailVC=[[GXAccountDetailViewController alloc]init];
                detailVC.exType=2;
                [self.navigationController pushViewController:detailVC animated:YES];
            }
                break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
