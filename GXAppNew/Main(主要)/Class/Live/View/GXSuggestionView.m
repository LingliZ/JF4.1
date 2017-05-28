//
//  GXSuggestionView.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/1.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXSuggestionView.h"
#import "GXSuggestionCell.h"
#import "GXLiveCommonSize.h"
#import "MBProgressHUD.h"
#import "GXSuggestionModel.h"
#import "PriceMarketModel.h"
#import "NSDateFormatter+GXDateFormatter.h"
#import "UIView+GXNetError.h"
#import "GXSugHeaderCell.h"
#import "GXSugSingleCell.h"
#import "GXSugDoubleCell.h"
#import "GXSugFooterCell.h"

@interface GXSuggestionView ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSNumber *roomId;
@property (nonatomic, strong) NSNumber *startID;
@property (nonatomic,strong) NSArray *dataSource;
@end
@implementation GXSuggestionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
        [self.tableView registerNib:[UINib nibWithNibName:@"GXSugHeaderCell" bundle:nil] forCellReuseIdentifier:@"GXSugHeaderCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"GXSugSingleCell" bundle:nil] forCellReuseIdentifier:@"GXSugSingleCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"GXSugDoubleCell" bundle:nil] forCellReuseIdentifier:@"GXSugDoubleCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"GXSugFooterCell" bundle:nil] forCellReuseIdentifier:@"GXSugFooterCellOne"];
        self.tableView.estimatedRowHeight = 100;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.roomId = [GXUserdefult objectForKey:GXVideoRoomId];
        self.startID = @0;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
        [self.tableView.mj_header beginRefreshing];
    }
    return self;
}

- (void)loadData{
    NSDictionary *params = @{@"type":@8,@"roomId":self.roomId,@"startId":self.startID,@"count":@20,@"isMore":@0};
    [GXHttpTool POSTCache:GXUrl_liveCall parameters:params success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if ([responseObject[@"success"] intValue] == 0) return ;
            NSArray *array = responseObject[@"value"][@"resultList"];
            NSMutableArray *arrM = [NSMutableArray new];
            for (NSDictionary *dict in array) {
                GXSuggestionModel *model = [[GXSuggestionModel alloc] initWithDict:dict];
                [arrM addObject:model];
            }
            self.dataSource = arrM;
            [self loadPriceData];

    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        GXLog(@"%@",error);
        [self showErrorNetMsg:nil];
    }];

}


//取行情接口
- (void)loadPriceData
{
    NSMutableArray *codeArr = [[NSMutableArray alloc] init];
    for (GXSuggestionModel *model in self.dataSource) {
        [codeArr addObject:model.varietiesCode];
    }
    NSString *codeStr = [codeArr componentsJoinedByString:@","];
    NSDictionary *parameters = @{@"code":codeStr};
    [GXHttpTool POST:GXUrl_quotation parameters:parameters success:^(id responseObject) {
        if ([responseObject[GXSuccess] integerValue] != 1) return ;
        NSArray *valueArr = responseObject[GXValue];
        NSMutableArray *arrM = [PriceMarketModel mj_objectArrayWithKeyValuesArray:valueArr];
        for (NSInteger i = 0; i < valueArr.count; i++) {
            GXSuggestionModel *model = self.dataSource[i];
            model.sell = [(PriceMarketModel *)arrM[i] sell];
            model.buy = [(PriceMarketModel *)arrM[i] buy];
        }
        [self.tableView reloadData];
        [self showEmptyMsg:nil dataSourceCount:self.dataSource.count];
    } failure:^(NSError *error) {
        [self showErrorNetMsg:nil];
    }];
}


- (void)setupUI{
    self.backgroundColor = [UIColor blackColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = @"即时建议";
    label.textColor = [UIColor whiteColor];
    label.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:label];
    
    UIButton *leaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leaveBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [self addSubview:leaveBtn];
    [leaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.width.height.equalTo(@(TopViewHeight / 2));
        make.right.equalTo(self).offset(-GXMargin);
    }];
    
    [leaveBtn addTarget:self action:@selector(suggestionLeaveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self);
        make.height.equalTo(@(TopViewHeight / 2));
    }];
    
    UIView *topV = [[UIView alloc] init];
    self.topView = topV;
    topV.backgroundColor = GXRGBColor(46, 45, 61);
    [self addSubview:topV];
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).offset(TopViewHeight / 2);
        make.height.equalTo(@(TopViewHeight / 2));
    }];
    
    NSArray *titlesArray = @[@"操作建议", @"发布日期", @"品种", @"发布人"];
    
    [self addTitleLabel:titlesArray[0] leftCenterMargin:WidthScale_IOS6(40)];
    [self addTitleLabel:titlesArray[1] leftCenterMargin:WidthScale_IOS6(140)];
    [self addTitleLabel:titlesArray[2] leftCenterMargin:WidthScale_IOS6(220)];
    [self addTitleLabel:titlesArray[3] leftCenterMargin:WidthScale_IOS6(300)];
    
    UITableView *tableV = [[UITableView alloc] init];
    self.tableView = tableV;
    [self addSubview:tableV];
    [tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.top.equalTo(topV.mas_bottom);
    }];
    
    tableV.dataSource = self;
    tableV.delegate = self;
    tableV.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    footerV.backgroundColor = BackgroundColor;
    tableV.tableFooterView = footerV;
    tableV.backgroundColor = BackgroundColor;
}

