//
//  GXInvestCourseController.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXInvestCourseController.h"
#import "GXDetailCourseCell.h"
#import "GXChapterListModel.h"
#import "GXSyllabusDetailController.h"

@interface GXInvestCourseController ()

@property (nonatomic,strong) NSMutableArray *saveDataArray;

@end

@implementation GXInvestCourseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.saveDataArray = [NSMutableArray new];
    
    [self addHeaderView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
    
    
    self.tableView.tableFooterView=[[UIView alloc]init];

}

- (void)addHeaderView{
    UIView *headerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 200)];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = GXFONT_PingFangSC_Medium(GXFitFontSize16);
    
    UIImageView *iconV = [[UIImageView alloc] init];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    detailLabel.numberOfLines = 0;
//    [detailLabel sizeToFit];
    
    [headerV addSubview:titleLabel];
    [headerV addSubview:iconV];
    [headerV addSubview:detailLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.centerX.equalTo(headerV);
        //make.height.equalTo(@30);
    }];
    [iconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(titleLabel.mas_bottom).offset(10);
        make.height.equalTo(@80);
        make.width.equalTo(@100);
        make.bottom.equalTo(@(-10));
    }];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(iconV);
        make.left.equalTo(iconV.mas_right).offset(10);
        make.right.equalTo(@(-10));
    }];
    
    UIView *sepV = [[UIView alloc] init];
    sepV.backgroundColor = [UIColor grayColor];
    [headerV addSubview:sepV];
    [sepV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(headerV);
    }];
    titleLabel.text = self.recieveModel.title;
    detailLabel.text = self.recieveModel.descrip;
    [iconV sd_setImageWithURL:[NSURL URLWithString:self.recieveModel.imgurl] placeholderImage:[UIImage imageNamed:@""]];
    
    self.tableView.tableHeaderView = headerV;
}
- (void)loadData{
    NSDictionary *parameter = @{@"pid":self.recieveModel.ID};
    [GXHttpTool POSTCache:GXUrl_findInvestSchoolDetailsList parameters:parameter success:^(id responseObject) {
        for (NSDictionary *dataDict in responseObject[@"value"][@"data"]) {
            GXChapterListModel *model = [GXChapterListModel new];
            [model setValuesForKeysWithDictionary:dataDict];
            [self.saveDataArray addObject:model];
        }
        
        [self.tableView.mj_header endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPat{
    GXSyllabusDetailController *detailVC = [[GXSyllabusDetailController alloc]init];
    detailVC.title = self.title;
    detailVC.recieveModel = self.saveDataArray[indexPat.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.saveDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXDetailCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXDetailCourseCell"];
    if (!cell) {
        cell = [[GXDetailCourseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GXDetailCourseCell"];
    }
    cell.model = self.saveDataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
