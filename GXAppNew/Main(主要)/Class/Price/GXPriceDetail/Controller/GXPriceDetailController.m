//
//  GXPriceDetailController.m
//  GXAppNew
//
//  Created by futang yang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXPriceDetailController.h"
#import "PriceIndexSetListController.h"
#import "PriceSelectIndexController.h"
#import "PriceLandscapeController.h"
#import "GXDealController.h"
#import "GXLoginByVertyViewController.h"
#import "GXAddCountIndexController.h"
#import "GXInvestmentProductViewController.h"
#import "GXPriceCodeRuleController.h"
#import "GXPriceRemindController.h"
#import "GXNoviceTutorialController.h"
#import "GXLiveController.h"


#import "PriceCanlendarBaseModel.h"

#import "PriceDetailHeaderView.h"
#import "CanlendarHearView.h"
#import "PriceChartView.h"
#import "PriceContrastView.h"
#import "PriceTabbar.h"
#import "PriceDetailTitleView.h"


#import "PriceCanlendarBaseCell.h"
#import "PriceSuggestionView.h"
#import "PriceNoSuggesView.h"

#import "FTTimelineData.h"
#import "FTTimeData.h"

#import "FTKlineModel.h"
#import "JXSegment.h"
#import "PriceSuggestionModel.h"
#import "PriceIndexTool.h"
#import "PriceTopBttomParam.h"
#import "PriceTipSuggestionModel.h"

#import "UINavigationItem+Loading.h"


// TODO:重写模型
#import "GXSuggestionModel.h"
#import "WJYAlertView.h"
#import "PriceConstratModel.h"



#define Timeinteval_contrrast (3.6000)
#define Timeinteval_price (2)
#define Timeinteval_Chart (30.0)


#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])




@interface GXPriceDetailController ()<UITableViewDelegate, UITableViewDataSource,PriceChartViewDelegate,PriceNoSuggesViewDelegate, PriceTabbarDelegate,PriceLandscapeControllerDelegate,PriceContrastViewDelegate>

@property (nonatomic, strong) UIScrollView *bgScrollView;

@property (nonatomic, strong) PriceDetailHeaderView *DetailHeaderView;
@property (nonatomic, strong) PriceChartView *chartView;
@property (nonatomic, strong) PriceContrastView *contrastView;
@property (nonatomic, strong) UITableView *PriceCalendarView;
@property (nonatomic, strong) PriceNoSuggesView *suggestionView;
@property (nonatomic, strong) PriceTabbar *priceTabbar;
@property (nonatomic, strong) PriceMarketModel *detailMarketModel;
@property (nonatomic, strong) PriceTipSuggestionModel *tipMarketModel;

@property (nonatomic, strong) NSMutableArray *PriceCalendarData;
@property (nonatomic, strong) PriceDetailTitleView *titleView;



@end

@implementation GXPriceDetailController {
    NSTimer *headTimer;
    NSTimer *chartTimer;
    CGFloat CalendarTableViewHeight;
    BOOL isOpened;
}
@synthesize delegate;


-(PriceDetailTitleView *)titleView {
    if (!_titleView) {
        _titleView = [[[NSBundle mainBundle] loadNibNamed:@"PriceDetailTitleView" owner:nil options:nil] lastObject];
        _titleView.center = CGPointMake(self.view.bounds.size.width/2.0, 22);
        _titleView.backgroundColor = [UIColor clearColor];
        
    }
    return _titleView;
}


#pragma mark - lifeCircle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.titleView = self.titleView;
    [self.titleView setTitleWithModel:self.marketModel];
    

    if (headTimer) {
        [headTimer invalidate];
        headTimer = nil;
    } else {
        
        [self loadDataHeadViewData];
        headTimer = [NSTimer scheduledTimerWithTimeInterval:Timeinteval_price target:self selector:@selector(loadDataHeadViewData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:headTimer forMode:NSRunLoopCommonModes];
    }
    
    
    if (chartTimer) {
        [chartTimer invalidate];
        chartTimer = nil;
    } else {
        chartTimer = [NSTimer scheduledTimerWithTimeInterval:Timeinteval_Chart target:self selector:@selector(timerLoadChart) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:chartTimer forMode:NSRunLoopCommonModes];
    }
}




- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.titleView) {
        [self.titleView removeFromSuperview];
        self.titleView = nil;
    }
    
    
    if (self.suggestionView.isShow) {
        [self.suggestionView setSelectExViewShow];
    }
    
    
    
    if ([headTimer isValid]) {
        [headTimer invalidate];
        headTimer = nil;
    }
    
    if ([chartTimer isValid]) {
        [chartTimer invalidate];
        chartTimer = nil;
    }

}



- (void)makeFunctionGuide{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *firstComeInTeacherDetail = @"isFirstEnter_PriceDetail";
    
   // [user setBool:NO forKey:firstComeInTeacherDetail];
    
    if (![user boolForKey:firstComeInTeacherDetail]) {
        [user setBool:YES forKey:firstComeInTeacherDetail];
        [user synchronize];
        [self makeGuideView];
    }
}
- (void)makeGuideView{
    
    
    NSString *btnSetKlineIndexStr = NSStringFromCGRect(CGRectMake(0, HeightScale_IOS6(320), 90, HeightScale_IOS6(90)));
    NSString *btnchartRectStr = NSStringFromCGRect(CGRectMake(0, self.DetailHeaderView.height + 64 + 36.f, 375, self.chartView.frame.size.height - 36.f));
    NSString *btnSetIndexRectStr = NSStringFromCGRect(CGRectMake(WidthScale_IOS6(310), HeightScale_IOS6(335), 62, HeightScale_IOS6(62)));
    NSString *btnklineChangeIndexStr = NSStringFromCGRect(CGRectMake(0, HeightScale_IOS6(175), 75, 75));
    
    
    
    NSString *imgSetKlineIndexStr = NSStringFromCGRect(CGRectMake(0, HeightScale_IOS6(266), 375, HeightScale_IOS6(150)));
    NSString *imgchartRectStr = NSStringFromCGRect(CGRectMake(0, HeightScale_IOS6(214), 375, HeightScale_IOS6(270)));
    NSString *imagSetIndexRectStr = NSStringFromCGRect(CGRectMake(0, HeightScale_IOS6(335), 375, HeightScale_IOS6(140)));
    NSString *imagklineChangeIndexStr = NSStringFromCGRect(CGRectMake(0, HeightScale_IOS6(165), 375, HeightScale_IOS6(278)));
    
    
    
    
    
    GXNoviceTutorialController *vc = [[GXNoviceTutorialController alloc]init];
    vc.styles = @[@"GuideViewCleanModeCycleRect",@"GuideViewCleanModeRoundRect",@"GuideViewCleanModeCycleRect",@"GuideViewCleanModeCycleRect"];
    
    vc.btnFrames = @[btnSetKlineIndexStr,
                     btnchartRectStr,
                     btnSetIndexRectStr,
                     btnklineChangeIndexStr,
                     ];
    
    vc.imgFrames = @[imgSetKlineIndexStr,
                    imgchartRectStr,
                     imagSetIndexRectStr,
                     imagklineChangeIndexStr,
                     ];
    
    
    vc.images = @[@"newbie_guide_pic9",
                  @"newbie_guide_pic10",
                  @"newbie_guide_pic11",
                  @"newbie_guide_pic12",
                  ];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
  
    isOpened = YES;

    [self renderUI];
    
    
    [self loadCalendarData];
    [self loadSuggestionsData];
    [self makeChoseKlineTimeChart];
    
    // 建立通知
    [self addSetIndexObserve];
}



