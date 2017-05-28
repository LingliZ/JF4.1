//
//  GXLiveVc.m
//  GXAppNew
//
//  Created by maliang on 2016/11/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXLiveVc.h"
#import "GXNoticeVc.h"
#import "GXLiveCell.h"
#import "GXLiveModel.h"
#import "GXNoticeView.h"
#import "GXNoticeModel.h"
#import "UIViewController+NetErrorTips.h"

@interface GXLiveVc () <UITableViewDelegate,UITableViewDataSource,GXNoticeViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<GXLiveModel *> *dataSource;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, strong) GXNoticeView *noticeV;

@end

@implementation GXLiveVc


- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self refreshData];
    topId=@"0";
    endId=@"0";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshTopBar];
}

- (void)refreshTopBar{
    NSDictionary * parameters = @{@"count":@"1",@"isLater":@"1",@"startId":@"0",@"roomId":self.liveRoomID};
    [GXHttpTool POST:GXUrl_getBulletins parameters:parameters success:^(id responseObject) {
        if ([responseObject[@"success"] integerValue] == 1) {
            NSArray *arr = [GXNoticeModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
            if (arr.count > 0) {
                GXNoticeModel *model = [arr objectAtIndex:0];
                self.noticeV.titleLable.text = model.title;
            }
        }
    } failure:^(NSError *error) {
        GXLog(@"%@", error);
    }];
}

-(void)dealloc
{
    [self.tableView.mj_header removeFromSuperview];
    [self.tableView.mj_footer removeFromSuperview];
}

- (void)createUI
{
    self.view.backgroundColor = GXAdviserBGColor;
    self.tableView = [[UITableView alloc] init];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setShowsVerticalScrollIndicator:NO];
    self.tableView.backgroundColor = GXAdviserBGColor;
    
    GXNoticeView *noticeV = [[GXNoticeView alloc] initWithFrame:CGRectZero withRoomId:self.liveRoomID];
    self.noticeV = noticeV;
    noticeV.delegate = self;
    noticeV.backgroundColor = [UIColor whiteColor];
    noticeV.layer.cornerRadius = 10;
    noticeV.layer.masksToBounds = true;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:noticeV];
    
    [noticeV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(GXMargin);
        make.left.equalTo(@(GXMargin));
        make.right.equalTo(@(-GXMargin));
        make.height.equalTo(@40);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(noticeV);
        make.top.equalTo(noticeV.mas_bottom).offset(GXMargin * 0.5);
        make.bottom.equalTo(self.view);
    }];
}
#pragma mark - 添加刷新 -
- (void)refreshData
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshFirstData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreData)];
}
#pragma mark - 刷新方法 -
- (void)refreshFirstData
{
    //首次加载
    if ([topId isEqualToString:@"0"]) {
        count = @"25";
    } else {
        count = @"5";
    }
    startId = topId;
    isLater = @"1";
    isMore = @"0";
    [self loadDataFirst];
}
- (void)refreshMoreData
{
    startId = endId;
    isLater = @"0";
    count = @"5";
    isMore = @"1";
    [self loadData];
}

#pragma mark - 数据请求 -
- (void)loadData
{
    NSDictionary * parameter = @{@"type":@"1",@"count":count,@"isLater":isLater,@"startId":startId,@"roomId":self.liveRoomID,@"isMore":isMore};
    [GXHttpTool POST:GXUrl_getData parameters:parameter success:^(id responseObject) {
        
        if ([responseObject[@"success"] integerValue] == 1) {
            NSArray *array =  responseObject[@"value"];
            if (array.count == 0) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                return ;
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GXLiveModel *model = [GXLiveModel modelWthDict: obj];
                [self.dataSource addObject:model];
            }];
        }
        endId = self.dataSource.lastObject.idNew;
        [self.tableView reloadData];
        [self showEmptyMsg:nil dataSourceCount:self.dataSource.count superView:self.tableView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showErrorNetMsg:nil withView:self.tableView];
    }];
}

- (void)loadDataFirst
{
    NSDictionary * parameter = @{@"type":@"1",@"count":count,@"isLater":isLater,@"startId":startId,@"roomId":self.liveRoomID,@"isMore":isMore};
    [GXHttpTool POST:GXUrl_getData parameters:parameter success:^(id responseObject) {
        
        if ([responseObject[@"success"] integerValue] == 1) {
            [self.dataSource removeAllObjects];
            NSArray *array =  responseObject[@"value"];
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GXLiveModel *model = [GXLiveModel modelWthDict: obj];
                [self.dataSource addObject:model];
            }];
        }
        endId = self.dataSource.lastObject.idNew;
        [self.tableView reloadData];
        [self showEmptyMsg:nil dataSourceCount:self.dataSource.count superView:self.tableView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showErrorNetMsg:nil withView:self.tableView];
    }];
}

#pragma mark - 代理方法 -

- (nullable UITableViewHeaderFooterView *)footerViewForSection:(NSInteger)section {
    UITableViewHeaderFooterView *footV = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:@"footerView"];
    if (!footV) {
        footV = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"footerView"];
    }
    footV.contentView.backgroundColor = GXAdviserBGColor;
    return footV;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return GXMargin;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXLiveModel *liveModel = self.dataSource[indexPath.section];
    GXLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:@"liveCell"];
    if (!cell) {
        cell = [[GXLiveCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"liveCell"];
    }
    cell.model = liveModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - NoticeLabelClickDelegate -
- (void)clickedNoticeView: (GXNoticeView *)noticeView
{
    GXNoticeVc *noticeVc = [[GXNoticeVc alloc] init];
    noticeVc.roomID = noticeView.roomID;
    [MobClick event:@"announcement"];
    [self.navigationController pushViewController:noticeVc animated:YES];
}

@end
