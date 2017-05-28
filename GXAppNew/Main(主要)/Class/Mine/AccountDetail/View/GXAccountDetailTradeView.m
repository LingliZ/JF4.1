//
//  GXAccountDetailTradeView.m
//  GXAppNew
//
//  Created by shenqilong on 16/12/26.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXAccountDetailTradeView.h"
#import "AccountDetailConst.h"
#import "GXPriceConst.h"

#import "GXAccountDetailModel.h"
#import "GXAccountBalanceModel.h"
#import "GXAccountOrderListModel.h"
#import "GXAccountTradeSymbol.h"
#import "PriceMarketModel.h"
@implementation GXAccountDetailTradeView
{
    GXAccountDetailModel *accountModel;
    
    UIView *pushSwitchV;//开关推送数据视图
    
    UIView *accountV;//账户金额视图

    UIView *listView;//持仓列表视图
    
    UIView *emptyView;//空值视图
    
    UIView *noLoadView;//关闭推送数据开关视图
    
    
    CGRect selfDefaultFrame;
    
    NSArray *TradesymbolAr;//code基本信息数组
    NSArray *ListOrderAr;//持仓列表数组
    NSMutableArray *ListCodeArray;//请求行情code数组

    NSURLSessionDataTask *dataTask;//请求任务;

    NSTimer *timer;
}

#define tag_lb_balance 1612260000
#define tag_lb_listValue 1612270000

#define accountDetailTradeSwitchIsOff @"accountDetailTradeSwitchIsOff" //1 off  0 on


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize delegate;
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        selfDefaultFrame=frame;
    }
    return self;
}
-(void)setModelUI:(GXAccountDetailModel *)aModel
{
    accountModel=aModel;
    
    if(!pushSwitchV)
    {
        pushSwitchV=[[UIView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 60)];
        pushSwitchV.backgroundColor=GXAccountDetailTradeView_color_pushSwitchViewBackg;
        [self addSubview:pushSwitchV];
        
        UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0, 59, GXScreenWidth, 1)];
        line.backgroundColor=GXAccountDetailTradeView_color_pushSwitchViewLine;
        [pushSwitchV addSubview:line];
        
        UILabel *lb_tit=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, GXScreenWidth-15-100, 60)];
        lb_tit.font=GXFONT_PingFangSC_Regular(12.5);
        lb_tit.textAlignment=NSTextAlignmentLeft;
        lb_tit.textColor=GXAccountDetailTradeView_color_pushSwitchViewText;
        lb_tit.text=@"交易数据由交易所推送，可能出现延迟或不完整。如您不希望推送，请关闭推送按钮";
        lb_tit.numberOfLines=0;
        lb_tit.lineBreakMode=NSLineBreakByWordWrapping;
        [pushSwitchV addSubview:lb_tit];

        
        UISwitch *pushSwitch=[[UISwitch alloc]initWithFrame:CGRectMake(GXScreenWidth-42-25, (60-25)/2.0, 42, 24)];
        [pushSwitch setOnTintColor:GXAccountDetailTradeView_color_pushSwitchViewSwitchBg];
        [pushSwitch setOn:YES];
        [pushSwitch addTarget:self action:@selector(pushSwitchClick:) forControlEvents:UIControlEventValueChanged];
        [pushSwitchV addSubview:pushSwitch];
        
        if([[GXUserdefult objectForKey:accountDetailTradeSwitchIsOff] intValue]==1)
        {
            [pushSwitch setOn:NO];
        }
    }
    
    if(!accountV)
    {
        accountV=[[UIView alloc]initWithFrame:CGRectMake(0, pushSwitchV.frame.origin.y+pushSwitchV.frame.size.height, GXScreenWidth, 65)];
        accountV.backgroundColor=GXAccountDetailTradeView_color_accountViewBackg;
        [self addSubview:accountV];
        
        float w=GXScreenWidth/3.0;
        
        NSArray *ar=@[@"当前权益",@"浮动盈亏",@"风险率"];
        for (int i=0; i<3; i++) {
            UILabel *lb_balance=[[UILabel alloc]initWithFrame:CGRectMake(w*i, 20, w, 20)];
            lb_balance.font=GXFONT_PingFangSC_Medium(18);
            lb_balance.textAlignment=NSTextAlignmentCenter;
            lb_balance.textColor=GXAccountDetailTradeView_color_accountViewText;
            lb_balance.text=@"--";
            [accountV addSubview:lb_balance];
            
            UILabel *lb_balanceTit=[[UILabel alloc]initWithFrame:CGRectMake(lb_balance.frame.origin.x, lb_balance.frame.origin.y+lb_balance.frame.size.height, w,20)];
            lb_balanceTit.font=GXFONT_PingFangSC_Regular(12);
            lb_balanceTit.textAlignment=NSTextAlignmentCenter;
            lb_balanceTit.textColor=GXAccountDetailTradeView_color_accountViewTextLittle;
            lb_balanceTit.text=ar[i];
            [accountV addSubview:lb_balanceTit];
            
            lb_balance.tag=tag_lb_balance+i;
        }
        
        UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(w,(accountV.frame.size.height-30)/2.0 , 1, 30)];
        line1.backgroundColor=GXAccountDetailTradeView_color_accountViewLine;
        [accountV addSubview:line1];
        
        UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(2*w,(accountV.frame.size.height-30)/2.0 , 1, 30)];
        line2.backgroundColor=GXAccountDetailTradeView_color_accountViewLine;
        [accountV addSubview:line2];
    }
    
    
    
    ListCodeArray=[[NSMutableArray alloc]init];
    
    
    if([[GXUserdefult objectForKey:accountDetailTradeSwitchIsOff] intValue]==1)
    {
        //初始化selfFrame
        self.frame=selfDefaultFrame;
        
        //建立不加载数据view
        [self setUI_NOLoadView];
        
        //去除loading视图
        [self.tableview.superview removeTipView];
    
        [self.tableview reloadData];
    }else
    {
        //加载上部数据接口
        [self loadAccountBalanceData];
        
        //加载code信息接口
        [self loadTradesymbol];
    }
}

