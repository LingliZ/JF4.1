//
//  GXInstantAdviceListController.m
//  GXAppNew
//
//  Created by 王振 on 2017/1/14.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXInstantAdviceListController.h"
#import "PriceMarketModel.h"
#import "GXSuggestionModel.h"
#import "GXSuggestCell.h"
#import "AppDelegate.h"
#import "GXInstantAdviceController.h"
@interface GXInstantAdviceListController ()<GXSuggestCellDelegate>
{
    //当前第一条起始标识
    NSString *startId;
    //是否最新
    NSString *isLater;
    //获取条数
    NSString * count;
    //当前最后一条标识
    NSString * endId;
    //是否加载更多
    NSString * isMore;
    //当前一条标识
    NSString * topId;
}

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, strong) PriceMarketModel *marketModel;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GXInstantAdviceListController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [GXUserdefult removeObjectForKey:suggestLocalMsg];
    [GXUserdefult synchronize];
    self.dataSource = [NSMutableArray new];
    if ([GXUserInfoTool isConnectToNetwork]) {
        [self refreshData];
    }else{
        [self showErrorNetMsg:@"" withView:self.tableView];
    }
    self.title = @"即时建议";
    [GXUserInfoTool clearSuggestNum];
    [((AppDelegate*)[UIApplication sharedApplication].delegate) setMessage];
    startId = @"0";
    topId=@"0";
    endId=@"0";
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = GXHomeBackGroundColor;
}
- (void)timerAction
{
    [self loadPriceData];
}
#pragma mark --- 添加MJ刷新
- (void)refreshData{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshFirstData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreData)];
}
#pragma mark --- 刷新方法
- (void)refreshFirstData{
    //第一次加载
    if ([topId isEqualToString:@"0"]) {
        count=@"25";
    }
    //刷新
    else{
        count=@"5";
    }
    startId=topId;
    isLater=@"1";
    isMore=@"0";
    [self loadData];
}
- (void)refreshMoreData{
    startId=endId;
    isLater=@"0";
    count=@"5";
    isMore=@"1";
    [self loadData];
}
#pragma mark --- 网络请求
-(void) loadData {
    NSDictionary * parameter = @{@"type":@"3",@"count":count,@"isLater":isLater,@"startId":startId};
    __weak typeof(self) weakSelf = self;
    [GXHttpTool POSTCache:GXUrl_myMessage parameters:parameter success:^(id responseObject) {
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            NSArray *Arr = responseObject[@"value"];
            if (Arr.count == 0) {
                [self showEmptyMsg:@"当前没有及时建议消息" dataSourceCount:Arr.count superView:self
                 .tableView];
            }
            NSMutableArray *mArr = [NSMutableArray new];
            for (NSDictionary *dict in Arr) {
                GXSuggestionModel *model = [[GXSuggestionModel alloc] initWithDict:dict];
                [mArr addObject:model];
            }
            if ([mArr count]>0&&[isLater isEqualToString:@"1"]) {
                //最新增加到头部
                NSMutableArray *tempArr = [NSMutableArray new];
                tempArr = self.dataSource;
                for (GXSuggestionModel *model1 in mArr) {
                    for (GXSuggestionModel *model2 in tempArr) {
                        if ([model1.oldId integerValue] == [model2.nID integerValue]) {
                            [tempArr removeObject:model2];
                            break;
                        }
                    }
                }
                self.dataSource = tempArr;
                [self.dataSource insertArray:mArr atIndex:0];
            }
            if ([mArr count]>0&&[isLater isEqualToString:@"0"]) {
                //最新增加到尾部
                [self.dataSource insertArray:mArr atIndex:[self.dataSource count]];
            }
            if ([self.dataSource count]>0) {
                GXSuggestionModel * liveModel=[self.dataSource objectAtIndex:0];
                topId=liveModel.nID;
                liveModel=[self.dataSource objectAtIndex:[self.dataSource count]-1];
                endId=liveModel.nID;
            }
            [self loadPriceData];
            [self.tableView reloadData];
            //            [self showEmptyMsg:@"绑定此播间，可获得查看即时建议权限" dataSourceCount:self.dataSource.count superView:self.tableView];
        } else{
            [self showErrorNetMsg:responseObject[@"message"] withView:self.tableView];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
//取行情接口
- (void)loadPriceData
{
    NSMutableArray *codeArr = [[NSMutableArray alloc] init];
    for (GXSuggestionModel *model in self.dataSource) {
        [codeArr addObject:model.varietiesCode];
    }
    NSString *codeStr = [codeArr componentsJoinedByString:@","];
    NSDictionary *parameters = @{@"code":codeStr};
    [GXHttpTool POST:GXUrl_quotation parameters:parameters success:^(id responseObject) {
        if ([responseObject[GXSuccess] integerValue] == 1) {
            NSArray *valueArr = responseObject[GXValue];
            NSMutableArray *arrM = [PriceMarketModel mj_objectArrayWithKeyValuesArray:valueArr];
            for (NSInteger i = 0; i < valueArr.count; i++) {
                GXSuggestionModel *model = self.dataSource[i];
                model.sell = [(PriceMarketModel *)arrM[i] sell];
                model.buy = [(PriceMarketModel *)arrM[i] buy];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXSuggestionModel *suggestionModel = self.dataSource[indexPath.row];
    static NSString *cellName = @"cell";
    GXSuggestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GXSuggestCell" owner:self options:nil]lastObject];
    }
    cell.delegate = self;
    cell.suggestModel = suggestionModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
#pragma mark ----- cell delegate -----
- (void)turnToSuggestDetailVc:(GXSuggestionModel *)model{
    GXInstantAdviceController *instantVC = [[GXInstantAdviceController alloc]init];
    instantVC.model = model;
    [self.navigationController pushViewController:instantVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GXInstantAdviceController *instantVC = [[GXInstantAdviceController alloc]init];
    instantVC.model = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:instantVC animated:YES];
}
@end
