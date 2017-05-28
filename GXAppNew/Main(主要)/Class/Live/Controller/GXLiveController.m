//
//  GXLiveController.m
//  GXAppNew
//
//  Created by futang yang on 2016/11/28.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXLiveController.h"
#import "GXLiveCastViewController.h"
#import "GXVideoCell.h"
#import "GXOrdinaryCell.h"
#import "GXVideoModel.h"
#import "GXLiveDetailViewController.h"
#import "GXLiveBaseModel.h"
#import "GXLoginByVertyViewController.h"
#import "GXUserInfoTool.h"
#import "GXPhotoBrowseController.h"
#import "UIViewController+NetErrorTips.h"
#import "GXMineController.h"
#import "GXBottomToastTitle.h"
#import "GXAddCountIndexController.h"
#import "GXAddAccountTool.h"

#define GXPicturesViewDidClick @"GXPicturesViewDidClick"

@interface GXLiveController () <UITableViewDelegate, UITableViewDataSource, GXBottomToastTitleDelegate>

@property (nonatomic, strong)NSMutableArray *dataSource;
@property (nonatomic, assign) BOOL isFullRooms;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong)UIImageView *homeMineUserView;
@property (nonatomic,strong)UIButton *homeMineBtn;
@property (nonatomic,strong)UILabel *seviceWarningLabel;
@property (nonatomic,strong)UILabel *messageWarningLabel;
//@property (nonatomic,strong)UIView *msgView1;
@property (nonatomic,strong)UIView *msgView2;

@property (nonatomic, strong) GXBottomToastTitle *bottomToastTitle;

@end

@implementation GXLiveController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    [self setHomeCutemerWarn];
    [self setHomeMsgWarning];
    [self isRealAccount];
    self.msgView2.hidden = NO;
    //添加客服观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setHomeCutemerWarn) name:GXOnlineServiceCountNotificationName object:nil];
    //添加主页消息观察者
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setHomeMsgCenterWarn:) name:GXHomeCountNotificationName object:nil];
}


- (void)isRealAccount {
    if ([GXUserInfoTool isLogin]) {
        [GXAddAccountTool isAddAccountSucess:^(BOOL addAccountResult) {
            if (addAccountResult) {
                self.bottomToastTitle.hidden = YES;
            } else {
                if ([GXUserInfoTool isShowOpenAccount]) {
                    
                    self.bottomToastTitle.hidden = NO;
                    [self.bottomToastTitle.openBtn setTitle:@"安全开户" forState: UIControlStateNormal];
                    self.bottomToastTitle.titleLabel.text = @"开立实盘账户后享受分析师服务 ";
                } else {
                    self.bottomToastTitle.hidden = YES;
                }
                
            }
        } Failure:^(NSError *error) {
            
        }];
    } else {
        if ([GXUserInfoTool isShowOpenAccount]) {
            self.bottomToastTitle.hidden = NO;
            [self.bottomToastTitle.openBtn setTitle:@"登录/注册" forState: UIControlStateNormal];
            self.bottomToastTitle.titleLabel.text = @"注册并立实盘账户后享受分析师服务";
        } else {
            self.bottomToastTitle.hidden = YES;
        }
        
    }
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.msgView2.hidden = YES;
}
-(void)setHomeMsgWarning{
    int msgCounts = [GXUserInfoTool getSuggestNum] + [GXUserInfoTool getReplyNum] + [GXUserInfoTool getAlarmNum];
    if (msgCounts > 0) {
        self.messageWarningLabel.hidden = NO;
        self.messageWarningLabel.text = [NSString stringWithFormat:@"%d",msgCounts];
    }else{
        self.messageWarningLabel.hidden = YES;
    }
}

