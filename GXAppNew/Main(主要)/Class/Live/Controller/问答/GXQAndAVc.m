//
//  GXQAndAVc.m
//  GXAppNew
//
//  Created by maliang on 2016/11/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXQAndAVc.h"
#import "GXQAndAUpCell.h"
#import "GXQAndADownCell.h"
#import "GXQAndAModel.h"
#import "GXLiveCommonSize.h"
#import <YYText/YYText.h>
#import "GXLiveCommonSize.h"
#import "GXAskView.h"
#import "GXLiveController.h"
#import "GXAddCountIndexController.h"
#import "GXUserInfoTool.h"
#import "GXLoginByVertyViewController.h"
#import "UIViewController+NetErrorTips.h"

@interface GXQAndAVc ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UIButton *selectedBtn;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray<GXQAndAModel *> *dataSource;
@property (nonatomic, strong)NSString *leftIndex;
@property (nonatomic, strong)GXAskView *askView;
@property (nonatomic, assign)BOOL isShowedTip;
@property (nonatomic, strong)UILabel *tipLable;

@end

@implementation GXQAndAVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentPageNotify:) name:CurrentPageNotify object:nil];
    [self createUI];
    [self refreshData];
    topId=@"0";
    endId=@"0";
    isMore = @"0";
    self.leftIndex = @"";
}

- (void)currentPageNotify: (NSNotification *)notify{
    NSDictionary *dict = notify.object;
    if ([dict[@"page"] integerValue] == 1) {
        [[NSNotificationCenter defaultCenter] addObserver:self.askView selector:@selector(inserEmoji:) name:EmojiBtnNotifyName object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self.askView name:EmojiBtnNotifyName object:nil];
    }
}

