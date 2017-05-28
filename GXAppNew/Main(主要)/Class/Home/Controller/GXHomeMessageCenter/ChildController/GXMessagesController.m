//
//  GXMessagesController.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/27.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMessagesController.h"
#import "GXMessageCell.h"
#import "GXMessagesModel.h"
#import "AppDelegate.h"
@interface GXMessagesController ()
@property(nonatomic,strong)NSMutableArray * dataSource;
@property (nonatomic,assign)NSInteger page;
@property (nonatomic,strong) NSMutableDictionary *readSuggestionsDict;
@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong)GXMessagesModel *testmessageModel;
@end

@implementation GXMessagesController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.navigationController.navigationBar.translucent = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"国鑫消息";
    [GXUserdefult removeObjectForKey:GXMessageLocalMsg];
    [GXUserdefult synchronize];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [GXUserInfoTool clearGXMessageNum];
    [((AppDelegate*)[UIApplication sharedApplication].delegate) setMessage];
    [self createUI];
    if ([GXUserInfoTool isConnectToNetwork]) {
        [self refreshData];
    }else{
        [self showErrorNetMsg:@"" withView:self.tableView];
    }
    
}
#pragma mark --- 搭建UI
- (void)createUI {
    //隐藏分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏竖向滑动条
    [self.tableView setShowsVerticalScrollIndicator:NO];
    self.tableView.backgroundColor = GXHomeBackGroundColor;
}

#pragma mark --- 添加MJ刷新
- (void)refreshData{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshFirstData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreData)];
}

#pragma mark --- 刷新方法
- (void)refreshFirstData{
    self.page = 25;
    [self loadData:self.page];
}
- (void)refreshMoreData{
    self.page += 25;
    [self loadData:self.page];
}

#pragma mark --- 网络请求
-(void) loadData :(NSInteger)page{
    NSDictionary * parameter = @{@"count":@(page),@"isLater":@"1",@"roomId":@"1372412092890",@"isMore":@"0"};
    [GXHttpTool POSTCache:GXUrl_newMyMessage parameters:parameter success:^(id responseObject) {
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            NSArray *array = responseObject[@"value"];
            if (array.count == 0) {
                [self showEmptyMsg:@"没有新数据" dataSourceCount:array.count superView:self.tableView];
            }
            NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:array.count];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arrM addObject:[GXMessagesModel messageModelWithDict:obj]];
            }];
            self.dataSource = arrM;
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }else{
            [self showErrorNetMsg:responseObject[@"message"] withView:self.tableView];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSError *error) {
        [self showErrorNetMsg:@"" withView:self.tableView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GXMessagesModel *messageModel = self.dataSource[indexPath.row];
    NSString *identifierID = [NSString stringWithFormat:@"%@",messageModel.ID];
    GXMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierID];
    if (!cell) {
        cell = [[GXMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierID messageModel:messageModel];
    }
    cell.messageModel = messageModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSMutableDictionary *)readSuggestionsDict{
    if (_readSuggestionsDict == nil) {
        self.filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"readSuggestionsDict"];
        _readSuggestionsDict = [NSMutableDictionary dictionaryWithContentsOfFile:self.filePath];
        if (_readSuggestionsDict == nil) {
            _readSuggestionsDict = [NSMutableDictionary dictionary];
        }
    }
    return _readSuggestionsDict;
}
- (void)dealloc{
    [self.readSuggestionsDict writeToFile:self.filePath atomically:YES];
}
@end
