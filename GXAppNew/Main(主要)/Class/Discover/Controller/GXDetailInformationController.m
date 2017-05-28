//
//  GXDetailInformationController.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/9.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXDetailInformationController.h"
#import "GXHomeTableViewCell.h"
#import "UITableView+GXSetFooter.h"
#import "GXSubDetailController.h"
#import "GXInformationModel.h"
#import "GXGlobalArticleDetailController.h"
#import "GXDetailInformationTableViewCell.h"
@interface GXDetailInformationController ()
@property (nonatomic,strong)NSMutableArray *saveDataArray;
@property (nonatomic,assign)NSInteger page;
@end

@implementation GXDetailInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveDataArray = [NSMutableArray new];

    [self.tableView setFooter];
    
//    self.tableView.estimatedRowHeight = 100;
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
//    [self.tableView reloadData];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self refreshData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"GXDetailInformationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"GXDetailInformationTableViewCell"];
    
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
}
- (void)refreshData{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshFirstData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreData)];
}
- (void)refreshFirstData{
    self.page = 1;
    [self loadMoreDataFromServer:self.page];
}
- (void)refreshMoreData{
    self.page++;
    [self loadMoreDataFromServer:self.page];
}

- (void)loadMoreDataFromServer:(NSInteger)page{
    NSDictionary *parmarter = @{@"cid":self.type,@"page":@(page),@"number":@"20"};
    [GXHttpTool POSTCache:GXUrl_articleList parameters:parmarter success:^(id responseObject) {
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            for (NSDictionary *valueDict in responseObject[@"value"]) {
                GXInformationModel *model = [GXInformationModel new];
                [model setValuesForKeysWithDictionary:valueDict];
                [self.saveDataArray addObject:model];
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (self.saveDataArray.count == 0) {
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self.tableView reloadData];
//            [self showErrorNetMsg:nil Handler:^{
//                [self refreshData];
//            }];
        }
    }];
}
- (void)removeAllObjectsFromArray{
    [self.saveDataArray removeAllObjects];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GXGlobalArticleDetailController *subVC = [[GXGlobalArticleDetailController alloc] init];
    subVC.informationModel = self.saveDataArray[indexPath.row];
    [self.navigationController pushViewController:subVC animated:true];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.saveDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXDetailInformationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXDetailInformationTableViewCell" forIndexPath:indexPath];
    cell.model = self.saveDataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

@end
