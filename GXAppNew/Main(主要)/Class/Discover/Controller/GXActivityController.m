//
//  GXActivityController.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXActivityController.h"
#import "GXActivityCell.h"
#import "GXBanAnaRemImpDetailController.h"

@interface GXActivityController ()

@end

@implementation GXActivityController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.tableView.backgroundColor = RGBACOLOR(241, 242, 247, 1);
    self.title = @"活动";
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return GXMargin;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.recieveArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXActivityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXActivityCell"];
    if (!cell) {
        cell = [[GXActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GXActivityCell"];
    }
    cell.model = self.recieveArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GXBanAnaRemImpDetailController *detailVC = [[GXBanAnaRemImpDetailController alloc]init];
    detailVC.disBannerModel = self.recieveArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}
@end
