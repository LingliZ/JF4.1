//
//  GXFirstViewController.m
//  GXApp
//
//  Created by GXJF on 16/7/8.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXFirstViewController.h"
#import "GXUIParameter.h"
#import "GXCalendarBaseModel.h"
#import "GXCalendarBaseModelCell.h"
#import "GXCalendarEventModelCell.h"
#import "GXCalendarDataModelCell.h"
//#import "GXAdaptiveHeightTool.h"

@interface GXFirstViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong)NSMutableArray *saveDataArray;
@property (nonatomic,strong)UITableView *tableView;

//更改交互的ScrollowView
@property (nonatomic,strong)UIScrollView *changeScrollowView;
@property (nonatomic,assign)BOOL isEnable;

@end

@implementation GXFirstViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeScrollow) name:@"homeNavigationChange" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeScrollowNO) name:@"homeNavigationChangeNO" object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"homeNavigationChange" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"homeNavigationChangeNO" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.saveDataArray = [NSMutableArray new];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = UIColorFromRGB(0xF8F8F8);
    
    self.tableView.estimatedRowHeight = 300;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self noFinanceClendar];
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"GXCalendarDataModelCell" bundle:nil] forCellReuseIdentifier:@"GXCalendarDataModel"];
    [self.tableView registerNib:[UINib nibWithNibName:@"GXCalendarEventModelCell" bundle:nil] forCellReuseIdentifier:@"GXCalendarEventModel"];
    //接收通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeScrollow) name:SonBeginScroll object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeScrollowNO) name:SonEndScroll object:nil];
    
}

- (void)changeScrollowNO{
    self.isEnable = false;
}

- (void)changeScrollow{
    self.isEnable = true;
}
//无财经数据和事件提示
-(void)noFinanceClendar{
    UIImageView *noDataView = [[UIImageView alloc]initWithFrame:CGRectMake((GXScreenWidth - 80) / 2, 80, 80, 80)];
    noDataView.image = [UIImage imageNamed:@"nodata_events"];
    UILabel *noDataLabel = [[UILabel alloc]initWithFrame:CGRectMake((GXScreenWidth - 200) / 2, noDataView.frame.size.height + noDataView.frame.origin.y + 30, 200, 30)];
    noDataLabel.textAlignment = NSTextAlignmentCenter;
    noDataLabel.text = @"今天无财经数据和事件";
    noDataLabel.textColor = UIColorFromRGB(0x9B9B9B);
    noDataLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize17);
    [self.view addSubview:noDataView];
    [self.view addSubview:noDataLabel];
}
//更新数据
- (void)refreshData{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshDataFromServer)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
}
- (void)refreshDataFromServer{
    [self loadFinanceCalendarDataFromServer:self.type];
}
//加载数据
- (void)loadFinanceCalendarDataFromServer:(NSInteger)type{
    [self.tableView showLoadingWithTitle:@"正在加载,请稍等"];
    //    #define GXUrl_finance @"/finance" //date时期格式yyyyMMdd
    NSDate*nowDate = [NSDate date];
    NSDate* theDate;
    if(type !=0 ){
        NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
        theDate = [nowDate initWithTimeIntervalSinceNow: oneDay*type ];//initWithTimeIntervalSinceNow是从现在往前后推的秒数
    }else{
        theDate = nowDate;
    }
    NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
    [date_formatter setDateFormat:@"yyyyMMdd"];
    NSString *the_date_str = [date_formatter stringFromDate:theDate];
    NSDictionary *parameter = @{@"date":the_date_str};
    [GXHttpTool POSTCache:GXUrl_finance parameters:parameter success:^(id responseObject) {
        NSMutableArray *mutableArray = responseObject[@"value"];
        if (mutableArray.count == 0) {
            [self.view showFailWithTitle:@"没有找到相应的日历或事件"];
            self.tableView.hidden = YES;
        }
        [self removeAllObjectsFromArray];
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1) {
            [self.tableView removeTipView];
            for (NSDictionary *valueDict in responseObject[@"value"]) {
                GXCalendarBaseModel *baseModel = [GXCalendarBaseModel modelWithDictionary:valueDict];
                [self.saveDataArray addObject:baseModel];
            }
        }
        [self.tableView reloadData];
        //[self showEmptyMsg:@"" dataSourceCount:self.saveDataArray.count superView:self.tableView];
        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showErrorNetMsg:nil withView:self.tableView];
    }];
}
- (void)removeAllObjectsFromArray{
    [self.saveDataArray removeAllObjects];
}
-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 64 - 140 - 49) style:UITableViewStylePlain];
    }return _tableView;
}


#pragma mark - UIScrollowViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetSetY = scrollView.contentOffset.y;
    if (offsetSetY <= 0) {
        scrollView.contentOffset = CGPointMake(0, 0);
        self.isEnable = false;
        [[NSNotificationCenter defaultCenter] postNotificationName:FatherBeginScroll object:nil];
    }
    
    if (!self.isEnable) {
        scrollView.contentOffset = CGPointMake(0, 0);
    }
    
}
#pragma mark ----- UITableViewDelegate -----
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.saveDataArray.count;
}
//cell设置
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXCalendarBaseModelCell *cell = [GXCalendarBaseModelCell cellWithTableView:tableView Model:self.saveDataArray[indexPath.row] IndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


@end
