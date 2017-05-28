//
//  GXConsultantReplyViewController.m
//  GXApp
//
//  Created by zhudong on 16/7/28.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXConsultantReplyViewController.h"
#import "GXConsultantReplyModel.h"
#import "GXConsultantReplyCell.h"
#import "NSMutableArray+InsertArray.h"
#import "GXConsultantAskCell.h"
#import "YYPhotoBrowseView.h"
#import "GXDetailWebController.h"
#import "AppDelegate.h"
#define GXPicturesViewDidClick @"GXPicturesViewDidClick"

@interface GXConsultantReplyViewController ()
@property (nonatomic,strong) NSMutableArray *consultantReplyModels;
@property (nonatomic,strong) NSMutableArray *formerModels;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,copy) NSString *startId;
@property (nonatomic,copy) NSString *endId;
@property (nonatomic,copy) NSString *firstId;
@property (nonatomic,copy) NSString *isLater;
@property (nonatomic,strong) NSMutableDictionary *readSuggestionsDict;
@property (nonatomic,strong) NSString *filePath;
//@property (nonatomic,strong) UIView *headView;
@end

@implementation GXConsultantReplyViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor =  GXHomeBackGroundColor;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"顾问回复";
    [GXUserdefult removeObjectForKey:replyLocalMsg];
    [GXUserdefult synchronize];
    [GXUserInfoTool clearReplyNum];
    [((AppDelegate*)[UIApplication sharedApplication].delegate) setMessage];
    [self initialParameters];
    //下面的两句为核心代码
    //1设置tableView的预估行高
    self.tableView.estimatedRowHeight = 100;
    //2设置tableView的行高为自动计算
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerClass:[GXConsultantReplyCell class] forCellReuseIdentifier:@"GXConsultantReplyCell"];
    [self.tableView registerClass:[GXConsultantAskCell class] forCellReuseIdentifier:@"GXConsultantAskCell"];
    if ([GXUserInfoTool isConnectToNetwork]) {
        [self setRefreshStyle];
    }else{
        [self showErrorNetMsg:@"" withView:self.tableView];
    }
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cellImagesDidClick:) name:GXPicturesViewDidClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(baseCellWithYYLabelDidClick:) name:GXBaseCellWithYYLabelDidClick object:nil];
}
- (void)dealloc{
    [self.readSuggestionsDict writeToFile:self.filePath atomically:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GXPicturesViewDidClick object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:GXBaseCellWithYYLabelDidClick object:nil];
}
#pragma mark - GXBaseCellWithYYLabelDidClick
- (void)baseCellWithYYLabelDidClick:(NSNotification *)notify{
    NSURL *url = notify.userInfo[@"url"];
    GXDetailWebController *detaiWC = [[GXDetailWebController alloc] init];
    detaiWC.url = url;
    [self.navigationController pushViewController:detaiWC animated:YES];
}
#pragma mark - GXPicturesViewDidClick
- (void)cellImagesDidClick:(NSNotification *)notify{
    NSDictionary *dict = notify.userInfo;
    UIView *sourceView = (UIView *)dict[@"cell"];
    NSArray *imagesUrls = (NSArray *)dict[@"imagesUrls"];
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:imagesUrls.count];
    for (int i =0; i < imagesUrls.count; i++) {
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        NSString *urlStr = [[imagesUrls objectAtIndex:i] objectForKey:@"Img"];
        NSURL *url = [NSURL URLWithString:urlStr];
        item.largeImageURL = url;
        [items addObject:item];
    }
    
    YYPhotoBrowseView *groupView = [[YYPhotoBrowseView alloc]initWithGroupItems:items];
    [groupView presentFromImageView:sourceView toContainer:self.navigationController.view animated:YES completion:nil];
}

- (void)initialParameters{
    self.consultantReplyModels = [NSMutableArray array];
    self.page = 10;
    self.endId = @"0";
    self.firstId = @"0";
}
#pragma mark --- 添加MJ刷新

- (void)setRefreshStyle{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshFirstData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMoreData)];
}

#pragma mark --- 刷新方法
- (void)refreshFirstData{
    self.isLater = @"1";
    self.startId = self.firstId;
    [self loadData];
}
- (void)refreshMoreData{
    self.isLater = @"0";
    self.startId = self.endId;
    [self loadData];
}

- (void)loadData{
    NSDictionary * parameter = @{@"type":@"2",@"count":@(self.page),@"isLater":self.isLater,@"startId":self.startId};
    __weak typeof(self) weakSelf = self;
    [GXHttpTool POSTCache:GXUrl_myMessage parameters:parameter success:^(id responseObject) {
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            NSMutableArray *newModels = [GXConsultantReplyModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
            if (newModels.count == 0) {
                [self showEmptyMsg:@"当前没有顾问回复内容" dataSourceCount:newModels.count superView:self.tableView];
            }
            //当前面或者后面没有数据时,会返回空数组,所以需要判断newModels.count
            if (newModels.count > 0 && [self.isLater integerValue]) {
                [self.consultantReplyModels insertArray:newModels atIndex:0];
            }else if(newModels.count > 0){
                [self.consultantReplyModels addObjectsFromArray:newModels];
            }
            self.formerModels = newModels;
            if (self.consultantReplyModels.count > 0) {
                GXConsultantReplyModel *firstConsultModel = [self.consultantReplyModels firstObject];
                self.firstId = firstConsultModel.ID;
                GXConsultantReplyModel *endConsultModel = [self.consultantReplyModels lastObject];
                self.endId = endConsultModel.ID;
            }
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            //[self showEmptyMsg:@"当前没有顾问回复内容" dataSourceCount:self.consultantReplyModels.count];
        } else{
            [self showErrorNetMsg:responseObject[@"message"] withView:self.tableView];
        }
    } failure:^(NSError *error) {
        [self showErrorNetMsg:@"" withView:self.tableView];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self.consultantReplyModels removeAllObjects];
}
#pragma mark -  UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.consultantReplyModels.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    GXConsultantReplyModel *replayModel = self.consultantReplyModels[section];
    if (replayModel.AskerList.count == 0) {
        return 2;
    }else{
        return replayModel.AskerList.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXConsultantReplyCell *cell;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"GXConsultantReplyCell" forIndexPath:indexPath];
        cell.tag = indexPath.row;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"GXConsultantAskCell" forIndexPath:indexPath];
        cell.tag = indexPath.row;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    GXConsultantReplyModel *replayModel = self.consultantReplyModels[indexPath.section];
    if (self.readSuggestionsDict[replayModel.ID]) {
        replayModel.isRead = YES;
    }else{
        self.readSuggestionsDict[replayModel.ID] = @(YES);
    }
    cell.consultantReplyModel = replayModel;
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
@end
