//
//  GXPriceWarningController.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/27.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXPriceWarningController.h"
#import "GXPriceAlertModel.h"
#import "AppDelegate.h"
#import "GXPriceAlarmCell.h"

@interface GXPriceWarningController ()
@property(nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic,assign)NSInteger page;
@end
@implementation GXPriceWarningController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationController.navigationBar.translucent = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"报价提醒";
    //[self popClickBackAction];
    [super viewDidLoad];
    [GXUserdefult removeObjectForKey:priceAlarmLocalMsg];
    [GXUserdefult synchronize];
    [GXUserInfoTool clearAlarmNum];
    [((AppDelegate*)[UIApplication sharedApplication].delegate) setMessage];
    [self createUI];
    if ([GXUserInfoTool isConnectToNetwork]) {
        [self refreshData];
    }else{
        [self showErrorNetMsg:@"" withView:self.tableView];
    }
}
//返回按钮
- (void)popClickBackAction{
    UIImage *xuanran = [[UIImage imageNamed:@"navigationbar_back"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:xuanran style:UIBarButtonItemStylePlain target:self action:@selector(didBackAction:)];
}
- (void)didBackAction:(UIBarButtonItem *)item{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark --- 搭建UI
- (void)createUI {
    self.tableView.backgroundColor= GXHomeBackGroundColor;
    //代理
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏竖向滑动条
    [self.tableView setShowsVerticalScrollIndicator:NO];
}
#pragma mark --- 添加MJ刷新
- (void)refreshData{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshFirstData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreData)];
    //注册cell
    [self.tableView registerClass:[GXPriceAlarmCell class] forCellReuseIdentifier:@"GXPriceAlarmCell"];
}
#pragma mark --- 刷新方法
- (void)refreshFirstData{
    [self loadData];
}
- (void)refreshMoreData{
    [self loadData];
}
#pragma mark --- 网络请求
-(void) loadData{
    self.dataSource=[GXPriceAlertModel mj_objectArrayWithKeyValuesArray:[GXUserInfoTool getPriceAlarmArray]];
    [self.tableView reloadData];
    if (self.dataSource.count == 0) {
        [self showEmptyMsg:@"当前没有报价提醒消息" dataSourceCount:self.dataSource.count superView:self.tableView];
    }
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
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
    GXPriceAlertModel *alartModel = self.dataSource[indexPath.row];
    GXPriceAlarmCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXPriceAlarmCell" forIndexPath:indexPath];
    cell.alartModel = alartModel;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return WidthScale_IOS6(65) ;
}
#pragma mark --- 懒加载 ---
-(NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
@end