- (void)setHomeCutemerWarn {
    NSInteger count = [GXUserInfoTool getCutomerNum];
    if (count > 0) {
        self.seviceWarningLabel.hidden = NO;
        self.seviceWarningLabel.text = [NSString stringWithFormat:@"%ld", [GXUserInfoTool getCutomerNum]];
    } else {
        self.seviceWarningLabel.hidden = YES;
    }
}
-(void)setHomeMsgCenterWarn:(NSNotification *)notification{
    NSNumber *numbers = notification.object;
    self.messageWarningLabel.hidden = NO;
    self.messageWarningLabel.text = [NSString stringWithFormat:@"%ld",numbers.integerValue];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatHomeNavigationMessageButton];
    [self redWarningLabel];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - 64) style:UITableViewStylePlain];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.bottomToastTitle.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = GXRGBColor(241, 242, 247);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showLargeImage:) name:GXPicturesViewDidClick object:nil];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomToastTitle];
}

- (GXBottomToastTitle *)bottomToastTitle {
    if (!_bottomToastTitle) {
        _bottomToastTitle = [[[NSBundle mainBundle] loadNibNamed:@"GXBottomToastTitle" owner:self options:nil]lastObject];
        _bottomToastTitle.frame = CGRectMake(0, GXScreenHeight - 153, GXScreenWidth, 40);
    }
    return _bottomToastTitle;
}

#pragma mark--GXAlertToLoginOrAddCountDelegate

- (void)gotoLoginOrOpenAcount {
    if (![GXUserInfoTool isLogin]) {
        GXLoginByVertyViewController *loginVC = [[GXLoginByVertyViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    } else {
        GXAddCountIndexController *addAcountVC = [[GXAddCountIndexController alloc] init];
        [self.navigationController pushViewController:addAcountVC animated:YES];
    }
}


//添加点击图片放大、缩小
- (void)showLargeImage:(NSNotification *)notify
{
    NSDictionary *dictM = (NSDictionary *)notify.userInfo;
    NSInteger index = [dictM[@"index"] integerValue];
    NSArray *arrM = dictM[@"imagesUrls"];
    GXPhotoBrowseController *photoBrowseVC = [[GXPhotoBrowseController alloc]init];
    photoBrowseVC.imgUrlArray = arrM.mutableCopy;
    photoBrowseVC.imgUrl = arrM[index];
    photoBrowseVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:photoBrowseVC animated:YES completion:nil];
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

#pragma mark - 数据请求 -
- (void)loadData
{
    if (_isFullRooms == NO) {
        [GXHttpTool POST:GXUrl_getRooms parameters:nil success:^(id responseObject) {
            [self.tableView.mj_header endRefreshing];
            
            if ([responseObject[@"success"] integerValue] == 1) {
                self.dataSource = [GXVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"][@"roomsList"]];
                if ([responseObject[@"value"][@"more"] integerValue] == 1) {
                    [self createFooterV];
                }else{
                    self.tableView.tableFooterView = nil;
                }
                [self.tableView reloadData];
                [self showEmptyMsg:nil dataSourceCount:self.dataSource.count superView:self.tableView];
                _isFullRooms = NO;
            }
        } failure:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self showErrorNetMsg:nil withView:self.tableView];
        }];
    } else {
        [self loadMoreData];
    }
    
}


#pragma mark - UITableViewDataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GXVideoModel *model = self.dataSource[indexPath.row];
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        GXVideoCell *videoCell = [[GXVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"videoCell"];
        [videoCell setModel:model];
        cell = videoCell;
    } else {
        GXOrdinaryCell *ordinaryCell = [[GXOrdinaryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ordinaryCell"];
        ordinaryCell.myBlock = ^{
            GXLoginByVertyViewController *loginVc = [[GXLoginByVertyViewController alloc]init];
            [MobClick event:@"counselor_login"];
            loginVc.type = @"counselor_login";
            [self.navigationController pushViewController:loginVc animated:YES];
        };
        [ordinaryCell setModel:model];
        cell = ordinaryCell;

    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return HeightScale_IOS6(210);
    } else {
        return HeightScale_IOS6(249);
    }
}
//点击跳转进入播间
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        GXVideoModel *model = self.dataSource[indexPath.row];
        [GXUserdefult setObject:model.id forKey:GXRoomId];
        GXLiveCastViewController *liveVC = [[GXLiveCastViewController alloc] init];
        [MobClick event:@"video"];
        [self.navigationController pushViewController:liveVC animated:YES];
    } else {    //普通播间
        //如果为登陆用户
        if ([GXUserInfoTool isLogin]) {
            GXLiveDetailViewController *detailVc = [[GXLiveDetailViewController alloc] init];
            GXVideoModel *model = self.dataSource[indexPath.row];
            detailVc.detailModel = self.dataSource[indexPath.row];
            detailVc.roomID = [NSString stringWithFormat:@"%@", model.id];
            detailVc.nameTitle = model.name;
            if ([detailVc.nameTitle isEqualToString:@"马到功成"]) {
                [MobClick event:@"mdgc"];
            } else if ([detailVc.nameTitle isEqualToString:@"鹰击万里"]) {
                [MobClick event:@"yjwl"];
            } else if ([detailVc.nameTitle isEqualToString:@"源远流长"]) {
                [MobClick event:@"yylc"];
            } else if ([detailVc.nameTitle isEqualToString:@"鑫鑫向荣"]) {
                [MobClick event:@"xxxr"];
            } else if ([detailVc.nameTitle isEqualToString:@"学有所长"]) {
                [MobClick event:@"xysc"];
            } else if ([detailVc.nameTitle isEqualToString:@"云策金略"]) {
                [MobClick event:@"ycjl"];
            }
            [self.navigationController pushViewController:detailVc animated:YES];
        } else {    //未登录弹窗
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"亲爱的用户,您还未登录,请登录后再进行操作" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"立即登录", nil];
            [alertV show];
        }
    }
}
//点击去登陆跳转到登录界面代理方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [MobClick event:@"counselor_login"];
        GXLoginByVertyViewController *loginVc = [[GXLoginByVertyViewController alloc] init];
        loginVc.registerStr = GXSiteVIPLogin;
        loginVc.type = @"counselor_login";
        [self.navigationController pushViewController:loginVc animated:YES];
    }
}


