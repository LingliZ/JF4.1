//
//  GXNoticeVc.m
//  GXAppNew
//
//  Created by maliang on 2016/12/2.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXNoticeVc.h"
#import "GXNoticeCell.h"
#import "GXNoticeModel.h"

@interface GXNoticeVc ()

@property (nonatomic, strong)NSMutableArray *dataSource;

@end

@implementation GXNoticeVc

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.backgroundColor = GXRGBColor(241, 242, 247);
    self.title = @"公告";
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView setShowsVerticalScrollIndicator:NO];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[GXNoticeCell class] forCellReuseIdentifier:@"GXNoticeCell"];
    [self loadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXNoticeCell" forIndexPath:indexPath];
    GXNoticeModel *model = self.dataSource[indexPath.row];
    cell.model = model;
    
    cell.backgroundColor = GXRGBColor(241, 242, 247);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)loadData
{
    NSDictionary *parameters = @{@"type":@"1",@"count":@"15",@"isLater":@"1",@"startId":@"0",@"roomId":self.roomID,@"isMore":@"0"};
    [GXHttpTool POST:GXUrl_getBulletins parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 1) {
            for (NSDictionary *dict in responseObject[@"value"]) {
                GXNoticeModel *model = [GXNoticeModel modelWithDict:dict];
                [self.dataSource addObject:model];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)dealloc{
    
}
@end
