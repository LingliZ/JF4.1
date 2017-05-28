//
//  GXAccountDetailViewController.m
//  GXAppNew
//
//  Created by shenqilong on 16/12/22.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXAccountDetailViewController.h"
#import "AccountDetailConst.h"
#import "GXAccountDetailModel.h"

#import "ChatViewController.h"

#import "GXAccountDetailHeadView.h"
#import "GXAccountDetailListCellView.h"
#import "GXSignContractViewController.h"
#import "GXAddCountSelectBankController.h"
#import "GXAccountDetailTradeView.h"

#import <TMBSV3Trading/TMBSV3TradingManager.h>
#import <QiluTrade/DealLoginViewController.h>

#import "GXsxbrmeSignViewController.h"

@interface GXAccountDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *listmenu;
    
    GXAccountDetailListCellView *listView;
    
    GXAccountDetailModel *accountModel;
    
    GXAccountDetailTradeView *tradeView;
}

@end

@implementation GXAccountDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    listmenu=[[UITableView alloc]initWithFrame:CGRectMake(0, -64, GXScreenWidth, GXScreenHeight) style:UITableViewStylePlain];
    listmenu.dataSource=self;
    listmenu.delegate=self;
    listmenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:listmenu];
    
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:GXAccountDetail_serviceImageName] style:0 target:self action:@selector(rightBtn)];
    
    self.navigationItem.rightBarButtonItem=right;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setNavAlpha:0];
    
    [self.view showLoadingWithTitle:@"加载中"];
    [self headerRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self setNavAlpha:1];
    
    [self.view removeTipView];
    
    //取消定时器
    [tradeView setTimerInvali];
}

-(void)rightBtn
{
    //在线客服
    ChatViewController *onlineVC = [[ChatViewController alloc] initWithChatter:EaseMobCusterKey type:eAfterSaleType];
    [self.navigationController pushViewController:onlineVC animated:YES];
}

-(void)setNavAlpha:(CGFloat)alpha
{
    for (id view in [self.navigationController.navigationBar subviews]) {
        if([NSStringFromClass([view class]) isEqualToString:@"_UINavigationBarBackground"]||[NSStringFromClass([view class]) isEqualToString:@"_UIBarBackground"])
        {
            [view setAlpha:alpha];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - privateMethod
-(void)headerRefreshing
{
    [self loadPriceData];
}

-(void)loadPriceData
{
    [GXHttpTool POST:@"/get-open-account" parameters:@{@"type":@"qiluce,tjpme,sxbrme"} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            
            NSArray *ar=[GXAccountDetailModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];

            
            for (GXAccountDetailModel *model in ar) {
                
                if((self.exType==0 && [model.type isEqualToString:@"qiluce"]) || (self.exType==1 && [model.type isEqualToString:@"tjpme"]) || (self.exType==2 && [model.type isEqualToString:@"sxbrme"]))
                {
                    accountModel=model;
                }
            }
            
            
            //头
            GXAccountDetailHeadView *headerView = [GXAccountDetailHeadView parallaxHeaderViewWithCGSize:CGSizeMake(listmenu.frame.size.width, 200)accountModel:accountModel];
            headerView.delegate=(id)self;
            [listmenu setTableHeaderView:headerView];
            
            
            if(listView)
            {
                [listView removeFromSuperview];
                listView=nil;
            }
            if(tradeView)
            {
                [tradeView removeFromSuperview];
                tradeView=nil;
                [tradeView setTimerInvali];

            }
            
          
            if([accountModel.accountStatus isEqualToString:@"已激活"] && self.exType!=3)
            {
                //账户持仓
                tradeView =[[GXAccountDetailTradeView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-headerView.frame.size.height)];
                tradeView.delegate=(id)self;
                tradeView.tableview=listmenu;
                [tradeView setModelUI:accountModel];
                
                listmenu.backgroundColor=GXAccountDetailTradeView_color_selfBackg;
            }
            else
            {
                //步骤
                listView =[[GXAccountDetailListCellView alloc]initModel:accountModel];
                [listView updateStatus:accountModel];
                listView.vc=self;
                
                listmenu.backgroundColor=[UIColor whiteColor];
                [listmenu reloadData];
                
                [self.view removeTipView];
            }
            
        }else{
            [self.view removeTipView];
        }
        
        
        
    } failure:^(NSError *error) {if(error.code!=-999){
        
        [self.view removeTipView];
    }
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == listmenu)
    {
        if(!listView && !tradeView)return;
        
        [(GXAccountDetailHeadView *)listmenu.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
        
        
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > 80) {
            CGFloat alpha = 1 - ((80 + 64 - offsetY) / 64);
            [self setNavAlpha:alpha];
        }else
        {
            [self setNavAlpha:0];
        }
    }
}

#pragma mark - delegate
-(void)GXAccountDetailTradeView_goTradeBtnClick
{
    if([accountModel.type isEqualToString:@"qiluce"])
    {
        DealLoginViewController *deal = [[DealLoginViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:deal];
        [nav setNavigationBarHidden:YES];
        deal.delegate = (id)self;
        [self presentViewController:nav animated:YES completion:nil];
    }else if([accountModel.type isEqualToString:@"tjpme"])
    {
        [[TMBSV3TradingManager shareInstance] pushToTradingModule:self.navigationController];
    }
}

#pragma mark - DealBackDelegate
-(void)buttonBack:(DealLoginViewController *)dealLoginViewController {
    
    [dealLoginViewController dismissViewControllerAnimated:YES completion:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)exchangePicture {}

#pragma mark - tavleView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if(tradeView)
        [cell.contentView addSubview:tradeView];

    
    if(listView)
        [cell.contentView addSubview:listView];

    

    cell.backgroundColor=[UIColor clearColor];
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tradeView)
        return tradeView.frame.size.height;

    if(listView)
        return listView.frame.size.height;
    
    return 0;
}

#pragma mark - GXAccountDetailHeadViewDelegate
-(void)clickBottomButton:(int)index
{
    if(index==1)
    {
        GXLog(@"入金签约中间页");
        if([accountModel.type isEqualToString:@"sxbrme"])
        {
            [MobClick event:@"uc_sxydyl_verification"];
            GXsxbrmeSignViewController *ss=[[GXsxbrmeSignViewController alloc]init];
            [ss setAccountDetailModel:accountModel];
            ss.vc=self;
            [self.navigationController pushViewController:ss animated:YES];
            
        }else
        {
            GXSignContractViewController * sing=[[GXSignContractViewController alloc]init];
            sing.exType=self.exType;
            [self.navigationController pushViewController:sing animated:YES];
        }
    }
    
    if(index==2)
    {
        GXLog(@"验证银行卡");
        if([accountModel.type isEqualToString:AccountTypeTianjin])
        {
            [MobClick event:@"uc_jgs_verification"];
        }
        if([accountModel.type isEqualToString:AccountTypeQilu])
        {
            [MobClick event:@"uc_qlsp_verification"];
        }

        GXAddCountSelectBankController *bank=[[GXAddCountSelectBankController alloc]init];
        NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
        params[@"customerName"]=accountModel.customerName;
        params[@"idNumber"]=accountModel.idNumber;
        params[@"type"]=accountModel.type;
        [GXUserdefult setObject:params forKey:AddCountParams];
        params=nil;
        [GXUserdefult setObject:ForTianjin forKey:AddCountFor];
        [self.navigationController pushViewController:bank animated:YES];
    }
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