- (void)timerLoadChart {
    
    
    DLog(@"定时器请求数据");
    NSInteger index = [PriceIndexTool getPricePeriodIndex];
    DLog(@"index = %ld",index);
    
    if (index == 0) {
        
        
        NSMutableDictionary *param = [NSMutableDictionary new];
        param[@"code"] = self.marketModel.code;
        param[@"period"] = @"1";
        param[@"level"] = @"1";
    
        [GXHttpTool POST:GXUrl_timeline parameters:param success:^(id responseObject) {
    
            NSArray *dataArray = [FTTimelineData mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
            [self.chartView setTimeViewData:dataArray period:@"1"];
            [self.chartView drawTimeChrt];
            
        } failure:^(NSError *error) {

        }];

    }
    
    
    
    if (index >= 1 && index <= 4) {
        DLog(@"停止定时器请求");
        return;
    } else if (index != 0 && index >= 5) {
        
        
        NSString *level = nil;
        
        if (index == 5) {
            DLog(@"1分钟");
            level = @"1";
        }

        if (index == 6) {
            DLog(@"5分钟");
             level = @"5";
        }
        
        
        if (index == 7) {
            DLog(@"15分钟");
             level = @"15";
        }
        
        if (index == 8) {
            DLog(@"30分钟");
             level = @"30";
        }
        
        if (index == 9) {
            DLog(@"60分钟");
             level = @"60";
        } else if (index == 10) {
            DLog(@"240分钟");
            level = @"240";
        }

    
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"maxrecords"] = @"200";
        param[@"code"] = self.marketModel.code;
        param[@"level"] = level;
        
        [GXHttpTool POST:GXUrl_kline parameters:param success:^(id responseObject) {
            
            if ([responseObject[GXSuccess] integerValue] == 1) {
                
                NSArray *array = responseObject[GXValue];
                if (array.count == 0) return;
                NSMutableArray *modelsArray = [FTKlineModel mj_objectArrayWithKeyValuesArray:array];
                
                PriceTopBttomParam *topBottomParam = [PriceIndexTool getTopBottomParam];
                
                
                if (topBottomParam) {
                
                    [self.chartView setKlineViewData:modelsArray TopType:topBottomParam.topType bottomType:topBottomParam.bottomType peirod:level];
                    [self.chartView reDrawAllChart];
    
                }
            }
            
        } failure:^(NSError *error) {
           
        }];
    }
    
}


- (void)addSetIndexObserve {
    
    [GXNotificationCenter addObserver:self selector:@selector(reDrawPriceKlineChart:) name:PriceReDrawPriceKlineChartNotificaitonName object:nil];
    [GXNotificationCenter addObserver:self selector:@selector(reDrawPriceIndexChart:) name:PriceReDrawPriceIndexChartNotificaitonName object:nil];
}


- (void)LandPriceletMakeChoseKlineTimeChart {
    [self makeChoseKlineTimeChart];
}


- (void)reDrawPriceKlineChart:(NSNotification *)notifation {

    if (notifation.object) {
        NSInteger index = [notifation.object integerValue];
        if (index == self.chartView.topType) {
            [self.chartView RedrawKlineChart:index];
        } else {
            return;
        }
    }
}


- (void)reDrawPriceIndexChart:(NSNotification *)notifation {
    if (notifation.object) {
        NSInteger index = [notifation.object integerValue];
        if (index == self.chartView.bottomType) {
            [self.chartView RedrawIndexChart:index];
        } else {
            return;
        }
    }
}



- (void)dealloc {
    //PriceReLoadChartNotificaitonName
    [GXNotificationCenter removeObserver:self name:PriceReDrawPriceKlineChartNotificaitonName object:nil];
    [GXNotificationCenter removeObserver:self name:PriceReDrawPriceIndexChartNotificaitonName object:nil];
}


#pragma mark - render UI
- (void)renderUI {
    
    self.view.backgroundColor = GXRGBColor(24, 24, 31);
    


    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:IMAGE_NAMED(@"priceRefresh") style:UIBarButtonItemStylePlain target:self action:@selector(scrollViewBeginLoad)];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;
    

    [self.bgScrollView addSubview:self.DetailHeaderView];
    [self.bgScrollView addSubview:self.chartView];
    
    
    if (self.marketModel.tradeDetail && [self.marketModel.status isEqualToString:@"交易中"]) {
        [self.bgScrollView addSubview:self.contrastView];
        [self loadContrastData];
    } else {
        self.contrastView.hidden = YES;
    }
    
    
     //  [self.PriceCalendarView registerNib:[UINib nibWithNibName:@"PriceCalendarEventCell" bundle:nil] forCellReuseIdentifier:@"PriceCalendarEventCell"];
    [self.PriceCalendarView registerNib:[UINib nibWithNibName:@"PriceCanlendarDataCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PriceCalendarDataModel"];
    [self.bgScrollView addSubview:self.PriceCalendarView];
    

    [self.view addSubview:self.bgScrollView];
    [self.view addSubview:self.priceTabbar];
    [self.priceTabbar cofigTabbar:self.marketModel];
    [self.priceTabbar setSelectBtnTitle:self.marketModel];
    
    
    if (self.marketModel.shortName.length != 0) {
        [self.view insertSubview:self.suggestionView belowSubview:self.priceTabbar];
    }
    
}

