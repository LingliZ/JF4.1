//
//  GXSuggestDetailVc.m
//  GXAppNew
//
//  Created by maliang on 2016/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXSuggestDetailVc.h"
#import "GXSuggestDetailHeadV.h"
#import "GXSuggestTopCell.h"
#import "GXSuggestTopDoubleCell.h"
#import "GXSuggestDoubleCell.h"
#import "GXSuggestSingleCell.h"
#import "GXSuggestFooterV.h"
#import "GXSuggestionModel.h"



@interface GXSuggestDetailVc () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView *tableView;

@end

@implementation GXSuggestDetailVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"即时建议详情";
    self.tableView.rowHeight = 100;
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.view.backgroundColor = GXRGBColor(241, 242, 247);
    [self createUI];
}

- (void)createUI
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.operationItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXOperationItemModel *operationModel = self.model.operationItems[indexPath.row];
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        if ([operationModel.types integerValue] == 1 || operationModel.isDouble) {
            GXSuggestTopDoubleCell *topDoubleCell = [[GXSuggestTopDoubleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topDoubleCell"];
            topDoubleCell.model = operationModel;
            cell = topDoubleCell;
        } else {
            GXSuggestTopCell *topCell = [[GXSuggestTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"topCell"];
            topCell.model = operationModel;
            cell = topCell;
        }
    } else if (!operationModel.isDouble) {
        GXSuggestSingleCell *singleCell = [[GXSuggestSingleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"singleCell"];
        singleCell.model = operationModel;
        cell = singleCell;
    } else {
        GXSuggestDoubleCell *doubleCell = [[GXSuggestDoubleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"doubleCell"];
        doubleCell.model = operationModel;
        cell = doubleCell;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.contentView setBorderWithView:cell.contentView top:false left:false bottom:true right:false borderColor:GXRGBColor(239, 239, 239) borderWidth:HeightScale_IOS6(1)];
    UIView *sepV = [[UIView alloc] init];
    sepV.backgroundColor = GXRGBColor(239, 239, 239);
    [cell.contentView addSubview:sepV];
    [sepV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(cell.contentView);
        make.height.equalTo(@(HeightScale_IOS6(0.5)));
    }];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GXSuggestDetailHeadV *headV = [[[NSBundle mainBundle]loadNibNamed:@"GXSuggestDetailHeadV" owner:self options:nil]lastObject];
    headV.suggestModel = self.model;
    return headV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 190;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GXSuggestFooterV *footerV = [[GXSuggestFooterV alloc] init];
    footerV.model = self.model;
    return footerV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat footerHeight = self.model.contentHeight + HeightScale_IOS6(90);
    return footerHeight;
}

@end