- (void)suggestionLeaveBtnClick{
    if (self.suggestionDelegate) {
        self.suggestionDelegate(self);
    }
}

- (void)addTitleLabel: (NSString *)title leftCenterMargin: (NSInteger)margin{
    UILabel *operationL = [[UILabel alloc] init];
    operationL.text = title;
    operationL.textColor = GXRGBColor(92, 99, 130);
    operationL.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    
    [self.topView addSubview:operationL];
    [operationL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView);
        make.centerX.equalTo(self.topView.mas_left).offset(margin);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    GXSuggestionModel *suggetionM = self.dataSource[section];
    if (suggetionM.isOpen) {
        return suggetionM.operationItems.count + 3;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *tCell;
    GXSuggestionModel *suggetionM = self.dataSource[indexPath.section];
    
    if (indexPath.row == 0) {
        GXSuggestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GXSuggestionCell"];
        if (!cell) {
            cell = [[GXSuggestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GXSuggestionCell"];
        }

        cell.suggestionModel = suggetionM;
        if (!suggetionM.isOpen) {
            cell.iconBtn.transform = CGAffineTransformIdentity;
        }else{
            cell.iconBtn.transform = CGAffineTransformMakeRotation(M_PI);
        }

        tCell = cell;
    }else{
        
        UITableViewCell *cell;
        GXOperationItemModel *operationModel;
        if ((indexPath.row - 2) < suggetionM.operationItems.count) {
            operationModel = suggetionM.operationItems[indexPath.row - 2];
        }
        if (indexPath.row == 1) {
            GXSugHeaderCell *sugHC = [tableView dequeueReusableCellWithIdentifier:@"GXSugHeaderCell" forIndexPath:indexPath];
            sugHC.suggestModel = suggetionM;
            cell = sugHC;
        }else if(indexPath.row == suggetionM.operationItems.count + 2){
            GXSugFooterCell *sugFC = [tableView dequeueReusableCellWithIdentifier:@"GXSugFooterCellOne" forIndexPath:indexPath];
            sugFC.suggestionModel = suggetionM;
            cell = sugFC;
        }else if([operationModel.types integerValue] == 1 || operationModel.isDouble){
            GXSugDoubleCell *topDoubleCell = [tableView dequeueReusableCellWithIdentifier:@"GXSugDoubleCell" forIndexPath:indexPath];
            topDoubleCell.operateModel = operationModel;
            cell = topDoubleCell;
        }else {
            GXSugSingleCell *singleCell = [tableView dequeueReusableCellWithIdentifier:@"GXSugSingleCell" forIndexPath:indexPath];
            singleCell.operateModel = operationModel;
            cell = singleCell;
        }
        tCell = cell;
    }
    tCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section % 2) {
        case 0:
            tCell.contentView.backgroundColor = GXRGBColor(55, 54, 72);
            break;
        default:
            tCell.contentView.backgroundColor = GXRGBColor(46, 45, 61);
            break;
    }

    return tCell;
}

- (void)arrowBtnClick: (GXSuggestionModel *)suggestionM withIndex: (NSInteger)section{
    suggestionM.isOpen = !suggestionM.isOpen;
    [self.tableView reloadData];
    NSIndexSet *inSet = [NSIndexSet indexSetWithIndex:section];
    [self.tableView reloadSections:inSet withRowAnimation: UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:false];
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag == 10) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GXOpenRealAccountNotify object:nil];
        }else if(alertView.tag == -1){
            
        }else{
            NSDictionary *dict = @{@"eventName":@"video_login"};
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginNotify object:nil userInfo:dict];
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    GXSuggestionModel *suggestionModel = self.dataSource[indexPath.section];
    if ([GXUserInfoTool isLogin]) {
        if ([[GXUserdefult objectForKey:GXIsRealCustom] integerValue] == YES) {
            //实盘
            [self arrowBtnClick:suggestionModel withIndex: indexPath.section];
        }else{
            //非实盘
            if ([GXUserInfoTool isShowOpenAccount]) {
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲爱的用户, 您还未开立实盘账户, 请开立实盘账户后再操作"  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即开户", nil];
                alertV.tag = 10;
                [alertV show];
            }else{
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲爱的用户, 您还未开立实盘账户"  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                alertV.tag = -1;
                [alertV show];

            }
        }
    }else{
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲爱的用户, 您还未登录, 请登录后再操作"  delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即登录", nil];
        alertV.tag = 20;
        [alertV show];
        
    }
}

@end

