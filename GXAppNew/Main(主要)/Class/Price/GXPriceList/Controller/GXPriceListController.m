//
//  GXPriceListController.m
//  GXAppNew
//
//  Created by futang yang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXPriceListController.h"
#import "GXPriceDetailController.h"

#import "PricePlatformModel.h"
#import "PriceProductModel.h"
#import "PriceMarketModel.h"

#import "GXPriceListTableView.h"
#import "GXPriceListTableViewCell.h"

#import "GXPriceListSelectExView.h"

#import "GXPriceListAddCodeViewController.h"
#import "GXPriceListEditViewController.h"
#import "GXNavigationController.h"
#import "GXFileTool.h"

#import "GXNoviceTutorialController.h"

@interface GXPriceListController () <UITableViewDataSource, UITableViewDelegate>
{
    GXPriceListTableView *listmenu;
    NSURLSessionDataTask *dataTask;//请求任务;
    NSTimer *timer;
    NSArray *PricePlatformArray;//交易所列表
    NSArray *ListCodeArray;//选中的交易所code列表
    NSArray *ListPriceArray;//行情数据
    
    UIButton *addCodeImgBtn;//没有自选时添加自选按钮
    UIButton *selectEXBtn;//nav标题按钮
    
    NSInteger SelectViewIndex;
    GXPriceListSelectExView *selectExView;
    
    
    UIButton *navBtnLeft;
    UIButton *navBtnRight;
}

@end

@implementation GXPriceListController

#pragma mark - lifeCircle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self renderUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(priceListCellScrollTag:) name:@"priceListCellScrollTag" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editCodeDone) name:GXNotify_LoginSuccess object:nil];
    

    
    
    PricePlatformArray=[GXFileTool readObjectByFileName:PricePlatformKey];
}

-(void)viewWillAppear:(BOOL)animated
{
    //建立nav按钮
    [self initSelectEXBtn];
    //更新navbtn
    [self setSelectEXbtnTitleAndImg];
    
    
    //加载行情
    [self timerloadPriceData];
    
    
    [self makeFunctionGuide];
    
    
   
}

-(void)viewWillDisappear:(BOOL)animated
{
    [selectEXBtn removeFromSuperview];
    selectEXBtn=nil;
    
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    
    if(dataTask)
    {
        [dataTask cancel];
        dataTask=nil;
    }
    
    if([listmenu.mj_header isRefreshing])
        [listmenu.mj_header endRefreshing];
    
    
    [navBtnLeft removeFromSuperview];
    navBtnLeft =nil;
    
    
    [navBtnRight removeFromSuperview];
    navBtnRight =nil;
}

- (void)makeFunctionGuide{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *firstComeInTeacherDetail = @"isFirstEnter_priceList";
    
    if (![user boolForKey:firstComeInTeacherDetail])
    {
        [user setBool:YES forKey:firstComeInTeacherDetail];
        [user synchronize];
        [self makeGuideView];
    }
}
- (void)makeGuideView{
    GXNoviceTutorialController *vc = [[GXNoviceTutorialController alloc]init];
    vc.styles = @[@"GuideViewCleanModeCycleRect",@"GuideViewCleanModeRoundRect"];
    vc.btnFrames = @[NSStringFromCGRect(CGRectMake(WidthScale_IOS6(330), 20, 36, 36)),
                     NSStringFromCGRect(CGRectMake(0, 104, 375, 250))
                     ];
    vc.imgFrames = @[NSStringFromCGRect(CGRectMake(-5, 5, 375, WidthScale_IOS6(152))),
                     NSStringFromCGRect(CGRectMake(0, 290,375, WidthScale_IOS6(91)))
                     ];
    vc.images = @[@"newbie_guide_pic7",
                  @"newbie_guide_pic8",
                  ];
    [self presentViewController:vc animated:YES completion:nil];
}