- (void)scrollViewBeginLoad {
    [self.bgScrollView.mj_header beginRefreshing];
}

#pragma mark PriceTabbarDelegate
- (void)PriceTabbar:(PriceTabbar *)priceTabar ClickOnSelectButton:(UIButton *)SelectButton isSelected:(BOOL)isSelected {

    // 自选
    [MobClick event:@"market_self_service"];
    
    NSMutableArray *array = [[GXUserdefult objectForKey:PersonSelectCodesKey] mutableCopy];
    NSMutableArray *param = [NSMutableArray new];
    for (NSString *str in array) {
        [param addObject:[str lowercaseString]];
    }
    
    
    if (isSelected) {
        DLog(@"取消自选");
        if ([param containsObject:[self.marketModel.code lowercaseString]]) {
            [param removeObject:[self.marketModel.code lowercaseString]];
        }
        
        [GXUserdefult setObject:param forKey:PersonSelectCodesKey];
        [GXUserdefult synchronize];
        
        [self.view showSuccessWithTitle:@"删自选成功"];
        [self.priceTabbar setSelectBtnTitle:self.marketModel];
        
        
    } else {
        
        DLog(@"添加自选");
        [param addObject:[self.marketModel.code lowercaseString]];
        [GXUserdefult setObject:param forKey:PersonSelectCodesKey];
        [GXUserdefult synchronize];
        
        [self.view showSuccessWithTitle:@"加自选成功"];
        [self.priceTabbar setSelectBtnTitle:self.marketModel];
        
    }
    
    
    
    __block GXPriceDetailController *weakSelf = self;
    
    if ([GXUserInfoTool isLogin]) {
        
        [GXHttpTool POST:GXUrl_setPrice parameters:@{@"productCodes":[param componentsJoinedByString:@","]}  success:^(id responseObject) {
            
            if ([responseObject[GXSuccess] integerValue] == 1) {
                
                [weakSelf.priceTabbar setSelectBtnTitle:self.marketModel];
            }
            
        } failure:^(NSError *error) {
            
            [weakSelf.priceTabbar setSelectBtnTitle:self.marketModel];
        }];
    }
    
    
    if([delegate respondsToSelector:@selector(priceDetail_addCodeDone)])
    [delegate priceDetail_addCodeDone];
}


- (void)PriceTabbarClickOnTrade:(PriceTabbar *)priceTabar {
    
    //market_trading
    [MobClick event:@"market_trading"];
    
    GXDealController *tradeVC = [[GXDealController alloc] init];
    [self.navigationController pushViewController:tradeVC animated:YES];
}

- (void)PriceTabbarClickOnCodeRule:(PriceTabbar *)priceTabar {
    
    //regulation
    [MobClick event:@"regulation"];
    
    GXPriceCodeRuleController *priceCodeRuleVC = [[GXPriceCodeRuleController alloc] init];
    priceCodeRuleVC.marketModel = self.marketModel;
    
    [self.navigationController pushViewController:priceCodeRuleVC animated:YES];
}