- (void)createUI
{
    self.view.backgroundColor = GXAdviserBGColor;
    UIView *headerV = [[UIView alloc] init];
    headerV.backgroundColor=[UIColor clearColor];
    NSArray *topArr = @[@"全部",@"白银",@"铂钯",@"铜铝镍",@"现货重油"];
    
    CGFloat btnW = (GXScreenWidth - 2 * GXMargin) / topArr.count;
    [topArr enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger i, BOOL * _Nonnull stop) {
        UIButton *topButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [topButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topButton setTitle:obj forState:UIControlStateNormal];
        topButton.titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
        [topButton setTitleColor:GXRGBColor(101, 106, 137) forState:UIControlStateNormal];
        [topButton setTitleColor:GXRGBColor(64, 130, 244) forState:UIControlStateSelected];
        topButton.tag = 100 + i;

        [headerV addSubview:topButton];
        [topButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(@0);
            make.left.equalTo(@(btnW * i));
            make.width.equalTo(@(btnW));
        }];
        [topButton setBackgroundImage:[UIImage imageNamed:@"liveroomTwoBar2"] forState:UIControlStateNormal];
        
        [topButton setBackgroundImage:[UIImage imageNamed:@"liveroomTwoBar5"] forState:UIControlStateSelected];
        if(i == 4)
        {
            [topButton setBackgroundImage:[UIImage imageNamed:@"liveroomTwoBar6"] forState:UIControlStateNormal];
             [topButton setBackgroundImage:[UIImage imageNamed:@"liveroomTwoBar4"] forState:UIControlStateSelected];
        }
        if (i == 0) {
            self.selectedBtn = topButton;
            self.selectedBtn.selected = true;
        }
        
    }];
    
    [self.view addSubview:headerV];
    [headerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(GXMargin));
        make.top.equalTo(@GXMargin);
        make.right.equalTo(@(-GXMargin));
        make.height.equalTo(@(60));
    }];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 300) style:UITableViewStylePlain];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setShowsVerticalScrollIndicator:NO];
    self.tableView.backgroundColor = GXAdviserBGColor;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFirstData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction)];
    
    [self.tableView addGestureRecognizer:tapGes];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerV.mas_bottom).offset(GXMargin * 0.5);
        make.left.equalTo(self.view).offset(GXMargin);
        make.right.equalTo(self.view).offset(-GXMargin);
        make.bottom.equalTo(self.view).offset(-KeyBoardHeight);
    }];
    //添加键盘
    GXAskView *askV = [[GXAskView alloc] init];
    [askV setTextFieldColor:[UIColor whiteColor]];
    typeof(self) weakSelf = self;
    askV.sendBtnClickDelegate = ^ void (NSString *contentStr){
        [weakSelf sendMsg:contentStr];
    };
    [self.view addSubview:askV];
    self.askView = askV;
    [askV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@(KeyBoardHeight));
    }];
}
#pragma mark --- 点击发送 ---
- (void)sendMsg:(NSString *)contentStr
{
    if (contentStr.length > 0) {
        [self.view endEditing:true];
        NSMutableDictionary *parameter = [[NSMutableDictionary alloc] init];
        parameter[@"Content"] = contentStr;
        parameter[@"RoomID"] = self.liveRoomID;
        __weak typeof(self) weakSelf = self;
        [GXHttpTool POST:GXUrl_ask parameters:parameter success:^(id responseObject) {
            __strong typeof(self) strongSelf = weakSelf;
            if ([responseObject[GXSuccess] integerValue] == 1) {
                GXLog(@"发送成功");
                [strongSelf showMsg:@"发送消息成功"];
            }else{
                if ([responseObject[@"errCode"] integerValue] == 10361) {
                    
                    [strongSelf.view endEditing:YES];
                    
                    if ([GXUserInfoTool isShowOpenAccount]) {
                        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲爱的用户,您还没有开立实盘账号,请开立实盘后再进行提问!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即开户", nil];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alertV show];
                        });
                        alertV.tag = 100;
                    } else {
                        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲爱的用户,您还没有开立实盘账号,请开立实盘后再进行提问!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [alertV show];
                        });
                        alertV.tag = 100;
                    }
                    
                    
                }
                else if ([responseObject[@"errCode"] integerValue] == 10362) {
                    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲爱的用户,您今天的一次提问机会已经用完,绑定播间即可无限次提问哦。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即绑定", nil];
                    alertV.tag = 101;
                    [alertV show];
                }else if ([responseObject[@"errCode"] integerValue] == 10364){
                    NSString *msg = responseObject[@"message"];
                    [strongSelf showMsg: msg];
                }
                else if ([responseObject[@"errCode"] integerValue] == 10100){
                    NSString *msg = responseObject[@"message"];
                    [strongSelf showMsg: msg];
                }
            }
        } failure:^(NSError *error) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf showMsg:@"信息发送不成功,网络连接失败"];
            GXLog(@"%@", error);
        }];
    } else {
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您输入内容再点击发送按钮" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertV show];
    }
}

- (void)showMsg: (NSString *)msg{
    if (self.isShowedTip) {
        return;
    }
    UILabel *label = [[UILabel alloc] init];
    label.text = msg;
    label.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    label.textColor = [UIColor whiteColor];
    [label sizeToFit];
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
    layer.frame = CGRectMake(-10, -10, label.size.width + 20, label.size.height + 20);
    layer.cornerRadius = 15;
    [label.layer addSublayer:layer];
    layer.masksToBounds = true;
    self.tipLable = label;
    
    [self.view addSubview:label];
    [self.view bringSubviewToFront:label];
    self.isShowedTip = true;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.bottom.equalTo(self.askView.mas_top).offset(-2*GXMargin);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tipLable removeFromSuperview];
        self.isShowedTip = false;
    });
}
//alertV代理方法实现
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            if (![GXUserInfoTool isLogin]) {
                [MobClick event:@"home_quickness_login"];
                GXLoginByVertyViewController *loginVc = [[GXLoginByVertyViewController alloc] init];
                [self.navigationController pushViewController:loginVc animated:YES];
                return;
            }
            if ([GXUserInfoTool isShowOpenAccount]) {
                
                GXAddCountIndexController *addCountVc = [[GXAddCountIndexController alloc] init];
                [self.navigationController pushViewController:addCountVc animated:YES];
            } else {
                return;
            }
        }
    } else if (alertView.tag == 101) {
        if (buttonIndex == 1) {
            [MobClick event:@"counselor_set"];
            [self bindRoom];
        }
    }
}
#pragma mark - 绑定播间
- (void)bindRoom
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    parameters[@"roomId"] = self.liveRoomID;
        [GXHttpTool POST:GXUrl_select_room parameters:parameters success:^(id responseObject) {
            if ([responseObject[@"success"] integerValue] == 0) {
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:responseObject[@"message"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertV show];
            }
        } failure:^(NSError *error) {
            
        }];
}

