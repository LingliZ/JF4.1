//
//  GXPriceListAddCodeViewController.m
//  GXAppNew
//
//  Created by shenqilong on 16/12/15.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXPriceListAddCodeViewController.h"
#import "GXPriceConst.h"

#import "PricePlatformModel.h"
#import "PriceProductModel.h"
#import "PriceMarketModel.h"

#import "GXPriceListAddCodeTableViewCell.h"

#import "GXTextSpaceLabel.h"

#define tag_cellBtnAdd 161216
@interface GXPriceListAddCodeViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *listmenu;
    NSURLSessionDataTask *dataTask;//请求任务;
    NSTimer *timer;
    NSArray *PricePlatformArray;//交易所列表
    NSArray *ListCodeArray;//选中的交易所code列表
    NSArray *ListPriceArray;//行情数据
    
    NSMutableArray *tempSelectCodeArray;
}

@end

@implementation GXPriceListAddCodeViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title=@"自选添加";

    listmenu=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64) style:UITableViewStylePlain];
    listmenu.dataSource=self;
    listmenu.delegate=self;
    listmenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    listmenu.backgroundColor=priceList_color_tableViewBackg;
    [self.view addSubview:listmenu];
    
    
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
    header.stateLabel.textColor=priceList_color_tableViewFootViewText;
    header.lastUpdatedTimeLabel.textColor=priceList_color_tableViewFootViewText;
    header.loadingView.color=priceList_color_tableViewFootViewText;
    listmenu.mj_header=header;
    listmenu.mj_header.automaticallyChangeAlpha = YES;
    [listmenu.mj_header beginRefreshing];

    
    UIBarButtonItem *BarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:0 target:self action:@selector(doneButton)];
    [BarButtonItem setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBACOLOR(68, 133, 241, 1),NSFontAttributeName:GXFONT_PingFangSC_Regular(14)} forState:UIControlStateNormal];

    self.navigationItem.rightBarButtonItem=BarButtonItem;
    
    
    
    NSArray *array = [GXUserdefult objectForKey:PersonSelectCodesKey];
    
    if(!array)
        array=@[];
    
    tempSelectCodeArray=[[NSMutableArray alloc]initWithArray: array];
    
}

-(void)viewWillDisappear:(BOOL)animated
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
}


-(void)doneButton
{
    GXLog(@"完成");
    
    if([tempSelectCodeArray count]==[[GXUserdefult objectForKey:PersonSelectCodesKey] count])
    {
        [self dismissViewControllerAnimated:YES completion:^{}];
        return;
    }
    
    
    
    [self.view showLoadingWithTitle:@"正在保存"];
    
    [GXUserdefult setObject:tempSelectCodeArray forKey:PersonSelectCodesKey];
    [GXUserdefult synchronize];
    
    
    if(![GXUserInfoTool isLogin])
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            [self.view removeTipView];
            
//            [self.navigationController popViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:^{
            
                if([delegate respondsToSelector:@selector(addCodeDone)])
                    [delegate addCodeDone] ;
            
            }];
            
            
        });
        
        return;
    }
    
    
    
    [GXHttpTool POST:GXUrl_setPrice parameters:@{@"productCodes":[tempSelectCodeArray componentsJoinedByString:@","]}  success:^(id responseObject) {
        
        if ([responseObject[GXSuccess] integerValue] == 1) {
        
            
        }else
        {
            
        }
        
        [self.view removeTipView];
        
//        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:^{
        
            if([delegate respondsToSelector:@selector(addCodeDone)])
                [delegate addCodeDone] ;
        }];

        
        
        
    } failure:^(NSError *error) {
        [self.view removeTipView];
        
//        [self.navigationController popViewControllerAnimated:YES];
        [self dismissViewControllerAnimated:YES completion:^{

            if([delegate respondsToSelector:@selector(addCodeDone)])
                [delegate addCodeDone] ;
        
        }];

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    //如果拿到了交易分类就不再加载了
    if([PricePlatformArray count]==0)
    {
        //获取交易所列表
        [self loadMarkInfo];
    }else
    {
        //加载行情
        if(ListCodeArray.count>0)
        {
            [self loadPriceData];
            timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(loadPriceData) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        }
    }
}