- (void)pushSwitchClick:(id)sender
{
    UISwitch *s=sender;
    if(s.isOn)
    {
        [GXUserdefult setObject:@"0" forKey:accountDetailTradeSwitchIsOff];
        
        [self.tableview.superview showLoadingWithTitle:@"加载中"];
        
        
        [noLoadView removeFromSuperview];
        noLoadView=nil;
        
        
        //加载上部数据接口
        [self loadAccountBalanceData];
        
        //加载code信息接口
        [self loadTradesymbol];
        
    }else
    {
        [GXUserdefult setObject:@"1" forKey:accountDetailTradeSwitchIsOff];
        
        [self setTimerInvali];
        
        TradesymbolAr=nil;
        ListOrderAr=nil;
        [ListCodeArray removeAllObjects];
        
        UILabel *lb_balance=[self viewWithTag:tag_lb_balance+0];
        UILabel *lb_profit=[self viewWithTag:tag_lb_balance+1];
        UILabel *lb_risk=[self viewWithTag:tag_lb_balance+2];
        
        lb_balance.text=@"--";
        lb_profit.text=@"--";
        lb_risk.text=@"--";
        
        [emptyView removeFromSuperview];
        emptyView=nil;
        
        [listView removeFromSuperview];
        listView=nil;
        
        //初始化selfFrame
        self.frame=selfDefaultFrame;
        
        //建立不加载数据view
        [self setUI_NOLoadView];
        
        //去除loading视图
        [self.tableview.superview removeTipView];
    }
}

#pragma mark - loadApi
-(void)loadAccountBalanceData
{
    [GXHttpTool POST:@"/trade/get-money" parameters:@{@"accountNo":accountModel.account,@"exchange":accountModel.type} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            
            NSArray *ar=[GXAccountBalanceModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
            
            if([ar count]>0)
            {
                GXAccountBalanceModel *balanceModel=ar[0];
                
                UILabel *lb_balance=[self viewWithTag:tag_lb_balance+0];
                UILabel *lb_profit=[self viewWithTag:tag_lb_balance+1];
                UILabel *lb_risk=[self viewWithTag:tag_lb_balance+2];
                
                lb_balance.text=balanceModel.equities;
                lb_profit.text=balanceModel.holdPl;
                lb_risk.text=balanceModel.riskRate_lb;

            }
        }
        [self.tableview reloadData];
    } failure:^(NSError *error) {if(error.code!=-999){
        
        GXLog(@"加载失败");
    }
    }];
}