-(void)BarButtonItem_addCode
{
    GXLog(@"add");
    
    [MobClick event:@"market_classify"];
    
    if(!selectExView.hidden)
    {
        [selectExView setSelectExViewShow];
    }
    
    
    GXPriceListAddCodeViewController *add=[[GXPriceListAddCodeViewController alloc]init];
    add.delegate=(id)self;
//    [self.navigationController pushViewController:add animated:YES];

    
    GXNavigationController *nav=[[GXNavigationController alloc]initWithRootViewController:add];
    [self presentViewController:nav animated:YES completion:^{}];
}
-(void)BarButtonItem_edit
{
    GXLog(@"edit");
    
    //埋点
    [MobClick event:@"edit_self_service"];
    

    
    if(!selectExView.hidden)
    {
        [selectExView setSelectExViewShow];
    }
    
    
    GXPriceListEditViewController *edit=[[GXPriceListEditViewController alloc]init];
    edit.delegate=(id)self;
//    [self.navigationController pushViewController:edit animated:YES];
    
    GXNavigationController *nav=[[GXNavigationController alloc]initWithRootViewController:edit];
    [self presentViewController:nav animated:YES completion:^{}];
    
    
    
}

#pragma mark - render UI
- (void)renderUI {
    
    listmenu=[[GXPriceListTableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64-49) style:UITableViewStylePlain];
    [listmenu addLeftTitle:@"交易品种" width:@"125"];
    [listmenu addRightTitleAndTitleWidth:@"最新价",@"100",@"涨跌幅",@"100",@"涨跌额",@"100",@"最高价",@"100",@"最低价",@"100",@"今开价",@"100",nil];
    listmenu.dataSource=self;
    listmenu.delegate=self;
    listmenu.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    listmenu.backgroundColor=priceList_color_tableViewBackg;
    listmenu.separatorColor=priceList_color_SelectExchangeViewBackgLine;
    [self.view addSubview:listmenu];
    
    
    UILabel *tiplb=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, 50)];
    tiplb.text=@"行情信息2秒钟刷新一次，下拉可手动刷新\n实时行情数据以交易所的交易软件为准";
    tiplb.textAlignment=NSTextAlignmentCenter;
    tiplb.textColor=priceList_color_tableViewFootViewText;
    tiplb.font=GXFONT_PingFangSC_Regular(12);
    tiplb.hidden=YES;
    tiplb.numberOfLines=2;
    listmenu.tableFooterView=tiplb;
    
    
    MJRefreshNormalHeader*header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    
    header.stateLabel.textColor=priceList_color_tableViewFootViewText;
    header.lastUpdatedTimeLabel.textColor=priceList_color_tableViewFootViewText;
    header.loadingView.color=priceList_color_tableViewFootViewText;
    listmenu.mj_header=header;
    listmenu.mj_header.automaticallyChangeAlpha = YES;
    [listmenu.mj_header beginRefreshing];
    
    
}

//建立没自选时出现的大加号
-(void)initAddCodeImgBtn
{
    addCodeImgBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 160, 160)];
    [addCodeImgBtn setImage:[UIImage imageNamed:@"priceListOptional"] forState:UIControlStateNormal];
    [addCodeImgBtn setTitle:@"暂无交易品种，点击添加" forState:UIControlStateNormal];
    addCodeImgBtn.titleLabel.font=GXFONT_PingFangSC_Regular(12);
    [addCodeImgBtn setTitleColor:priceList_color_addCodeImgTipsText forState:UIControlStateNormal];
    [addCodeImgBtn setImagePosition:2 spacing:10];
    addCodeImgBtn.center=CGPointMake(CGRectGetWidth(listmenu.frame)/2.0, CGRectGetHeight(listmenu.frame)/2.0);
    [addCodeImgBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    addCodeImgBtn.backgroundColor=[UIColor clearColor];
    [listmenu addSubview:addCodeImgBtn];
}
-(void)addBtnClick
{
    GXLog(@"添加自选");
    [self BarButtonItem_addCode];
}