- (void)loadMarkInfo {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platform"] = @"ios";
    
    [GXHttpTool POST:GXUrl_marketInfo parameters:param  success:^(id responseObject) {
        
        if ([responseObject[GXSuccess] integerValue] == 1) {
            
            PricePlatformArray = [PricePlatformModel mj_objectArrayWithKeyValuesArray:responseObject[GXValue]];
            
            for (int i=0; i<[PricePlatformArray count]; i++) {
                PricePlatformModel *platModel=PricePlatformArray[i];
                platModel.isOpen=@"1";
            }
            
            [listmenu reloadData];
            
            
            NSMutableArray *codear=[[NSMutableArray alloc]init];
            for (int i=0; i<[PricePlatformArray count]; i++) {
                
                PricePlatformModel *platModel=PricePlatformArray[i];
                NSArray *listAr = platModel.tradeInfoList;
                
                for (int j=0; j<[listAr count]; j++) {
                    PriceProductModel *productModel=listAr[j];
                    [codear addObject:productModel.code];
                }
            }
            ListCodeArray=codear;
            codear=nil;
            
            //加载行情
            if(ListCodeArray.count>0)
            {
                [self loadPriceData];
                timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(loadPriceData) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
            }
            
        }else
        {
            if([listmenu.mj_header isRefreshing])
                [listmenu.mj_header endRefreshing];
        }
        
    } failure:^(NSError *error) {
            if([listmenu.mj_header isRefreshing])
                [listmenu.mj_header endRefreshing];
    }];
}