- (void)PriceTabbarClickOnCodeRemind:(PriceTabbar *)priceTabar {
    
    // market_warning
    
    if ([GXUserInfoTool isLogin]) {
        
        // 埋点
        [MobClick event:@"market_warning"];
        
        GXPriceRemindController *remindVC = [[GXPriceRemindController alloc] init];
        remindVC.marketModel = self.marketModel;
        [self.navigationController pushViewController:remindVC animated:YES];
    } else {
        
        //埋点 warning_login
        
        [MobClick event:@"warning_login"];
        GXLoginByVertyViewController *loginVC = [[GXLoginByVertyViewController alloc] init];
        loginVC.type = @"warning_login";
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}



#pragma mark - PriceNoSuggesViewDelegate
- (void)PriceSuggestionViewBeginShow:(PriceNoSuggesView *)suggestionView {
   
    if (!suggestionView.isDisplaySuggestion) {
        DLog(@"更改登录状态");
        if (isOpened) {
            [self loadSuggestionsData];
        }
    }
    
    // 展示即时建议
    if (!headTimer) {
        return;
    }
    
    if (!self.detailMarketModel) {
        return;
    }
    
    if (self.suggestionView.isShow || self.suggestionView.isDisplaySuggestion) {
        [self.suggestionView showCodeSuggestionsListView:self.tipMarketModel markertMode:self.detailMarketModel];
    }

}

- (void)PriceSuggestionViewSkipController:(PriceNoSuggesView *)suggestionView {

    if (suggestionView.buttonSatus == NeedToLogin) {
        GXLoginByVertyViewController *loginVC = [[GXLoginByVertyViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    } else if (suggestionView.buttonSatus == NeedOpenAcount) {
//        GXAddCountIndexController *openAccountVC = [[GXAddCountIndexController alloc] init];
//        [self.navigationController pushViewController:openAccountVC animated:YES];
    } else if (suggestionView.buttonSatus == NeedBindRoom) {
        DLog(@"跳转绑定播间");
        GXLiveController *liveController = [[GXLiveController alloc] init];
        [self.navigationController pushViewController:liveController animated:YES];
    }
}




#pragma mark - configKlineTimeChart
- (void)makeChoseKlineTimeChart {
    NSInteger index = [PriceIndexTool getPricePeriodIndex];
    [self.chartView setPriceChartIndex:index];
}


#pragma mark - privateMethod
- (void)loadDataHeadViewData {
    
 //   DLog(@"loadHeadData-----");
    
    NSString *code = self.marketModel.code;
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"code"] = code;
  
    __block GXPriceDetailController *weakSelf = self;
    [GXHttpTool POSTCache:GXUrl_quotation parameters:param success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[GXSuccess] integerValue] == 1) {
            weakSelf.detailMarketModel = [PriceMarketModel mj_objectWithKeyValues:responseObject[GXValue][0]];
            [weakSelf.DetailHeaderView setPriceDetailHeaderView:self.detailMarketModel];
            [weakSelf.titleView setTitleWithModel:self.detailMarketModel];
            
            if (weakSelf.suggestionView.isShow) {
                [weakSelf.suggestionView showCodeSuggestionsListView:self.tipMarketModel markertMode:self.detailMarketModel];
            }
        }
    } failure:^(NSError *error) {
    }];
}

- (void)loadNewData {
    DLog(@"下拉加载更多");
    
    [self.navigationItem startAnimatingAt:ANNavBarLoaderPositionRight];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        [self.navigationItem stopAnimating];
        [self.bgScrollView.mj_header endRefreshing];
    });
}



