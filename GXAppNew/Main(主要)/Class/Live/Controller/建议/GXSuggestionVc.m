//
//  GXSuggestionVc.m
//  GXAppNew
//
//  Created by maliang on 2016/12/19.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXSuggestionVc.h"
#import "GXSuggestCell.h"
#import "GXSuggestionModel.h"
#import "GXSuggestDetailVc.h"
#import "PriceMarketModel.h"
#import "UIViewController+NetErrorTips.h"


@interface GXSuggestionVc () <UITableViewDelegate,UITableViewDataSource,GXSuggestCellDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray<GXSuggestionModel *> *dataSource;
@property (nonatomic, strong) PriceMarketModel *marketModel;
@property (nonatomic, strong) NSMutableArray *codeArrayParam;

@end

@implementation GXSuggestionVc {
    NSTimer *timer;
}
- (instancetype)initWithBundleRoom: (NSString *)isBindRoom{
    self = [super init];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 109) style:UITableViewStylePlain];
        self.tableView.estimatedRowHeight = 100;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.tableView setShowsVerticalScrollIndicator:NO];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.view addSubview:self.tableView];
        self.tableView.backgroundColor = GXRGBColor(241, 242, 247);
        self.isBindRoom = isBindRoom;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (timer) {
        [timer invalidate];
        timer = nil;
    } else {
       timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshData];
    topId = @"0";
    endId = @"0";
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)timerAction
{
    [self loadPriceData];
}

- (void)refreshData
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirstData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

- (void)loadFirstData
{
    if ([topId integerValue] == 0) {
        count = @"25";
    } else {
        count = @"5";
    }
    startId = topId;
    isLater = @"1";
    isMore = @"0";
    [self loadData];
}

- (void)loadMoreData
{
    startId = endId;
    isLater = @"0";
    count = @"5";
    isMore = @"1";
    [self loadData];
}

//取行情接口
- (void)loadPriceData
{
    if (self.dataSource.count == 0) {
        return;
    }

    NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
    NSMutableArray *tempArr = [NSMutableArray new];
    for (NSIndexPath *indexPath in visiblePaths) {
        GXSuggestionModel *model = self.dataSource[indexPath.row];
        [tempArr addObject:model.varietiesCode];
    }
 
    NSString *codeStr = [tempArr componentsJoinedByString:@","];
    NSDictionary *parameters = @{@"code":codeStr};
    
    [GXHttpTool POST:GXUrl_quotation parameters:parameters success:^(id responseObject) {
        if ([responseObject[GXSuccess] integerValue] == 1) {
            
            NSMutableArray *arrM = [PriceMarketModel mj_objectArrayWithKeyValuesArray:responseObject[GXValue]];
            
            NSInteger loc = [(NSIndexPath *)visiblePaths.firstObject row];
            NSInteger length = visiblePaths.count;
            
            NSArray *dataSourceTempArray = [self.dataSource subarrayWithRange:NSMakeRange(loc, length)];
    
            NSMutableArray *tempDataArray = [NSMutableArray new];
            
            for (NSInteger i = 0; i < arrM.count; i++) {
                
                GXSuggestionModel *suggestionModel = dataSourceTempArray[i];
                PriceMarketModel *marketModel = arrM[i];
                
                suggestionModel.sell = marketModel.sell;
                suggestionModel.buy = marketModel.buy;
                
                [tempDataArray addObject:suggestionModel];
            }
            
            [self.dataSource replaceObjectsInRange:NSMakeRange(loc, length) withObjectsFromArray:tempDataArray];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadData
{
    NSDictionary * parameters = @{@"type":@"4",@"count":count,@"isLater":isLater,@"startId":startId,@"roomId":self.liveRoomID,@"isMore":isMore};
    [GXHttpTool POST:GXUrl_getData parameters:parameters success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"success"] integerValue] == 1) {
            
            NSArray *array = responseObject[@"value"][@"resultList"];
            if (array.count > 0) {
                NSMutableArray *arrM = [NSMutableArray new];
                for (NSDictionary *dict in array) {
                    GXSuggestionModel *model = [[GXSuggestionModel alloc] initWithDict:dict];
                    if (self.dataSource.count > 0) {
                        [self.dataSource enumerateObjectsUsingBlock:^(GXSuggestionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if ([obj.idNew integerValue] == [model.oldId integerValue]) {
                                [self.dataSource removeObject:obj];
                            }
                        }];
                    }
                    if ([isMore integerValue] != 0 || [startId integerValue] == 0) {
                        [self.dataSource addObject:model];
                    }else{
                        [self.dataSource insertObject:model atIndex:0];
                    }
                    [arrM addObject:model];
                }
                topId = self.dataSource.firstObject.idNew;
                endId = self.dataSource.lastObject.idNew;
                [self.tableView reloadData];
            }
            if ([self.isBindRoom integerValue] == 0) {
                [self showMsgTips];
            }else{
                [self showEmptyMsg:nil dataSourceCount:self.dataSource.count superView:self.tableView];
            }
            [self loadPriceData];
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showErrorNetMsg:nil withView:self.tableView];
    }];
}

- (void)showMsgTips{
    UILabel *label = [[UILabel alloc] init];
    label.font = GXFONT_PingFangSC_Medium(14);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = GXRGBColor(161, 166, 186);
    label.text = @"绑定此播间，可获得查看即时建议权限";
    self.tableView.backgroundView = label;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXSuggestionModel *suggestionModel = self.dataSource[indexPath.row];
    static NSString *cellName = @"cell";
    GXSuggestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"GXSuggestCell" owner:self options:nil]lastObject];
    }
    cell.delegate = self;
    cell.suggestModel = suggestionModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 190;
}

- (void)turnToSuggestDetailVc:(GXSuggestionModel *)model
{
    GXSuggestDetailVc *detailVc = [[GXSuggestDetailVc alloc] init];
    
    detailVc.model = model;
    
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)codeArrayParam {
    if (!_codeArrayParam) {
        _codeArrayParam = [NSMutableArray new];
    }
    return _codeArrayParam;
}

@end