-(void)loadPriceData
{
    if(dataTask)
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
            
            if([[model1.code lowercaseString] isEqualToString:[model2.code lowercaseString]])
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


#pragma mark - delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return PricePlatformArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    PricePlatformModel *platModel=PricePlatformArray[section];
    
    int isOpen=[platModel.isOpen intValue];
    
    if (isOpen) {
        if([platModel.tradeInfoList count]>0)
        {
            return [platModel.tradeInfoList count]+1;
        }
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PricePlatformModel *platModel=PricePlatformArray[indexPath.section];
    
    int isOpen=[platModel.isOpen intValue];
    
    if(isOpen&&indexPath.row!=0)
    {
        static NSString *CellIdentifier = @"priceList";
        
        GXPriceListAddCodeTableViewCell *cell=(GXPriceListAddCodeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GXPriceListAddCodeTableViewCell" owner:self options:nil] objectAtIndex:1];
            cell.delegate=(id)self;
            
            cell.name.font=GXFONT_PingFangSC_Regular(15);
            cell.name.textColor=priceAddCodeList_color_cellPriceText;
            
            [cell.btn_add setTitleColor:priceAddCodeList_color_cellPriceRightBtnText forState:UIControlStateNormal];
            cell.btn_add.titleLabel.font=GXFONT_PingFangSC_Regular(15);
            
            cell.lb_last.font=GXFONT_PingFangSC_Regular(15);
        }
        
        PriceProductModel *prductMode=platModel.tradeInfoList[indexPath.row-1];
        cell.name.text=prductMode.name;
        
    
        
        cell.lb_last.text=@"--";
        cell.lb_last.textColor=priceList_color_tableViewCellPriceTextEqual;
        cell.lb_last.backgroundColor=[UIColor clearColor];
        for (PriceMarketModel *priceModel in ListPriceArray) {
            if([[priceModel.code lowercaseString] isEqualToString:[prductMode.code lowercaseString]])
            {
                cell.lb_last.text=priceModel.last;
                cell.lb_last.textColor=priceModel.lastColor;
                cell.lb_last.backgroundColor=priceModel.lastBackgColor;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    priceModel.lastBackgColor=nil;
                    cell.lb_last.backgroundColor=[UIColor clearColor];
                });
                break;
            }
        }
        
        
        [cell.btn_add setTitle:@"" forState:UIControlStateNormal];
        [cell.btn_add setImage:[UIImage imageNamed:priceAddCodeList_imgname_cellPriceRightBtn] forState:UIControlStateNormal];
        cell.btn_add.enabled=YES;

        for (NSString *codes in tempSelectCodeArray) {
            if([[codes lowercaseString] isEqualToString:[prductMode.code lowercaseString]])
            {
                [cell.btn_add setTitle:@"已添加" forState:UIControlStateNormal];
                [cell.btn_add setImage:nil forState:UIControlStateNormal];
                cell.btn_add.enabled=NO;
                
                break;
            }
        }
        
        cell.btn_add.tag=tag_cellBtnAdd+indexPath.section*1000+indexPath.row;
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = priceAddCodeList_color_cellPriceBackg;
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"Title";
        
        GXPriceListAddCodeTableViewCell *cell=(GXPriceListAddCodeTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GXPriceListAddCodeTableViewCell" owner:self options:nil] objectAtIndex:0];
            
            
            cell.title.font=GXFONT_PingFangSC_Regular(15);
            cell.title.textColor=priceAddCodeList_color_cellTitleText;
            
            [cell.titBtn setImage:[UIImage imageNamed:priceAddCodeList_imgname_cellTitleRightBtn] forState:UIControlStateNormal];
            cell.titBtn.userInteractionEnabled=NO;

        }
        
        cell.title.text = platModel.exname_custom;
        
        
        [cell changeArrowWithUp:isOpen];
        
        
        
        if(isOpen)
        {
            cell.lineImg.backgroundColor=[UIColor clearColor];
        }else
        {
            cell.lineImg.backgroundColor=priceAddCodeList_color_CellLineBackg;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = priceAddCodeList_color_cellTitleBackg;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PricePlatformModel *platModel=PricePlatformArray[indexPath.section];
    int isOpen=[platModel.isOpen intValue];
    
    if (isOpen) {
        if(indexPath.row!=0)
        {
            return 50;
        }
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        PricePlatformModel *platModel=PricePlatformArray[indexPath.section];
        int isOpen=[platModel.isOpen intValue];
        
        if (isOpen)
        {
            platModel.isOpen=@"0";
            
            [self didSelectCellRowFirstDo:NO nextDo:NO  indexPath:indexPath];
        }else
        {
            platModel.isOpen=@"1";
            
            [self didSelectCellRowFirstDo:YES nextDo:NO  indexPath:indexPath];
        }
    }else
    {
        GXLog(@"%ld",indexPath.row);
    }
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert indexPath:(NSIndexPath *)indexPath
{
    
    GXPriceListAddCodeTableViewCell *cell = (GXPriceListAddCodeTableViewCell *)[listmenu cellForRowAtIndexPath:indexPath];
    [cell changeArrowWithUp:firstDoInsert];
    
    if(firstDoInsert)
    {
        cell.lineImg.backgroundColor=[UIColor clearColor];
    }else
    {
        cell.lineImg.backgroundColor=priceAddCodeList_color_CellLineBackg;
    }
    
    
    [listmenu beginUpdates];
    
    NSInteger section = indexPath.section;
    
    PricePlatformModel *platModel=PricePlatformArray[indexPath.section];
    
    NSInteger contentCount=[platModel.tradeInfoList count];
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i < contentCount + 1; i++) {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    
    if (firstDoInsert)
    {   [listmenu insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [listmenu deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
    }
    
    rowToInsert=nil;
    
    [listmenu endUpdates];
}

#define mark - GXPriceListAddCodeTableViewCellDelegate
-(void)btnAddClick:(id)sender
{
    UIButton *bb=sender;
    
    NSInteger section=(bb.tag-tag_cellBtnAdd)/1000;
    NSInteger row=bb.tag-tag_cellBtnAdd- section*1000;
    

    //获取code并写入本地
    PricePlatformModel *platModel=PricePlatformArray[section];
    PriceProductModel *productModel=platModel.tradeInfoList[row-1];
   
   
    [tempSelectCodeArray addObject:productModel.code];
    
   
    [listmenu reloadData];
    
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