- (void)loadContrastData {
    
    if (self.marketModel.tradeDetail) {
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        param[@"code"] = self.marketModel.code;
        
        [GXHttpTool POST:GXUrl_priceContrast parameters:param success:^(id responseObject) {
            
            DLog(@"%@", responseObject);
            
            
            if ([responseObject[GXSuccess] integerValue] == 1) {
                PriceConstratModel *model = [PriceConstratModel mj_objectWithKeyValues:responseObject[GXValue]];
                if ([model.sell integerValue] == 0 && [model.buy integerValue] == 0) {
                    self.contrastView.hidden = YES;
                    self.PriceCalendarView.frame = CGRectMake(0,(self.contrastView.hidden) ? (self.chartView.y + self.chartView.height + 2) : self.contrastView.y + self.contrastView.height,GXScreenWidth, 700);
                    
                } else {
                    [self.contrastView setPriceLong:[model.buy floatValue] shortValue:[model.sell floatValue]];
                }
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
    
    
   
}


- (void)loadCalendarData {
    
    [GXHttpTool POST:GXUrl_priceFinance parameters:nil success:^(id responseObject) {
    
        if ([responseObject[GXSuccess] integerValue] == 1) {
        
            
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *item in responseObject[GXValue]) {
                PriceCanlendarBaseModel *model = [PriceCanlendarBaseModel modelWithDictionary:item];
                CalendarTableViewHeight += model.cellHeight;
                [tempArray addObject:model];
            }
            
            self.PriceCalendarData = tempArray;
            
            CGRect originFrame = self.PriceCalendarView.frame;
            originFrame.size.height = CalendarTableViewHeight + self.PriceCalendarView.sectionHeaderHeight;
            self.PriceCalendarView.frame = originFrame;
            self.bgScrollView.contentSize = CGSizeMake(GXScreenWidth, self.DetailHeaderView.height +  self.chartView.height + (self.contrastView.hidden ?   0 : self.contrastView.height) + self.PriceCalendarView.height + self.priceTabbar.height + 44);
            
            [self.PriceCalendarView reloadData];
        }

    } failure:^(NSError *error) {
        
    }];
}


- (void)loadSuggestionsData {
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"isLater"] = @"1";
    param[@"code"] = self.marketModel.code;
    
    [self.suggestionView.contentView showLoadingWithTitle:@"正在加载"];
    [GXHttpTool POST:GXUrl_isBindRoom parameters:param success:^(id responseObject) {
        
        if ([responseObject[GXSuccess] integerValue] == 1) {
            
            [self.suggestionView.contentView removeTipView];
            
            PriceTipSuggestionModel *model = [PriceTipSuggestionModel mj_objectWithKeyValues:responseObject[GXValue]];
        
            // 根据即时建议数量
            if ([model.roomCallNum integerValue] == 0) {
                [self.suggestionView removeFromSuperview];
                return;
            }
            
            [self.suggestionView setTipSuggestion:model];
            self.tipMarketModel = model;
           
    
            //userStatus ：0 未登录  1登录(没有开实盘)  3没绑定(开实盘没绑定播间)  4绑定用户(绑定播间 展示数据)
            if ([model.userStatus integerValue] == 0) {
                [self.suggestionView setSuggesionViewButtonStatus:NeedToLogin title:@"登录/注册"];
                
            } else if ([model.userStatus integerValue] == 1) {
                
                if ([GXUserInfoTool isShowOpenAccount]) {
                    [self.suggestionView setSuggesionViewButtonStatus:NeedOpenAcount title:@"立即开户"];
                } else {
                     self.suggestionView.stateButton.hidden = YES;
                }
            } else if ([model.userStatus integerValue] == 3) {
                [self.suggestionView setSuggesionViewButtonStatus:NeedBindRoom title:@"绑定播间"];
               
            } else {
                
                
                if (model.Table.count == 0) {
                    self.suggestionView.hidden = YES;
                    return;
                }
                
                self.suggestionView.isDisplaySuggestion = YES;
                [self.suggestionView showCodeSuggestionsListView:self.tipMarketModel markertMode:self.detailMarketModel];
            }
        }
        
    } failure:^(NSError *error) {
        
         [self.suggestionView.contentView removeTipView];
        
    }];
    
}


- (void)getKlineChartDataWithLevel:(NSString *)level {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"maxrecords"] = @"200";
    param[@"code"] = self.marketModel.code;
    param[@"level"] = level;
    
    TICK;
    [self.chartView.klineView showLoadingWithTitle:@" " isClear:YES];
    [GXHttpTool POST:GXUrl_kline parameters:param success:^(id responseObject) {
        
        TOCK;
        if ([responseObject[GXSuccess] integerValue] == 1) {
           
            [self.chartView.klineView removeTipView];
            
            NSArray *array = responseObject[GXValue];
            if (array.count == 0) return;
            NSMutableArray *modelsArray = [FTKlineModel mj_objectArrayWithKeyValuesArray:array];
    
            PriceTopBttomParam *topBottomParam = [PriceIndexTool getTopBottomParam];
            
            
            if (topBottomParam) {
                
              //  self.chartView.lastSaveDecimalPlaces = self.marketModel.saveDecimalPlaces;
                
                
                [self.chartView setKlineViewData:modelsArray TopType:topBottomParam.topType bottomType:topBottomParam.bottomType peirod:level];
                [self.chartView drawKlineAllChart];
            }
        }
        
    } failure:^(NSError *error) {
         [self.chartView.klineView removeTipView];
    }];
    
}


- (void)loadTimeChart:(NSString *)code period:(NSString *)peirod {
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"code"] = self.marketModel.code;
    param[@"period"] = peirod;
    param[@"leval"] = @"1";
    
    TICK;
    [self.chartView.timelineView showLoadingWithTitle:@" " isClear:YES];
    
    [GXHttpTool POST:GXUrl_timeline parameters:param success:^(id responseObject) {
        TOCK;
    
        [self.chartView.timelineView removeTipView];
        
        
        NSArray *dataArray = [FTTimelineData mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];

        [self.chartView setTimeViewData:dataArray period:peirod];
        [self.chartView drawTimeChrt];
        
    } failure:^(NSError *error) {
        [self.chartView.timelineView removeTipView];
    }];
}


