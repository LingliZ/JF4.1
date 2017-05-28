//
//  GXSignContractViewController.m
//  GXAppNew
//
//  Created by shenqilong on 16/12/26.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXSignContractViewController.h"
#import "AccountDetailConst.h"
#import "GXAccountDetailModel.h"
#import <YYText/YYText.h>

#import "ChatViewController.h"
#import "GXAccountDetailWebViewController.h"

@interface GXSignContractViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *listmenu;
    
    UIView *headView;
    UIView *listV1;
    UIView *listV2;
    UIView *footView;
    
    GXAccountDetailModel *accountModel;
}
@end

@implementation GXSignContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"激活账户";
    
    self.view.backgroundColor=GXSingContractViewController_color_selfBackg;
    
    
    listmenu=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64) style:UITableViewStylePlain];
    listmenu.dataSource=self;
    listmenu.delegate=self;
    listmenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    listmenu.backgroundColor=[UIColor clearColor];
    [self.view addSubview:listmenu];
    
    
    listmenu.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    listmenu.mj_header.automaticallyChangeAlpha = YES;
    
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:GXAccountDetail_serviceImageName] style:0 target:self action:@selector(rightBtn)];
    
    self.navigationItem.rightBarButtonItem=right;
}

-(void)rightBtn
{
    //在线客服
    ChatViewController *onlineVC = [[ChatViewController alloc] initWithChatter:EaseMobCusterKey type:eAfterSaleType];
    [self.navigationController pushViewController:onlineVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view showLoadingWithTitle:@"加载中"];
    [self headerRefreshing];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view removeTipView];
    
    if([listmenu.mj_header isRefreshing])
        [listmenu.mj_header endRefreshing];

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
            
            
            
            //创建头视图
            [self initHeadView];
            
            //创建list
            [self initListView];
            
            //创建脚视图
            [self initFootView];
            
            
            UILabel *lb1=[listV1 subviews][1];
            UILabel *lb2=[listV2 subviews][1];
            
            lb1.text=@"未完成";
            if([accountModel.accountStatus isEqualToString:@"已签约"])
            {
                lb1.text=@"已完成";
            }
            
            lb2.text=@"未完成";
           
            [listmenu reloadData];
            
           
        }
        
        [self.view removeTipView];
        if([listmenu.mj_header isRefreshing])
            [listmenu.mj_header endRefreshing];

        
    } failure:^(NSError *error) {if(error.code!=-999){
        
        [self.view removeTipView];
        if([listmenu.mj_header isRefreshing])
            [listmenu.mj_header endRefreshing];

    }
    }];
    
}

#pragma mark - setUI
-(void)initHeadView
{
    if(!headView)
    {
        headView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 30)];
        UILabel *lb=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 300, 30)];
        lb.text=@"完成以下2步操作，可以成功激活账户：";
        lb.font=GXFONT_PingFangSC_Regular(14);
        lb.textColor=GXSingContractViewController_color_headText;
        [headView addSubview:lb];
    }
}