//建立nav上的选择按钮
-(void)initSelectEXBtn
{
    selectEXBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 20, 120, 44)];
    selectEXBtn.titleLabel.font=GXFONT_PingFangSC_Regular(17);
    [selectEXBtn setTitleColor:priceList_color_NavTitleText forState:UIControlStateNormal];
    selectEXBtn.center=CGPointMake(GXScreenWidth/2.0, 22);
    [selectEXBtn addTarget:self action:@selector(selectEXBtnClick) forControlEvents:UIControlEventTouchUpInside];
    selectEXBtn.backgroundColor=[UIColor clearColor];
    [self.navigationController.navigationBar addSubview:selectEXBtn];

}
-(void)setSelectEXbtnTitleAndImg
{
    if([PricePlatformArray count]==0)
    {
        selectEXBtn.enabled=NO;
        [selectEXBtn setTitle:@"自选" forState:UIControlStateNormal];
        [selectEXBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

    }else
    {
        selectEXBtn.enabled=YES;
        [selectEXBtn setTitle:@"自选" forState:UIControlStateNormal];
        [selectEXBtn setTitleColor:priceList_color_NavTitleText forState:UIControlStateNormal];
        if(SelectViewIndex>0)
        {
            PricePlatformModel *model = PricePlatformArray[SelectViewIndex-1];
            [selectEXBtn setTitle:model.exname forState:UIControlStateNormal];
        }
    }
    
    [selectEXBtn setImage:[UIImage imageNamed:priceList_imgname_NavTitleImg] forState:UIControlStateNormal];
    [selectEXBtn setImagePosition:1 spacing:0];
    
    
    
    
    [navBtnLeft removeFromSuperview];
    navBtnLeft =nil;
    
    
    [navBtnRight removeFromSuperview];
    navBtnRight =nil;


    //控制显示navbaritem
    if(SelectViewIndex==0)
    {
        
        navBtnLeft=[[UIButton alloc]initWithFrame:CGRectMake(15, 0, 70, 44)];
        [navBtnLeft setTitle:@"编辑" forState:UIControlStateNormal];
        [navBtnLeft setTitleColor:RGBACOLOR(68, 133, 241, 1) forState:UIControlStateNormal];
        navBtnLeft.titleLabel.font=GXFONT_PingFangSC_Regular(14);
        [navBtnLeft addTarget:self action:@selector(BarButtonItem_edit) forControlEvents:UIControlEventTouchUpInside];
        [navBtnLeft setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [self.navigationController.navigationBar addSubview:navBtnLeft];
        
        
        navBtnRight=[[UIButton alloc]initWithFrame:CGRectMake(GXScreenWidth-70-15, 0, 70, 44)];
        [navBtnRight setImage:[UIImage imageNamed:priceList_imgname_NavBarButtonImg_addCode_blue] forState:UIControlStateNormal];
        [navBtnRight addTarget:self action:@selector(BarButtonItem_addCode) forControlEvents:UIControlEventTouchUpInside];
        [navBtnRight setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.navigationController.navigationBar addSubview:navBtnRight];
        
    }
    
    
    
}
-(void)selectEXBtnClick
{
    [selectExView setSelectExViewShow];
}


#pragma mark - privateMethod
-(void)headerRefreshing
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
    
    if(dataTask)
    {
        [dataTask cancel];
        dataTask=nil;
    }
    
    if(addCodeImgBtn)
    {
        [addCodeImgBtn removeFromSuperview];
        addCodeImgBtn=nil;
    }
    
    
    //获取交易所列表
    [self loadMarkInfo];
}

- (void)loadMarkInfo {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platform"] = @"ios";
    
    [GXHttpTool POST:GXUrl_marketInfo parameters:param  success:^(id responseObject) {
        
        if ([responseObject[GXSuccess] integerValue] == 1) {
            
            PricePlatformArray = [PricePlatformModel mj_objectArrayWithKeyValuesArray:responseObject[GXValue]];
            
            [self getListCode];
            
        }else
        {
            if([listmenu.mj_header isRefreshing])
                [listmenu.mj_header endRefreshing];
            
            [self showErrorNetMsg:@"服务器连接错误" withView:listmenu];
        }
        
    } failure:^(NSError *error) {
        if([listmenu.mj_header isRefreshing])
            [listmenu.mj_header endRefreshing];
        
        [self showErrorNetMsg:nil withView:listmenu];

    }];
}

-(void)getListCode
{
    //初始化交易所选择视图
    if(!selectExView)
    {
        selectExView=[[GXPriceListSelectExView alloc]initWithEXAr:PricePlatformArray];
        selectExView.delegate=(id)self;
        [self.view.window addSubview:selectExView];
    }
    
    
    //更新navbtn
    [self setSelectEXbtnTitleAndImg];
    
    
    
    //获取ListCodeArray
    if(SelectViewIndex==0)
    {
        [self loadZiXuanInfo];
        
    }else
    {
        PricePlatformModel *model = PricePlatformArray[SelectViewIndex-1];
        
        NSMutableArray *codear=[[NSMutableArray alloc]init];
        NSArray *listAr = model.tradeInfoList;
        for (int i=0; i<[listAr count]; i++) {
            PriceProductModel *productModel=listAr[i];
            [codear addObject:productModel.code];
        }
        ListCodeArray=codear;
        codear=nil;
        
        if([ListCodeArray count]==0)
        {
            if([listmenu.mj_header isRefreshing])
                [listmenu.mj_header endRefreshing];
        }
        
        //加载行情
        [self timerloadPriceData];
    }
    
}

-(void)loadZiXuanInfo
{
    navBtnLeft.enabled=NO;
    navBtnRight.enabled=NO;

    
    [GXHttpTool POST:GXUrl_fetchPrice parameters:nil  success:^(id responseObject) {
    
        navBtnLeft.enabled=YES;
        navBtnRight.enabled=YES;

        
        if ([responseObject[GXSuccess] integerValue] == 1) {
            
            NSArray *ar = [PriceProductModel mj_objectArrayWithKeyValuesArray:responseObject[GXValue]];
            NSMutableArray *codear=[[NSMutableArray alloc]init];
            for (int i=0; i<[ar count]; i++) {
                PriceProductModel *model=ar[i];
                [codear addObject:model.code];
            }
            ListCodeArray=codear;
            codear=nil;
        }else
        {
            ListCodeArray = [GXUserdefult objectForKey:PersonSelectCodesKey];
        }
        
        if(ListCodeArray.count==0)
        {
            
            [GXUserdefult setObject:@[] forKey:PersonSelectCodesKey];
            [GXUserdefult synchronize];
            
            ListPriceArray = nil;
            
            [listmenu reloadData];
            
            //建立加自选按钮大加号
            [self initAddCodeImgBtn];
            
            if([listmenu.mj_header isRefreshing])
                [listmenu.mj_header endRefreshing];
            
            listmenu.tableFooterView.hidden=YES;
            return ;
        }
        
        
        [GXUserdefult setObject:ListCodeArray forKey:PersonSelectCodesKey];
        [GXUserdefult synchronize];
        
        
        //加载行情
        [self timerloadPriceData];
        
        
        
    } failure:^(NSError *error) {
        
        navBtnLeft.enabled=YES;
        navBtnRight.enabled=YES;

        
        ListCodeArray = [GXUserdefult objectForKey:PersonSelectCodesKey];
        
        if(ListCodeArray.count==0)
        {
            ListPriceArray = nil;
            
            [listmenu reloadData];
            
            //建立加自选按钮大加号
            [self initAddCodeImgBtn];
            
            if([listmenu.mj_header isRefreshing])
                [listmenu.mj_header endRefreshing];
            
            return ;
        }
        
        //加载行情
        [self timerloadPriceData];
    }];
}

-(void)timerloadPriceData
{
    if(timer)
    {
        [timer invalidate];
        timer=nil;
    }

    if(ListCodeArray.count>0)
    {
        [self loadPriceData];
        timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(loadPriceData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
}

-(void)loadPriceData
{

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
        [self dataTaskError];
    }
    }];
    
}
-(void)dataTaskError
{
    if([ListPriceArray count]==0)
    {
        if(timer)
        {
            [timer invalidate];
            timer = nil;
        }
    }
    
    dataTask=nil;
    
    if([listmenu.mj_header isRefreshing])
        [listmenu.mj_header endRefreshing];
    
}

