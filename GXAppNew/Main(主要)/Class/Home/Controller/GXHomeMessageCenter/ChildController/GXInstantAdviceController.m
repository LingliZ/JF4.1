//
//  GXInstantAdviceController.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/26.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXInstantAdviceController.h"
#import "GXOperationItemModel.h"
#import "AppDelegate.h"
#import "GXSuggestDetailHeadV.h"
#import "GXSuggestFooterV.h"
#import "GXSuggestTopCell.h"
#import "GXSuggestTopDoubleCell.h"
#import "GXSuggestSingleCell.h"
#import "GXSuggestDoubleCell.h"

@interface GXInstantAdviceController () <UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView *backgv;
    float tableViewHeight;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic,assign)NSInteger page;

@end

@implementation GXInstantAdviceController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"即时建议详情";
    startId = @"0";

    [self createUI];
    [self dataSource];
    topId=@"0";
    endId=@"0";
}
-(NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

#pragma mark --- 搭建UI
- (void)createUI {
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.rowHeight = 100;
//    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:self.tableView];
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
    GXSuggestDetailHeadV *headView = [[[NSBundle mainBundle]loadNibNamed:@"GXSuggestDetailHeadV" owner:self options:nil]lastObject];
    headView.suggestModel = self.model;
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 200;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    GXSuggestFooterV *footerV = [[GXSuggestFooterV alloc]init];
    footerV.model = self.model;
    return footerV;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat footerHeight = self.model.contentHeight + 10 +HeightScale_IOS6(90);
    return footerHeight;
}
@end
