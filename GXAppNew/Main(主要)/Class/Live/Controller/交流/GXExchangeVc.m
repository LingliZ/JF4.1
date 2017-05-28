//
//  GXExchangeVc.m
//  GXAppNew
//
//  Created by maliang on 2016/11/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXExchangeVc.h"
#import "GXExchangeModel.h"
#import "GXExchangeCell.h"
#import "GXLiveCommonSize.h"
#import "GXAskView.h"
#import <YYText/YYText.h>
#import "UIViewController+NetErrorTips.h"

@interface GXExchangeVc ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger selectedIndex;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<GXExchangeModel *> *dataSource;
@property (nonatomic, strong) GXAskView *askView;
@property (nonatomic, strong) GXTextView *textView;
@property (nonatomic, strong) GXExchangeModel *selectedModel;
@property (nonatomic, assign) BOOL isShowedTip;
@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation GXExchangeVc

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(currentPageNotify:) name:CurrentPageNotify object:nil];
    [self createUI];
    topId = @"0";
    endId = @"0";
    isMore = @"1";
    [self.tableView.mj_header beginRefreshing];
}

- (void)currentPageNotify: (NSNotification *)notify{
    NSDictionary *dict = notify.object;
    if ([dict[@"page"] integerValue] == 2) {
        [[NSNotificationCenter defaultCenter] addObserver:self.askView selector:@selector(inserEmoji:) name:EmojiBtnNotifyName object:nil];
    }else{
        [[NSNotificationCenter defaultCenter] removeObserver:self.askView name:EmojiBtnNotifyName object:nil];
    }
}

- (void)loadFormerData
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

- (void)loadData
{
    NSDictionary *parameter = @{@"type":@"3",@"count":count,@"isLater":isLater,@"startId":startId,@"roomId":self.liveRoomID,@"isMore":isMore};
    __weak typeof(self) weakSelf = self;
    [GXHttpTool POST:GXUrl_getData parameters:parameter success:^(id responseObject) {
        __strong typeof(self) strongSelf = weakSelf;
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if ([responseObject[@"success"] integerValue] == 1) {
            
            NSArray *array = responseObject[@"value"];
            if (array.count > 0) {
                if ([isMore isEqualToString:@"1"]) {
                    
                    [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        [self.dataSource addObject:[GXExchangeModel exchangeModel:obj]];
                    }];
                }else{
                    if ([startId integerValue] == 0) {
                        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [self.dataSource addObject:[GXExchangeModel exchangeModel:obj]];
                        }];
                    }else{
                        [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            [self.dataSource insertObject:[GXExchangeModel exchangeModel:obj] atIndex:0];
                        }];
                    }
                }
                topId = self.dataSource.firstObject.idNew;
                endId = self.dataSource.lastObject.idNew;
                [self.tableView reloadData];
            }
        }
        [self showEmptyMsg:nil dataSourceCount:self.dataSource.count superView:self.tableView];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self showErrorNetMsg:nil withView:self.tableView];
    }];
}
#pragma mark - createUI
- (void)createUI
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadFormerData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    
     self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    self.tableView.backgroundColor = GXAdviserBGColor;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction)];
    
    [self.tableView addGestureRecognizer:tapGes];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.bottom.equalTo(@(-KeyBoardHeight));
    }];
    //添加键盘
    GXAskView *askV = [[GXAskView alloc] init];
    [askV setTextFieldColor:[UIColor whiteColor]];
    self.askView = askV;
    typeof(self) weakSelf = self;
    askV.sendBtnClickDelegate = ^ void (NSString *contentStr) {
        [weakSelf sendMsg:contentStr];
    };
    [self.view addSubview:askV];
    self.textView = askV.textField;
    [askV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@(KeyBoardHeight));
    }];
}
#pragma mark --- 点击发送 ---
- (void)sendMsg:(NSString *)contentStr
{
    NSString *content = self.textView.fullText;
    if (content.length > 0) {
        if ([content hasPrefix:@"@"] && [content containsString:@" "]) {
            NSRange range = [content rangeOfString:@" "] ;
            content = [content substringFromIndex:(range.location + range.length)];
        }else{
            selectedIndex = -1;
        }
        NSMutableDictionary *paramQ = [[NSMutableDictionary alloc] init];
        paramQ[@"userType"] = @(1);
        paramQ[@"roomId"] = self.liveRoomID;
        paramQ[@"content"] = content;
        paramQ[@"roomType"] = @(1);
        if (selectedIndex <= 0) {
            paramQ[@"replyTo"] = @(0);
        }else{
            GXExchangeModel *selectedQ = self.dataSource[selectedIndex];
            paramQ[@"replyTo"] = selectedQ.id;
            paramQ[@"visitorName"] = selectedQ.nickName;
        }
        
        selectedIndex = -1;
        if (self.textView.isFullEmot) {
            //不审核
            paramQ[@"avoidAudit"] = @(1);
        }else{
            //审核
            paramQ[@"avoidAudit"] = @(0);
        }

        __weak typeof(self) weakSelf = self;
        [GXHttpTool POST:GXUrl_liveSpeakQ parameters:paramQ success:^(id responseObject) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            NSDictionary *dict = responseObject;
            if ([dict[@"success"] integerValue] == 1) {
                [strongSelf showMsg:@"发送消息成功"];
            }else{
                NSInteger errorCode = [dict[@"errCode"] integerValue];
                if (errorCode == 10100 || errorCode == 10375) {
                    [strongSelf showMsg:dict[@"message"]];
                }
            }
        } failure:^(NSError *error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf showMsg: @"信息发送不成功,网络连接失败"];
        }];
        self.textView.text = nil;
        [self.textView endEditing:YES];
    }else{
        UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
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
    self.tipLabel = label;
    
    [self.view addSubview:label];
    [self.view bringSubviewToFront:label];
    self.isShowedTip = true;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.bottom.equalTo(self.askView.mas_top).offset(-2*GXMargin);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tipLabel removeFromSuperview];
        self.isShowedTip = false;
    });
}

- (void)tapGesAction{
    [self.view endEditing:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.dataSource.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"exchangeCell";
    GXExchangeModel *exchangeModel = self.dataSource[indexPath.row];
    GXExchangeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GXExchangeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //给nameL添加手势
    cell.nameLable.tag = indexPath.row;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nameLClicked:)];
    [cell.nameLable addGestureRecognizer:tap];
    cell.model = exchangeModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//手势方法实现
- (void)nameLClicked:(UITapGestureRecognizer *)sender
{
    YYLabel *lable = (YYLabel *)sender.view;
    selectedIndex = lable.tag;
    if (selectedIndex < self.dataSource.count) {
        GXExchangeModel *exModel = self.dataSource[selectedIndex];
        self.textView.text = [NSString stringWithFormat:@"@%@ ", exModel.nickName];
    }
    [self.textView becomeFirstResponder];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}
@end
