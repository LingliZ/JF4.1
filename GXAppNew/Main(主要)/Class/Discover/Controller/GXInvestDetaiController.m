//
//  GXInvestDetaiController.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXInvestDetaiController.h"
#import "GXDiscoverCourseCell.h"
#import "GXInvestCourseController.h"
#import "GXInvestListModel.h"
@interface GXInvestDetaiController ()
@property (nonatomic,strong)NSMutableArray *saveDataArray;
@property (nonatomic,strong)NSArray *titlesArray;
@end

@implementation GXInvestDetaiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titlesArray = @[@"基础课", @"基本课", @"技术课"];
    self.saveDataArray = [NSMutableArray new];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.backgroundColor=RGBACOLOR(241, 242, 247, 1);

    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
}

- (void)loadData{
    
    NSDictionary *parameter = @{@"cid":@(self.type + 1)};
    
    [GXHttpTool POSTCache:GXUrl_findInvestSchool parameters:parameter success:^(id responseObject) {
        if ([(NSNumber *) responseObject[@"success"] integerValue] == 1) {
            for (NSDictionary *valueDict in responseObject[@"value"]) {
                GXInvestListModel *listModel = [GXInvestListModel new];
                [listModel setValuesForKeysWithDictionary:valueDict];
                [self.saveDataArray addObject:listModel];
            }
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GXInvestCourseController *vc = [[GXInvestCourseController alloc] init];
    vc.recieveModel = self.saveDataArray[indexPath.row];
    vc.title = self.titlesArray[self.type];
    [self.navigationController pushViewController:vc animated:true];
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.saveDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXDiscoverCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXDiscoverCourseCell"];
    
    if (!cell) {
        cell = [[GXDiscoverCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GXDiscoverCourseCell"];
    }
    cell.model = self.saveDataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