#pragma mark - UITableViewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.PriceCalendarData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PriceCanlendarBaseModel *model = self.PriceCalendarData[indexPath.row];
    PriceCanlendarBaseCell *cell = [PriceCanlendarBaseCell cellWithTable:tableView Model:model indexPath:indexPath];
    
    cell.backgroundColor = PriceVertiacl_CalandarCellColor;
    return cell;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PriceCanlendarBaseModel *model = self.PriceCalendarData[indexPath.row];
    CGFloat cellHeight = model.cellHeight;
    return cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        CanlendarHearView *headerView = [[CanlendarHearView alloc] initWithTitle:@"本周财经日历" frame:CGRectMake(0, 0, GXScreenWidth, CalendarHeaderHeight)];
        headerView.backgroundColor = PriceVertical_CanlendarHearViewColor;
        if (section == 0) {
            return headerView;
        }
    }
    return nil;
}


#pragma mark - chartViewDelegate
- (void)clickOnBottomIndexBtn {
    PriceSelectIndexController *priceSelectVC = [[PriceSelectIndexController alloc] init];
    [self.navigationController pushViewController:priceSelectVC animated:YES];
    
    typeof(self) weakSelf = self;
    
    priceSelectVC.selecBlock = ^(KLineChartBottomType type) {
        
        if (type == MACD) {
            [weakSelf.chartView drawMacdIndexChart];
        }
        
        if (type == KDJ) {
            [weakSelf.chartView drawKDJlineIndexChart];
        }
        
        if (type == RSI) {
            [weakSelf.chartView drawRSIlineIndexChart];
        }
        if (type == ADX) {
            [weakSelf.chartView drawADXLineIndexChart];
        }
        
        if (type == ATR) {
            [weakSelf.chartView drawATRLineIndexChart];
        }
   
        [PriceIndexTool saveTopBottomParamBottom:type];
    };
}

- (void)clickOnSetIndexBtn {
    DLog(@"点击设置 跳转");
    // MA_set
    [MobClick event:@"qlsp_open_an_account_defeat"];
    PriceIndexSetListController *setIndexListView = [[PriceIndexSetListController alloc] init];
    [self.navigationController pushViewController:setIndexListView animated:YES];
    
}

- (void)klineView:(PriceChartView *)klineView didSelectIndex:(NSInteger)index {
    
    if (index == 0) {
        DLog(@"分时");
        [self loadTimeChart:@"" period:@"1"];
    }
    
    if (index == 1) {
        DLog(@"5日");
        [self loadTimeChart:@"" period:@"5"];
    }
    
    if (index == 2) {
        DLog(@"日K");
        [self getKlineChartDataWithLevel:@"1440"];
    }
    
    if (index == 3) {
        DLog(@"周k");
        [self getKlineChartDataWithLevel:@"week"];
    }
    
    if (index == 4) {
        DLog(@"月k");
        [self getKlineChartDataWithLevel:@"month"];
    }
    
    if (index == 5) {
        DLog(@"1分钟");
        [self getKlineChartDataWithLevel:@"1"];
    }
    
  
    
    if (index == 6) {
        DLog(@"5分钟");
        [self getKlineChartDataWithLevel:@"5"];
    }
    
    
    if (index == 7) {
        DLog(@"15分钟");
       [self getKlineChartDataWithLevel:@"15"];
    }
    
    if (index == 8) {
        DLog(@"30分钟");
        [self getKlineChartDataWithLevel:@"30"];
    }
    
    if (index == 9) {
        DLog(@"60分钟");
        [self getKlineChartDataWithLevel:@"60"];
    }
    
    if (index == 10) {
        DLog(@"240分钟");
        [self getKlineChartDataWithLevel:@"240"];
    }
    
    // 保存
    [PriceIndexTool savePricePeriodIndex:index];
    
    
    // 引导页
    if (index >= 2) {
        [self makeFunctionGuide];
    }
    
}


- (void)priceChartTapOn:(PriceChartView *)chartView {
    
    [[UIApplication sharedApplication].keyWindow setBackgroundColor:ThemeBlack_Color];
    
    PriceLandscapeController *priceLandVC = [[PriceLandscapeController alloc] init];
    priceLandVC.isFull = YES;
    priceLandVC.delegate = self;
    priceLandVC.marketModel = self.marketModel;
    [self.navigationController pushViewController:priceLandVC animated:false];
    [self addAnimation:self.navigationController.view];
}