- (void)createFooterV{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, HeightScale_IOS6(60))];
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = CGRectMake(0, HeightScale_IOS6(20), GXScreenWidth, HeightScale_IOS6(20));
    [clickBtn setTitle:@"点击查看更多" forState:UIControlStateNormal];
    clickBtn.titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    [clickBtn setTitleColor:GXRGBColor(64, 130, 244) forState:UIControlStateNormal];
    clickBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [clickBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:clickBtn];
    self.tableView.tableFooterView = footerView;
}

- (void)btnClicked:(UIButton *)sender
{
    [MobClick event:@"video_more"];
    [self loadMoreData];
}

- (void)loadMoreData
{
    [GXHttpTool POST:GXUrl_getFullRooms parameters:nil success:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if ([responseObject[@"success"] integerValue] == 1) {
            
            self.dataSource = [GXVideoModel mj_objectArrayWithKeyValuesArray:responseObject[@"value"][@"roomsList"]];
            if ([responseObject[@"value"][@"more"] integerValue] == 1) {
                [self createFooterV];
            }else{
                self.tableView.tableFooterView = nil;
            }
            [self.tableView reloadData];
            [self showEmptyMsg:nil dataSourceCount:self.dataSource.count superView:self.tableView];
            _isFullRooms = YES;
            
        }
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self showErrorNetMsg:nil withView:self.tableView];
    }];
}