-(void)loadTradesymbol
{
    [GXHttpTool POST:@"/trade/get-symbols" parameters:nil success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            
            TradesymbolAr=[GXAccountTradeSymbol mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
            
            
            [self loadList];
        }
    } failure:^(NSError *error) {if(error.code!=-999){
    
        GXLog(@"加载失败");
    }
    }];
}

-(void)loadList
{
    [GXHttpTool POST:@"/trade/get-hold" parameters:@{@"accountNo":accountModel.account,@"exchange":accountModel.type} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            
            ListOrderAr=[GXAccountOrderListModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
            
            [emptyView removeFromSuperview];
            emptyView=nil;
            
            [listView removeFromSuperview];
            listView=nil;

            //初始化selfFrame
            self.frame=selfDefaultFrame;

            
            if([ListOrderAr count]>0)
            {
                [ListCodeArray removeAllObjects];
                
                
                //建立listUI
                [self setUI_ListView:ListOrderAr];
                
                
                //更新self的大小
                self.frame=CGRectMake(0, 0, GXScreenWidth, listView.frame.origin.y+listView.frame.size.height);
                
                
                //list更新赋值
                for (int i=0; i<[ListOrderAr count]; i++) {
                    
                    GXAccountOrderListModel*model=ListOrderAr[i];
                    
                    for (int j=0; j<7; j++) {
                        UILabel *lb=[self viewWithTag:tag_lb_listValue+j + 100000*i];
                        if(j==0)
                        {
                            if([accountModel.type isEqualToString:@"qiluce"])
                            {
                                for (GXAccountTradeSymbol *symbolModel in TradesymbolAr) {
                                    if([symbolModel.symbolName isEqualToString:model.symbolName])
                                    {
                                        lb.text=symbolModel.symbolName;
                                        
                                        //设置codeMOdel
                                        model.myCode=symbolModel.localname;
                                        
                                        //刷行情用
                                        [ListCodeArray addObject:symbolModel.localname];
                                        
                                        break;
                                    }
                                }
                            }else
                            {
                                for (GXAccountTradeSymbol *symbolModel in TradesymbolAr) {
                                    if([[symbolModel.symbolNo lowercaseString] isEqualToString:[model.symbolName lowercaseString]])
                                    {
                                        lb.text=symbolModel.symbolName;
                                        
                                        //设置codeMOdel
                                        model.myCode=symbolModel.localname;
                                        
                                        //刷行情用
                                        [ListCodeArray addObject:symbolModel.localname];
                                        
                                        break;
                                    }
                                }
                            }
                        }
                        else if (j==1)
                        {
                            lb.text=model.bsFlag_lb;
                        }
                        else if (j==2)
                        {
                            lb.text=model.quantity;
                        }
                        else if (j==3)
                        {
                            lb.text=@"--";
                        }
                        else if (j==4)
                        {
                            lb.text=model.holdPrice;
                        }
                        else if (j==5)
                        {
                            lb.text=model.openPrice;
                        }
                        else if (j==6)
                        {
                            lb.text=@"--";
                        }
                    }
                }
                
                
                [self.tableview reloadData];
                
                
                //去刷行情，计算盈亏
                [self timerloadPriceData];
                
            }else
            {
                //建立空值view
                [self setUI_emptyView];
            }
            
            [self.tableview.superview removeTipView];
        }
        
    } failure:^(NSError *error) {if(error.code!=-999){
        
        GXLog(@"加载失败");
    }
    }];
}