-(void)initListView
{
    if(!listV1)
    {
        listV1=[[UIView alloc]init];
        listV1.backgroundColor=GXSingContractViewController_colorListViewBackg;
        listV1.layer.cornerRadius=6;
        listV1.layer.shadowColor=GXSingContractViewController_colorListViewBackgShadow.CGColor;
        
        listV1.layer.shadowRadius=3;
        listV1.layer.shadowOffset=CGSizeMake(2, 2);
        listV1.layer.shadowOpacity=1;
        
        
        float maxWidth=GXScreenWidth-30;
        
        
        UILabel *imgTit=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, maxWidth, 16)];
        imgTit.text=@"银行签约";
        imgTit.textAlignment=NSTextAlignmentCenter;
        imgTit.font=GXFONT_PingFangSC_Regular(11);
        imgTit.textColor=GXSingContractViewController_colorListViewImgTopLabelText;
        [listV1 addSubview:imgTit];
        
        UILabel *lb_isDone=[[UILabel alloc]initWithFrame:CGRectMake(maxWidth-46-10, 15, 46, 16)];
        lb_isDone.textAlignment=NSTextAlignmentCenter;
        lb_isDone.font=GXFONT_PingFangSC_Regular(11);
        lb_isDone.textColor=GXSingContractViewController_colorDoneButtonText;
        lb_isDone.layer.borderColor=GXSingContractViewController_colorDoneButtonText.CGColor;
        lb_isDone.layer.borderWidth=1;
        lb_isDone.layer.masksToBounds=YES;
        lb_isDone.layer.cornerRadius=8;
        [listV1 addSubview:lb_isDone];
        
        
        UIButton *backimg=[[UIButton alloc]initWithFrame:CGRectMake(0, 30, maxWidth, 80)];
        [backimg setImage:[UIImage imageNamed:GXSingContractViewController_mainImgName1] forState:UIControlStateNormal];
        backimg.enabled=NO;
        [listV1 addSubview:backimg];
        
        
        UIButton *tanhaoimg=[[UIButton alloc]initWithFrame:CGRectMake(0, backimg.frame.origin.y+backimg.frame.size.height +10, 18, 16)];
        [tanhaoimg setImage:[UIImage imageNamed:GXSingContractViewController_tanhaoImgName] forState:UIControlStateNormal];
        [listV1 addSubview:tanhaoimg];
        
        
        
        NSMutableAttributedString *str_tipText=[[NSMutableAttributedString alloc]initWithString:@"可通过网上银行或线下柜台进行签约，签约成功后即可交易。查看网银签约指南"];
        str_tipText.yy_font = GXFONT_PingFangSC_Regular(12);
        str_tipText.yy_color = GXSingContractViewController_colorListViewText;
        str_tipText.yy_lineSpacing = 3;
        [str_tipText yy_setColor:GXSingContractViewController_colorListViewTextHighLight range:NSMakeRange(str_tipText.string.length-8, 8)];
        [str_tipText yy_setTextHighlightRange:NSMakeRange(str_tipText.string.length-8, 8)
                                 color:nil
                       backgroundColor:nil
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 if([accountModel.type isEqualToString:AccountTypeQilu])
                                 {
                                     [MobClick event:@"uc_qlsp_sign_contract"];
                                 }
                                 if([accountModel.type isEqualToString:AccountTypeTianjin])
                                 {
                                     [MobClick event:@"uc_jgs_sign_contract"];
                                 }
                                 GXAccountDetailWebViewController*detailVC=[[GXAccountDetailWebViewController alloc]init];
                                 detailVC.articleID=accountModel.signHelpId;
                                 detailVC.title=@"网银签约指南";
                                 [self.navigationController pushViewController:detailVC animated:YES];
                             }];
        
        CGSize size = CGSizeMake(maxWidth-20-10, CGFLOAT_MAX);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:str_tipText];

        YYLabel *lbTip=[[YYLabel alloc]initWithFrame:CGRectMake(20,tanhaoimg.frame.origin.y, layout.textBoundingSize.width, layout.textBoundingSize.height)];
        lbTip.textAlignment=NSTextAlignmentLeft;
        lbTip.attributedText=str_tipText;
        lbTip.lineBreakMode = NSLineBreakByWordWrapping;
        lbTip.numberOfLines = 0;
        [listV1 addSubview:lbTip];
        
        
        listV1.frame=CGRectMake(15, 0, maxWidth,lbTip.frame.origin.y+lbTip.frame.size.height+20);
    }
    
    
    if(!listV2)
    {
        listV2=[[UIView alloc]init];
        listV2.backgroundColor=GXSingContractViewController_colorListViewBackg;
        listV2.layer.cornerRadius=6;
        listV2.layer.shadowColor=GXSingContractViewController_colorListViewBackgShadow.CGColor;
        
        listV2.layer.shadowRadius=3;
        listV2.layer.shadowOffset=CGSizeMake(2, 2);
        listV2.layer.shadowOpacity=1;
        
        
        float maxWidth=GXScreenWidth-30;

        
        UILabel *imgTit=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, maxWidth, 16)];
        imgTit.text=@"入金激活";
        imgTit.textAlignment=NSTextAlignmentCenter;
        imgTit.font=GXFONT_PingFangSC_Regular(11);
        imgTit.textColor=GXSingContractViewController_colorListViewImgTopLabelText;
        [listV2 addSubview:imgTit];
        
        UILabel *lb_isDone=[[UILabel alloc]initWithFrame:CGRectMake(maxWidth-46-10, 15, 46, 16)];
        lb_isDone.textAlignment=NSTextAlignmentCenter;
        lb_isDone.font=GXFONT_PingFangSC_Regular(11);
        lb_isDone.textColor=GXSingContractViewController_colorDoneButtonText;
        lb_isDone.layer.borderColor=GXSingContractViewController_colorDoneButtonText.CGColor;
        lb_isDone.layer.borderWidth=1;
        lb_isDone.layer.masksToBounds=YES;
        lb_isDone.layer.cornerRadius=8;
        [listV2 addSubview:lb_isDone];
        
        
        UIButton *backimg=[[UIButton alloc]initWithFrame:CGRectMake(0, 30, maxWidth, 80)];
        [backimg setImage:[UIImage imageNamed:GXSingContractViewController_mainImgName2] forState:UIControlStateNormal];
        backimg.enabled=NO;
        [listV2 addSubview:backimg];
        
        
        UIButton *tanhaoimg=[[UIButton alloc]initWithFrame:CGRectMake(0, backimg.frame.origin.y+backimg.frame.size.height+10 , 18, 16)];
        [tanhaoimg setImage:[UIImage imageNamed:GXSingContractViewController_tanhaoImgName] forState:UIControlStateNormal];
        [listV2 addSubview:tanhaoimg];
        
        
        
        NSMutableAttributedString *str_tipText=[[NSMutableAttributedString alloc]initWithString:@"可通过交易所的交易系统（PC或者App）、网上银行或线下柜台入金激活，天津交易所激活条件为入金50万人民币。查看入金操作指南"];
        str_tipText.yy_font = GXFONT_PingFangSC_Regular(12);
        str_tipText.yy_color = GXSingContractViewController_colorListViewText;
        str_tipText.yy_lineSpacing = 3;
        [str_tipText yy_setColor:GXSingContractViewController_colorListViewTextHighLight range:NSMakeRange(str_tipText.string.length-8, 8)];
        [str_tipText yy_setTextHighlightRange:NSMakeRange(str_tipText.string.length-8, 8)
                                        color:nil
                              backgroundColor:nil
                                    tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                       
                                        GXAccountDetailWebViewController*detailVC=[[GXAccountDetailWebViewController alloc]init];
                                        detailVC.articleID=accountModel.depositHelpId;
                                        detailVC.title=@"入金操作指南";
                                        [self.navigationController pushViewController:detailVC animated:YES];
                                        
                                        
                                        
                                    }];
        
        CGSize size = CGSizeMake(maxWidth-20-10, CGFLOAT_MAX);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:str_tipText];
        
        YYLabel *lbTip=[[YYLabel alloc]initWithFrame:CGRectMake(20, tanhaoimg.frame.origin.y, layout.textBoundingSize.width, layout.textBoundingSize.height)];
        lbTip.textAlignment=NSTextAlignmentLeft;
        lbTip.attributedText=str_tipText;
        lbTip.lineBreakMode = NSLineBreakByWordWrapping;
        lbTip.numberOfLines = 0;
        [listV2 addSubview:lbTip];
        

        listV2.frame=CGRectMake(15, 0, maxWidth,lbTip.frame.origin.y+lbTip.frame.size.height+20);
    }

}