-(void)creatHomeNavigationMessageButton{
    self.msgView2 = [[UIView alloc]initWithFrame:CGRectMake(GXScreenWidth - 70, 5, 60, 30)];
    self.msgView2.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < 3; i++) {
        UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        homeBtn.showsTouchWhenHighlighted = YES;
        homeBtn.tag = i + 1000;
        [homeBtn addTarget:self action:@selector(homeMsgBtnDidClickAction:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 1){
            homeBtn.frame = CGRectMake(25, 0, 30, 30);
            [homeBtn setImage:[UIImage imageNamed:@"home_rightservice_pic"] forState:UIControlStateNormal];
            [self.msgView2 addSubview:homeBtn];
        }
//        else{
//            homeBtn.frame = CGRectMake(35, 0, 30, 30);
//            [homeBtn setImage:[UIImage imageNamed:@"home_messages_pic"] forState:UIControlStateNormal];
//            [self.msgView2 addSubview:homeBtn];
//        }
    }
    //添加到导航栏
    [self.navigationController.navigationBar addSubview:self.msgView2];
}
//提醒红点儿
-(void)redWarningLabel{
    self.seviceWarningLabel = [[UILabel alloc]init];
    self.seviceWarningLabel.backgroundColor = [UIColor redColor];
    self.seviceWarningLabel.layer.cornerRadius = 7.5;
    self.seviceWarningLabel.layer.masksToBounds = YES;
    self.seviceWarningLabel.textColor = [UIColor whiteColor];
    self.seviceWarningLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize9);
    self.seviceWarningLabel.textAlignment = NSTextAlignmentCenter;
    [self.msgView2 addSubview:self.seviceWarningLabel];
    [self.msgView2 bringSubviewToFront:self.seviceWarningLabel];
    self.messageWarningLabel = [[UILabel alloc]init];
    self.messageWarningLabel.backgroundColor = [UIColor redColor];
    self.messageWarningLabel.layer.cornerRadius = 7.5;
    self.messageWarningLabel.layer.masksToBounds = YES;
    self.messageWarningLabel.textColor = [UIColor whiteColor];
    self.messageWarningLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize8);
    self.messageWarningLabel.textAlignment = NSTextAlignmentCenter;
    [self.msgView2 addSubview:self.messageWarningLabel];
    [self.msgView2 bringSubviewToFront:self.messageWarningLabel];
    [self.seviceWarningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
//    [self.messageWarningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@0);
//        make.right.equalTo(@0);
//        make.width.equalTo(@15);
//        make.height.equalTo(@15);
//    }];
}

//导航栏消息事件
-(void)homeMsgBtnDidClickAction:(UIButton *)sender{
    switch (sender.tag) {
        case 1000:
        {   //我的模块
            GXMineController *mineVC = [[GXMineController alloc]init];
            [self.navigationController pushViewController:mineVC animated:YES];
            break;
        }
        case 1001:
        {
            if ([GXUserInfoTool isLogin]) {
                
                [self.view showLoadingWithTitle:@"正在加载"];
                [GXAddAccountTool getUserInfoSuccess:^(GXUserInfoModel *userInfoModel) {
                    [self.view removeTipView];
                    
                    NSString *headImageName = nil;
                    if (userInfoModel.avatar.length != 0) {
                        headImageName =  [NSString stringWithFormat:@"%@%@",baseImageUrl,userInfoModel.avatar];
                    }
                    [GXUserInfoTool saveUserHeadImage:headImageName];
                    
                    //在线客服
                    ChatViewController *onlineVC = [[ChatViewController alloc] initWithChatter:EaseMobCusterKey type:eAfterSaleType];
                    [self.navigationController pushViewController:onlineVC animated:YES];
                    
                    
                } Failure:^(NSError *error) {
                    [self.view removeTipView];
                }];
            } else {
                
                
                //在线客服
                ChatViewController *onlineVC = [[ChatViewController alloc] initWithChatter:EaseMobCusterKey type:eAfterSaleType];
                [self.navigationController pushViewController:onlineVC animated:YES];
            }
            
            
            
            
            
        }
            break;
        case 1002:
        {   //消息中心
            if ([GXUserInfoTool isLogin]) {
                GXHomeMsgCenterController *msgCenterVC = [[GXHomeMsgCenterController alloc]init];
                [self.navigationController pushViewController:msgCenterVC animated:YES];
            }else{
                [self.navigationController pushViewController:[[GXLoginByVertyViewController alloc]init] animated:YES];
            }
        }
            break;
        default:
            break;
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}






@end
