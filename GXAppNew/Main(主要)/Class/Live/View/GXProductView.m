//
//  GXProductView.m
//  GXAppNew
//
//  Created by zhudong on 2017/1/12.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXProductView.h"
#import "GXLiveCommonSize.h"
#import "GXProductCell.h"
#import "PriceMarketModel.h"
#import "UIView+GXNetError.h"

@interface GXProductView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *productCodes;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) BOOL isRefresh;
@end

@implementation GXProductView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        [self.tableView.mj_header beginRefreshing];
        self.backgroundColor = GXRGBColor(46, 45, 61);
        [self timer];
    }
    return self;
}

- (void)loadData{
    if (self.isRefresh) {
        return;
    }
    self.isRefresh = true;
    NSDictionary *param = @{@"code":[self.productCodes componentsJoinedByString:@","]};
    [GXHttpTool POST:GXUrl_quotation parameters:param success:^(id responseObject) {
        self.isRefresh = false;
        [self.tableView.mj_header endRefreshing];
        if ([responseObject[@"success"] integerValue] == 0) {
            return ;
        }
        self.dataSource = [PriceMarketModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
        [self.tableView reloadData];
        [self showEmptyMsg:nil dataSourceCount:self.dataSource.count];
        
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showErrorNetMsg:nil];
        GXLog(@"%@", error);
    }];
}

- (void)setupUI{
    UIView * topV = [[UIView alloc] init];
    self.topView = topV;
    topV.backgroundColor = GXRGBColor(46, 45, 61);
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [topV addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topV);
        make.width.height.equalTo(@(TopViewHeight / 2));
        make.right.equalTo(topV).offset(-GXMargin);
    }];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titlelabel = [[UILabel alloc] init];
    titlelabel.textColor = [UIColor whiteColor];
    titlelabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize13);
    titlelabel.text = @"行情";
    [topV addSubview:titlelabel];
    [titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topV);
        make.centerX.equalTo(topV);
        make.height.equalTo(@(TopViewHeight / 2));
    }];
    
    CALayer *topL = [[CALayer alloc] init];
    topL.frame = CGRectMake(0, TopViewHeight / 2, GXScreenWidth, 0.5);
    topL.backgroundColor = [GXRGBColor(40, 40, 54) CGColor];
    CALayer *botL = [[CALayer alloc] init];
    botL.frame = CGRectMake(0, TopViewHeight , GXScreenWidth, 0.5);
    botL.backgroundColor = [GXRGBColor(40, 40, 54) CGColor];

    [self.topView.layer addSublayer:topL];
    [self.topView.layer addSublayer:botL];
    
    NSArray *titleArray = @[@"交易品种", @"最新价", @"涨跌幅"];
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addTitle:obj index:idx];
    }];
    
    [self addSubview: topV];
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@(TopViewHeight));
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = GXRGBColor(46, 45, 61);
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.top.equalTo(self.topView.mas_bottom).offset(1);
    }];
}


- (void)addTitle: (NSString *)title index: (NSInteger)index {
    UILabel *label = [[UILabel alloc] init];
    label.font = GXFONT_PingFangSC_Regular(GXFitFontSize13);
    label.textColor = GXRGBColor(92, 99, 130);
    label.text = title;
    
    [self.topView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.height.equalTo(@(TopViewHeight / 2));
        switch (index) {
            case 0:
                make.left.equalTo(@(2 * GXMargin));
                label.textAlignment = NSTextAlignmentLeft;
                break;
            case 1:
                make.centerX.equalTo(self.topView);
                label.textAlignment = NSTextAlignmentCenter;
                break;
            default:
                make.centerX.equalTo(self.topView.mas_right).offset((-TopViewLeftOffset));
                label.textAlignment = NSTextAlignmentCenter;
                break;
        }
    }];
}
- (void)btnClick:(UIButton *)btn{
    [self.timer invalidate];
    self.timer = nil;
    if (self.productDelegate) {
        typeof(self) weakSelf = self;
        self.productDelegate(weakSelf);
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GXProductCell *proCell = [tableView dequeueReusableCellWithIdentifier:@"GXProductCell"];
    if (!proCell) {
        proCell = [[GXProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GXProductCell"];
    }
    proCell.contentView.backgroundColor = GXRGBColor(46, 45, 61);
    PriceMarketModel  *model = self.dataSource[indexPath.row];
    proCell.model = model;
    proCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return proCell;
}

- (NSArray *)productCodes{
    if (!_productCodes) {
        _productCodes = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"GXProductCodes.plist" ofType:nil]];
    }
    return _productCodes;
}

- (NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(loadData) userInfo:nil repeats:YES];
    }
    return _timer;
}
@end