- (void)addAnimation:(UIView *)view{
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    basicAnimation.fromValue = [NSNumber numberWithFloat:-M_PI];
    basicAnimation.toValue = [NSNumber numberWithFloat:0];
    basicAnimation.fillMode = kCAFillModeRemoved;
    basicAnimation.removedOnCompletion = true;
    basicAnimation.repeatCount = 1;
    basicAnimation.duration = TimeInterval;
    [view.layer addAnimation:basicAnimation forKey:nil];
    
}


#pragma mark - ContrastViewDelegate
- (void)priceConstrastClickOnSupplementBtn:(PriceContrastView *)view {
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:
                                 @"释义：30分钟内多单与空单的比值。                                                                                           数据仅供参考，据此操作产生的盈亏由交易者自行承担。" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertC addAction:sureAction];
    [self presentViewController:alertC animated:true completion:nil];
}



#pragma mark - getter
- (PriceDetailHeaderView *)DetailHeaderView {
    if (!_DetailHeaderView) {
        //_DetailHeaderView = [[PriceDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, HeightScale_IOS6(117))];
        _DetailHeaderView = [[PriceDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, HeightScale_IOS6(117)) code:self.marketModel];
        _DetailHeaderView.backgroundColor = PriceVertical_HeaderViewColor;
    }
    return _DetailHeaderView;
}


- (PriceChartView *)chartView {
    if (!_chartView) {
        _chartView = [[PriceChartView alloc] initWithFrame:CGRectMake(0, self.DetailHeaderView.height, GXScreenWidth, HeightScale_IOS6(265))];
        _chartView.chartDirection = PriceChartDirectionVertical;
        _chartView.lastSaveDecimalPlaces = self.marketModel.saveDecimalPlaces;
        _chartView.delegate = self;
        _chartView.modle = self.marketModel;
    }
    return _chartView;
}

- (PriceContrastView *)contrastView {
    if (!_contrastView) {
        _contrastView = [[PriceContrastView alloc] initWithFrame:CGRectMake(0, self.chartView.y + self.chartView.height, GXScreenWidth, HeightScale_IOS6(60))];
        _contrastView.delegate = self;
    }
    return _contrastView;
}

- (UITableView *)PriceCalendarView {
    if (!_PriceCalendarView) {
        _PriceCalendarView = [[UITableView alloc] initWithFrame:CGRectMake(0,(self.contrastView.hidden) ? (self.chartView.y + self.chartView.height + 2) : self.contrastView.y + self.contrastView.height,GXScreenWidth, GXScreenHeight) style:UITableViewStylePlain];
        _PriceCalendarView.sectionHeaderHeight = CalendarHeaderHeight;
        _PriceCalendarView.backgroundColor = PriceVertiacl_CalandarCellColor;
        _PriceCalendarView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _PriceCalendarView.dataSource = self;
        _PriceCalendarView.delegate = self;
        _PriceCalendarView.scrollEnabled = NO;
    }
    return _PriceCalendarView;
}


- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight - kBottomBarHeight)];
        typeof(self) weakSelf = self;
        _bgScrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf loadNewData];
            
            
            // 埋点
            [MobClick event:@"refresh_market_particulars"];
            
        }];
        _bgScrollView.delegate = self;
    }
    return _bgScrollView;
}

- (PriceTabbar *)priceTabbar {
    if (!_priceTabbar) {
        _priceTabbar = [[PriceTabbar alloc] initWithFrame:CGRectMake(0, GXScreenHeight - kTopAllHeight - priceTabbarHeight, GXScreenWidth, priceTabbarHeight)];
        _priceTabbar.backgroundColor = PriceVertical_PriceTabbarBackgroundColor;
        _priceTabbar.delegate = self;
        
    }
    return _priceTabbar;
}

- (PriceNoSuggesView *)suggestionView {
    if (!_suggestionView) {
        _suggestionView = [[PriceNoSuggesView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight)];
        _suggestionView.delegate = self;
    }
    return _suggestionView;
}

- (NSMutableArray *)PriceCalendarData {
    if (!_PriceCalendarData) {
        _PriceCalendarData = [NSMutableArray new];
    }
    return _PriceCalendarData;
}



@end
