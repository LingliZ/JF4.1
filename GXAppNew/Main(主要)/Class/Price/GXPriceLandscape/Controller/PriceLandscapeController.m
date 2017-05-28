//
//  PriceLandscapeController.m
//  GXAppNew
//
//  Created by futang yang on 2017/1/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "PriceLandscapeController.h"

#import "PriceLandHeaderView.h"
#import "PriceChartView.h"

#import "PriceIndexTool.h"
#import "GXPriceDetailController.h"
#import "FTTimelineData.h"
#import "FTKlineModel.h"


#define PriceLandscape_BackGroundColor GXRGBColor(24, 24, 31)
#define PriceLandscape_HeaderViewColor GXRGBColor(38, 40, 52)
#define PriceLandscape_HeaderVieHeight 40.f
#define PriceLandscape_IndexViewHeight 30.f
#define Timeinteval_price (2)
#define Timeinteval_Chart (30)


@interface PriceLandscapeController ()<PriceChartViewDelegate, PriceLandHeaderViewDelegate>

@property (nonatomic,assign) UIDeviceOrientation position;

@property (nonatomic, strong) PriceLandHeaderView *landHeaderView;
@property (nonatomic, strong) PriceChartView *chartView;
@property (nonatomic, strong) PriceMarketModel *detailMarketModel;




@end

@implementation PriceLandscapeController {
    NSTimer *headTimer;
    NSTimer *chartTimer;
  
}

#pragma mark - lifeCircle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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

- (void)viewDidLoad {
    [super viewDidLoad];
  
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    

    self.view.backgroundColor = PriceLandscape_BackGroundColor;
    self.navigationController.navigationBar.hidden = true;
    
    
    [self renderUI];
    self.landHeaderView.model = self.marketModel;
    [self makeChoseKlineTimeChart];
    
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


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([headTimer isValid]) {
        [headTimer invalidate];
        headTimer = nil;
    }
    
    self.navigationController.navigationBar.hidden = false;
}

- (void)addAnimation:(UIView *)view{
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    basicAnimation.fromValue = [NSNumber numberWithFloat:-M_PI];
    basicAnimation.toValue = [NSNumber numberWithFloat:0];
    basicAnimation.fillMode = kCAFillModeRemoved;
    basicAnimation.removedOnCompletion = true;
    basicAnimation.repeatCount = 1;
    basicAnimation.duration = TimeInterval;
    [view.layer addAnimation:basicAnimation forKey:nil];
    
}

#pragma mark - privateMethod
- (void)loadDataHeadViewData {
    
    DLog(@"loadHeadDataLand");
    
    NSString *code = self.marketModel.code;
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"code"] = code;
    
    [GXHttpTool POSTCache:GXUrl_quotation parameters:param success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[GXSuccess] integerValue] == 1) {
            self.detailMarketModel = [PriceMarketModel mj_objectWithKeyValues:responseObject[GXValue][0]];
            self.landHeaderView.model = self.detailMarketModel;
        
        }
    } failure:^(NSError *error) {
    }];
}




#pragma mark - render UI
- (void)renderUI {
    [self.view addSubview:self.landHeaderView];
    [self.view addSubview:self.chartView];
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


- (void)getKlineChartDataWithLevel:(NSString *)level {

    
    [self.chartView showLoadingWithTitle:@"" isClear:YES];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"maxrecords"] = @"200";
    param[@"code"] = self.marketModel.code;
    param[@"level"] = level;
    
    PriceTopBttomParam *topBottomParam = [PriceIndexTool getTopBottomParam];

    [GXHttpTool POST:GXUrl_kline parameters:param success:^(id responseObject) {
        
        [self.chartView removeTipView];
        
        if ([responseObject[GXSuccess] integerValue] == 1) {
         
            NSArray *array = responseObject[GXValue];
            if (array.count == 0) return;
            NSMutableArray *modelsArray = [FTKlineModel mj_objectArrayWithKeyValuesArray:array];
            
            
            if (topBottomParam) {
                self.chartView.lastSaveDecimalPlaces = self.marketModel.saveDecimalPlaces;
                [self.chartView setKlineViewData:modelsArray TopType:topBottomParam.topType bottomType:topBottomParam.bottomType peirod:level];
                [self.chartView drawKlineAllChart];
            }
        }
        
    } failure:^(NSError *error) {
        [self.chartView removeTipView];
        
    }];
    
}


- (void)loadTimeChart:(NSString *)code period:(NSString *)peirod {
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"code"] = self.marketModel.code;
    param[@"period"] = peirod;
    param[@"leval"] = @"1";
    
    
    [self.chartView showLoadingWithTitle:@"" isClear:YES];
    [GXHttpTool POST:GXUrl_timeline parameters:param success:^(id responseObject) {
        
        [self.chartView removeTipView];
        
        NSArray *dataArray = [FTTimelineData mj_objectArrayWithKeyValuesArray:responseObject[@"value"]];
        [self.chartView setTimeViewData:dataArray period:peirod];
        [self.chartView drawTimeChrt];
        
    } failure:^(NSError *error) {
        [self.chartView removeTipView];
    }];
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
}


#pragma mark - configKlineTimeChart
- (void)makeChoseKlineTimeChart {
    NSInteger index = [PriceIndexTool getPricePeriodIndex];
    [self.chartView setPriceChartIndex:index];
}



- (void)animationDidStart:(CAAnimation *)anim{
    [self changeOrientation:UIDeviceOrientationLandscapeLeft];
}

- (void)changeOrientation: (UIDeviceOrientation )position{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice] setValue:@(position) forKey:@"orientation"];
    }
}

#pragma mark - LandHeaderViewDelegate
- (void)PriceLandHeaderViewBack:(PriceChartView *)headerView {
    
   
    
 //   [self addAnimation:self.navigationController.view];
    
    [self changeOrientation:UIDeviceOrientationPortrait];
    

//    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    
    [self.navigationController popViewControllerAnimated:false];
    
    
    
    if ([self.delegate respondsToSelector:@selector(LandPriceletMakeChoseKlineTimeChart)]) {
        [self.delegate LandPriceletMakeChoseKlineTimeChart];
    }
}




#pragma mark - getter
- (PriceLandHeaderView *)landHeaderView {
    if (!_landHeaderView) {
        _landHeaderView = [[PriceLandHeaderView alloc] initWithFrame:CGRectMake(0, 0, GXScreenWidth, HeightLandScale_IOS6(40))];
        _landHeaderView.backgroundColor = PriceLandscape_HeaderViewColor;
        _landHeaderView.delegate = self;
    }
    return _landHeaderView;
}

- (PriceChartView *)chartView {
    if (!_chartView) {
        _chartView = [[PriceChartView alloc] initWithFrame:CGRectMake(0, HeightLandScale_IOS6(40), GXScreenWidth, GXScreenHeight - HeightLandScale_IOS6(40) - 5)];
        _chartView.delegate = self;
        _chartView.chartDirection = PriceChartDirectionLandScape;
        _chartView.modle = self.marketModel;
    }
    return _chartView;
}


- (BOOL)shouldAutorotate{
    return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        [self PriceLandHeaderViewBack:self.landHeaderView];
    }
    
}

- (void)dealloc {
    DLog(@"dealloc  !!!!!!!!!!! ");
}



@end