-(void)dataTaskSuccess:(id)responseObject
{
    if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
    {
        
        NSArray *ar=[PriceMarketModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
        
        //与上次比最近价颜色
        [self arrayCompare:ar];
                     
        if(ListPriceArray)
        {
            ListPriceArray=nil;
        }
        ListPriceArray=ar;
        ar=nil;
        
        [listmenu reloadData];
        
        listmenu.tableFooterView.hidden=NO;
    }
    
    dataTask=nil;
    
    if([listmenu.mj_header isRefreshing])
        [listmenu.mj_header endRefreshing];
}

-(void)arrayCompare:(NSArray *)ar
{
    for (int i=0; i<[ListPriceArray count]; i++) {
        
        PriceMarketModel *model1=ListPriceArray[i];
        
        for (int j=0; j<[ar count]; j++) {
            
            PriceMarketModel *model2=ar[j];

            if([model1.code isEqualToString:model2.code])
            {
                if([model2.last floatValue] > [model1.last floatValue])
                {
                    model2.lastBackgColor=priceList_color_tableViewCellLastBackgRed;
                }else if ([model2.last floatValue] < [model1.last floatValue])
                {
                    model2.lastBackgColor=priceList_color_tableViewCellLastBackgGreen;
                }else
                {
                    model2.lastBackgColor=[UIColor clearColor];
                }
                
                break;
            }
        }
    }
}


#pragma mark - addCodeViewControllerDelegate

-(void)addCodeDone
{
    [listmenu.mj_header beginRefreshing];
    
}

#pragma mark - GXPriceListEditViewControllerDelegate

-(void)editCodeDone
{
    [listmenu.mj_header beginRefreshing];
    
}
#pragma mark - GXPriceDetailControllerDelegate

-(void)priceDetail_addCodeDone
{
    if(SelectViewIndex==0)
    [listmenu.mj_header beginRefreshing];
}
#pragma mark - tavleView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ListPriceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GXPriceListTableViewCell *cell = [GXPriceListTableViewCell cellWithTableView:listmenu IndexPath:indexPath];
    
    cell.marketModel=ListPriceArray[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return priceList_height_tableviewCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return listmenu.titleView.bounds.size.height;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([[tableView visibleCells]count]>0)
    {   
        UIScrollView *titleScroll=[listmenu.titleView subviews][0];
        [titleScroll setContentOffset:listmenu.titViewScorllp];
    }
    
    return listmenu.titleView;
}

-(void)priceListCellScrollTag:(NSNotification *)obj
{
    GXLog(@"%@",obj.object);
    
    //改传此model
    PriceMarketModel *model = ListPriceArray[[obj.object integerValue]];

    
    //遍历点击code属于哪个交易所
    for (PricePlatformModel *PlatformModel in PricePlatformArray) {
        if([[PlatformModel.excode lowercaseString] isEqualToString:[model.excode lowercaseString]])
        {
            //遍历找到detail
            NSArray *listAr = PlatformModel.tradeInfoList;
            for (PriceProductModel *productModel in listAr) {
                if([[productModel.code lowercaseString]isEqualToString:[model.code lowercaseString]])
                {
                    
                    
                    model.tradeDetail=productModel.tradeDetail;
                    break;
                }
            }
            break;
        }
    }
    
    
    
    GXPriceDetailController *priceDetailVC = [[GXPriceDetailController alloc] init];
    priceDetailVC.marketModel = model;
    priceDetailVC.delegate=(id)self;
    [self.navigationController pushViewController:priceDetailVC animated:YES];
}

#pragma mark - GXPriceListSelectExViewDelegate
-(void)selectBtnCLickIndex:(NSInteger)index
{
    GXLog(@"%ld",index);
    [listmenu.mj_header beginRefreshing];
    
    SelectViewIndex=index;
    
    //清空tableview
    ListCodeArray=nil;
    ListPriceArray=nil;
    [listmenu reloadData];
}
-(void)EXViewClose:(BOOL)isClose
{
    [UIView animateWithDuration:0.2 animations:^{
        if(isClose)
        {
            [selectEXBtn.imageView setTransform:CGAffineTransformMakeRotation(2*M_PI)];
        }else
        {
            [selectEXBtn.imageView setTransform:CGAffineTransformMakeRotation(M_PI-0.001)];
        }
    }];
}

@end