-(void)timerloadPriceData
{
    [self setTimerInvali];
    
    
    if(ListCodeArray.count>0)
    {
        [self loadPriceData];
        timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(loadPriceData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

-(void)loadPriceData
{
    GXLog(@"loadPriceData-----accountDetailTrade");
    if(dataTask)
    {
        return;
    }
    
    if([ListCodeArray count]==0)
    {
        return;
    }
    
    dataTask= [GXHttpTool POST:GXUrl_quotation parameters:@{@"code":[ListCodeArray componentsJoinedByString:@","]} success:^(id responseObject) {
        [self dataTaskSuccess:responseObject];
    } failure:^(NSError *error) {if(error.code!=-999){
        dataTask=nil;
    }
    }];
    
}

-(void)dataTaskSuccess:(id)responseObject
{
    if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
    {
        NSArray *ar=[PriceMarketModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
        
        //赋值浮动盈亏和回购
        //list更新赋值
        for (int i=0; i<[ListOrderAr count]; i++) {
            
            
            //持仓列表
            GXAccountOrderListModel*model=ListOrderAr[i];
            
            
            
            //行情报价
            PriceMarketModel *priceModel;
            for (PriceMarketModel *marketModel in ar) {
                if([[marketModel.code lowercaseString] isEqualToString:[model.myCode lowercaseString]])
                {
                    priceModel=marketModel;
                    break;
                }
            }
            if(!priceModel)
            {
                break;
            }
            
            
            //code信息
            GXAccountTradeSymbol *tradeModel;
            if([accountModel.type isEqualToString:@"qiluce"])
            {
                for (GXAccountTradeSymbol *symbolModel in TradesymbolAr) {
                    if([symbolModel.symbolName isEqualToString:model.symbolName ])
                    {
                        tradeModel=symbolModel;
                        break;
                    }
                }
            }else
            {
                for (GXAccountTradeSymbol *symbolModel in TradesymbolAr) {
                    if([[symbolModel.symbolNo lowercaseString] isEqualToString:[model.symbolName lowercaseString]])
                    {
                        tradeModel=symbolModel;
                        break;
                    }
                }
            }
            if(!tradeModel)
            {
                break;
            }
            
            
            
            //赋值 计算
            for (int j=0; j<7; j++) {
                UILabel *lb=[self viewWithTag:tag_lb_listValue+j + 100000*i];
                if (j==3)
                {
                    float profit;
#pragma mark - 盈亏计算
                    if([model.bsFlag intValue]==1)
                    {
                        profit=([priceModel.last floatValue] - [model.holdPrice floatValue])*[model.quantity floatValue]*tradeModel.factor;
                        
                    }else
                    {
                        profit=([model.holdPrice floatValue] - [priceModel.last floatValue])*[model.quantity floatValue]*tradeModel.factor;
                    }
                    
                    
                    lb.text=[NSString stringWithFormat:@"%.2f",profit];
                    if(profit>=0)
                    {
                        lb.textColor=priceList_color_tableViewCellPriceTextRed;
                    }else
                    {
                        lb.textColor=priceList_color_tableViewCellPriceTextGreen;
                    }
                }
                else if (j==6)
                {
                    if([model.bsFlag intValue]==1)
                    {
                        lb.text=priceModel.last;
                    }else
                    {
                        lb.text=model.holdPrice;
                    }
                }
            }
        }
        
    }
    
    dataTask=nil;
}

-(void) setTimerInvali
{
    DLog(@"取消定时器");
    if(timer)
    {
        [timer invalidate];
        timer=nil;
    }
}

#pragma mark - 设置UI
-(void)setUI_emptyView
{
    if(!emptyView)
    {
        emptyView=[[UIView alloc]init];
        emptyView.backgroundColor=[UIColor clearColor];
        
        
        UIImageView *emptyImg=[[UIImageView alloc]initWithFrame:CGRectMake((GXScreenWidth-60)/2.0, 0, 60, 60)];
        emptyImg.image=[UIImage imageNamed:GXAccountDetailTradeView_emptyImgName];
        [emptyView addSubview:emptyImg];
        
        UILabel *lb=[[UILabel alloc]initWithFrame:CGRectMake(0, emptyImg.frame.origin.y+emptyImg.frame.size.height+10, GXScreenWidth, 20)];
        lb.textAlignment=NSTextAlignmentCenter;
        lb.text=@"亲爱的客户，您当前没有正在进行的交易";
        lb.font=GXFONT_PingFangSC_Regular(12.5);
        lb.textColor=GXAccountDetailTradeView_color_emptyLbText;
        [emptyView addSubview:lb];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(35, lb.frame.origin.y+lb.frame.size.height+50, GXScreenWidth-70, 40)];
        btn.backgroundColor=GXAccountDetailTradeView_color_emptyBtnBackg;
        btn.titleLabel.font=GXFONT_PingFangSC_Medium(16);
        [btn setTitleColor:GXAccountDetailTradeView_color_emptyBtnText forState:UIControlStateNormal];
        [btn setTitle:@"去交易" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goTradeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius=6;
        [emptyView addSubview:btn];
        
        emptyView.frame=CGRectMake(0, 0, GXScreenWidth, btn.frame.origin.y+btn.frame.size.height);
        emptyView.center=CGPointMake(GXScreenWidth/2.0,(self.frame.size.height- accountV.frame.origin.y-accountV.frame.size.height)/2.0+accountV.frame.origin.y+accountV.frame.size.height);
        [self addSubview:emptyView];
    }
}

-(void)goTradeBtnClick
{
    GXLog(@"去交易");
    [delegate GXAccountDetailTradeView_goTradeBtnClick];
}

-(void)setUI_ListView:(NSArray *)ar
{
    if(!listView)
    {
        listView=[[UIView alloc]init];
        listView.backgroundColor=[UIColor clearColor];
        [self addSubview:listView];

        float height=0;
        
        for (int i=0; i<[ar count]; i++) {
            UIView *cellView=[[UIView alloc]initWithFrame:CGRectMake(15, 10+i*(120+10), GXScreenWidth-30, 120)];
            cellView.backgroundColor=GXAccountDetailTradeView_color_listViewBackg;
            cellView.layer.cornerRadius=6;
            cellView.layer.shadowColor=GXSingContractViewController_colorListViewBackgShadow.CGColor;
            cellView.layer.shadowOffset=CGSizeMake(2, 2);
            cellView.layer.shadowOpacity=1;
            [listView addSubview:cellView];
            
            
            height =cellView.frame.origin.y + cellView.frame.size.height+15;
            
            NSArray *titar=@[@"持牌：",@"方向：",@"持牌量：",@"盈亏：",@"持牌价：",@"摘牌价：",@"回购价："];
            for (int j=0; j<[titar count]; j++) {
                int x=j%2;
                int y=j/2;
                
                UILabel *lbTit=[[UILabel alloc]initWithFrame:CGRectMake(10+x*CGRectGetWidth(cellView.frame)/2.0, 15+y*(20+6), 60, 20)];
                lbTit.textAlignment=NSTextAlignmentLeft;
                lbTit.text=titar[j];
                lbTit.font=GXFONT_PingFangSC_Regular(14);
                lbTit.textColor=GXAccountDetailTradeView_color_listViewTitleText;
                [cellView addSubview:lbTit];
                
                
                UILabel *lbV=[[UILabel alloc]initWithFrame:CGRectMake(lbTit.frame.origin.x+lbTit.frame.size.width, lbTit.frame.origin.y, CGRectGetWidth(cellView.frame)/2.0-10-lbTit.frame.size.width, 20)];
                lbV.textAlignment=NSTextAlignmentLeft;
                lbV.text=@"--";
                lbV.font=GXFONT_PingFangSC_Medium(16);
                lbV.textColor=GXAccountDetailTradeView_color_listViewTitleText;
                lbV.backgroundColor=[UIColor clearColor];
                lbV.adjustsFontSizeToFitWidth=YES;
                [cellView addSubview:lbV];

                
                lbV.tag=tag_lb_listValue+j + 100000*i;
            }
        }
        
        listView.frame=CGRectMake(0, accountV.frame.origin.y+accountV.frame.size.height, GXScreenWidth, height);
    }
}

-(void)setUI_NOLoadView
{
    if(!noLoadView)
    {
        noLoadView=[[UIView alloc]init];
        noLoadView.backgroundColor=[UIColor clearColor];
        
        
        UILabel *lb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 20)];
        lb.textAlignment=NSTextAlignmentCenter;
        lb.text=@"打开交易所数据推送开关后显示您的交易数据";
        lb.font=GXFONT_PingFangSC_Regular(12.5);
        lb.textColor=GXAccountDetailTradeView_color_emptyLbText;
        [noLoadView addSubview:lb];
        
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(35, lb.frame.origin.y+lb.frame.size.height+80, GXScreenWidth-70, 40)];
        btn.backgroundColor=GXAccountDetailTradeView_color_emptyBtnBackg;
        btn.titleLabel.font=GXFONT_PingFangSC_Medium(16);
        [btn setTitleColor:GXAccountDetailTradeView_color_emptyBtnText forState:UIControlStateNormal];
        [btn setTitle:@"去交易" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(goTradeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius=6;
        [noLoadView addSubview:btn];
        
        noLoadView.frame=CGRectMake(0, 0, GXScreenWidth, btn.frame.origin.y+btn.frame.size.height);
        noLoadView.center=CGPointMake(GXScreenWidth/2.0,(self.frame.size.height- accountV.frame.origin.y-accountV.frame.size.height)/2.0+accountV.frame.origin.y+accountV.frame.size.height);
        [self addSubview:noLoadView];

    }
}

@end