-(void)initFootView
{
    if(!footView)
    {
        footView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 50)];
        
        NSMutableAttributedString *text=[[NSMutableAttributedString alloc]initWithString:@"银行签约或入金激活如有问题请联系客服"];
        text.yy_font = GXFONT_PingFangSC_Regular(12);
        text.yy_color = GXSingContractViewController_color_footText;
        text.yy_lineSpacing = 1;
        [text yy_setColor:GXSingContractViewController_color_footTextHighLight range:NSMakeRange(text.string.length-4, 4)];
        [text yy_setTextHighlightRange:NSMakeRange(text.string.length-4, 4)
                                 color:nil
                       backgroundColor:nil
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 GXLog(@"联系客服");
                                 [MobClick event:@"uc_service_tel"];
                                 [UIButton callPhoneWithPhoneNum:GXPhoneNum atView:self.view];
                                 
                             }];
        
        
        YYLabel *lb=[[YYLabel alloc]initWithFrame:CGRectMake(0, 30, GXScreenWidth, 20)];
        lb.attributedText=text;
        lb.textAlignment=NSTextAlignmentCenter;
        [footView addSubview:lb];
        
        listmenu.tableFooterView=footView;
    }
}


#pragma mark - tavleView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if(indexPath.row==0)
    [cell addSubview:listV1];
    
    if(indexPath.row==1)
    [cell addSubview:listV2];
    
    
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    return listV1.frame.size.height+10;
    
    return listV2.frame.size.height+10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headView.frame.size.height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return headView;
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
