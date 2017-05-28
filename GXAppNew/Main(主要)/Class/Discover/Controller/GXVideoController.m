//
//  GXVideoController.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXVideoController.h"
#import "GXDiscoverVideoCell.h"
#if SIMULATOR == 0
#import "GXDiscoverVideoController.h"
#endif
#import "GXFindVedioModel.h"
@interface GXVideoController ()

@property (nonatomic,strong)NSMutableArray<GXFindVedioModel *> *saveDataArray;
@property (nonatomic,assign)NSInteger page;

@end

@implementation GXVideoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"精彩视频";
    
    self.saveDataArray = [NSMutableArray new];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [self refreshData];
}
- (void)refreshData{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshMsgFirstData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMsgMoreData)];
}

- (void)refreshMsgFirstData{
    self.page = 1;
    [self loadMoreDataFromServer:self.page];
}
- (void)refreshMsgMoreData{
    self.page++;
    [self loadMoreDataFromServer:self.page];
}

- (void)loadMoreDataFromServer:(NSInteger)page{
    NSDictionary *parameter = @{@"page":@(page),@"number":@(10)};
    [GXHttpTool POSTCache:GXUrl_findVideo parameters:parameter success:^(id responseObject) {
        for (NSDictionary *valueDict in responseObject[@"value"]) {
            GXFindVedioModel *model = [GXFindVedioModel new];
            [model setValuesForKeysWithDictionary:valueDict];
            [self.saveDataArray addObject:model];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate
#if SIMULATOR == 0
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GXDiscoverVideoController *discoverVC = [[GXDiscoverVideoController alloc] init];
    discoverVC.videoAddress = self.saveDataArray[indexPath.row].videoAddress;
    discoverVC.title = self.saveDataArray[indexPath.row].title;
    [self.navigationController pushViewController:discoverVC animated:true];
}
#endif

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.saveDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXDiscoverVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXDiscoverVideoCell"];
    
    if (!cell) {
        cell = [[GXDiscoverVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GXDiscoverVideoCell"];
    }
    cell.model = self.saveDataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

@end