- (void)tapGesAction{
    [self.view endEditing:true];
}

- (void)refreshData
{
    [self.tableView.mj_header beginRefreshing];
}
- (void)loadFirstData
{
    if ([topId isEqualToString:@"0"]) {
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
    [self loadMoreDateFromDown];
}

- (void)loadData
{
    NSDictionary *parameters = @{@"type":@"2",@"count":count,@"isLater":isLater,@"startId":startId,@"roomId":self.liveRoomID,@"isMore":isMore,@"leftIndex":self.leftIndex};

    [GXHttpTool POST:GXUrl_getData parameters:parameters success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"success"] integerValue] == 1) {
            
            [self.dataSource removeAllObjects];
            NSArray *array = responseObject[@"value"];
            if (array.count > 0) {
                [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.dataSource addObject:[GXQAndAModel qAndAModel:obj]];
                }];
                endId = self.dataSource.lastObject.idNew;
            }
            [self.tableView reloadData];
        }
        [self showEmptyMsg:nil dataSourceCount:self.dataSource.count superView:self.tableView];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showErrorNetMsg:nil withView:self.tableView];
    }];
}
#pragma mark - 处理上拉加载会移除所有数据的问题
- (void)loadMoreDateFromDown
{
    NSDictionary *parameters = @{@"type":@"2",@"count":count,@"isLater":isLater,@"startId":startId,@"roomId":self.liveRoomID,@"isMore":isMore,@"leftIndex":self.leftIndex};
    
    [GXHttpTool POST:GXUrl_getData parameters:parameters success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"success"] integerValue] == 1) {
            NSArray *array = responseObject[@"value"];
            if (array.count > 0) {
                [self.dataSource removeAllObjects];
                [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.dataSource addObject:[GXQAndAModel qAndAModel:obj]];
                }];
                endId = self.dataSource.lastObject.idNew;
            }
            [self.tableView reloadData];
        }
        [self showEmptyMsg:nil dataSourceCount:self.dataSource.count superView:self.tableView];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showErrorNetMsg:nil withView:self.tableView];
    }];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    GXQAndAModel * qAModel = self.dataSource[section];
    return qAModel.askerListArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXQAndAModel *model = self.dataSource[indexPath.section];
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        GXQAndAUpCell *teacherCell = [[GXQAndAUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"teacherCell"];
        cell = teacherCell;
        cell.tag = 0;
        teacherCell.model = model;
    } else {
        GXAskModel *askModel = model.askerListArray[(indexPath.row - 1)];
        GXQandADownCell *userCell = [[GXQandADownCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"userCell"];
        cell = userCell;
        
        if (indexPath.row == model.askerListArray.count) {
            cell.tag = -2;//最后一个
        }else{
            cell.tag = -1;//其余
        }
        userCell.model = askModel;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)btnClick:(UIButton *)btn
{
    self.selectedBtn.selected = NO;
    btn.selected = YES;
    self.selectedBtn = btn;
    switch (btn.tag) {
        case 100:
            self.leftIndex = @"";
            [MobClick event:@"all"];
            break;
        case 101:
            self.leftIndex = @"1";
            [MobClick event:@"Ag"];
            break;
        case 102:
            self.leftIndex = @"2";
            [MobClick event:@"Pd"];
            break;
        case 103:
            self.leftIndex = @"3";
            [MobClick event:@"Cu_AL_Ni"];
            break;
        case 104:
            self.leftIndex = @"4";
            [MobClick event:@"oil"];
            break;
            
        default:
            break;
    }
    [self loadData];
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
