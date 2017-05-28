//
//  PriceChartView.m
//  GXAppNew
//
//  Created by futang yang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "PriceChartView.h"


#import "FTKlineModel.h"
#import "FTKlineItemData.h"

#import "FTIndexParamHeader.h"
#import "PriceIndexTool.h"
#import "FTComputerIndex.h"
#import "CCSTitledLine.h"
#import "JXSegment.h"
#import "klineTopHighligthView.h"
#import "TimeTopHighlitView.h"
#import "FTTimelineData.h"
#import "SwitchIndexView.h"
#import "FTChartDealvalueTool.h"



#define TICK   NSDate *startTime = [NSDate date]
#define TOCK   NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])


// **************** 分时
#define ChartBackGroudColor GXRGBColor(24, 24, 31)
#define ChartTimeLinecolor [UIColor colorWithHexString:@"4082F4"]
#define ChartTimeAvgLinecolor [UIColor colorWithHexString:@"C9740F"]
#define ChartTimeCrossLineColor [UIColor colorWithHexString:@"C3C4C6"]
#define ChartTimeCrossLineColor [UIColor colorWithHexString:@"C3C4C6"]
#define ChartTimeGradientStartColor [UIColor colorWithHexString:@"654082"]
#define ChartTimeGradientEndColor [UIColor colorWithHexString:@"004082"]



// 边框
#define ChartTBorderColor [UIColor colorWithHexString:@"2D2D34"]
#define ChartTBorderWidth 0.5
#define ChartTimeCrossPointColor [UIColor colorWithHexString:@"C3C4C6"]
#define ChartTCloseLineColor [UIColor colorWithHexString:@"6180A5"]
#define ChartTCloseLineWidth 0.6

// 提示
#define ChartTtipBgColor [UIColor colorWithHexString:@"34384B"]
#define ChartTtipBorderColor [UIColor colorWithHexString:@"585862"]
#define ChartTtipBorderWidth 0.5


// ************* k线
#define ChartKBorderColor [UIColor colorWithHexString:@"2D2D34"]
#define ChartkBorderWidth 0.5


// SegeMentView
#define Chart_SegeMentViewColor GXRGBColor(30, 30, 38) 
#define Chart_SegeMentBoderColor GXRGBColor(24, 24, 32)
#define Chart_SegeMentBoderWidth 0.5
#define Chart_SegeMentViewHeight 36.f

// switchIndexView
#define Chart_SwitchIndexBGColor GXRGBColor(38, 40, 52)
#define Chart_SwitchIndexBoderColor GXRGBColor(45, 45, 52)
#define Chart_SwitchIndexBoderWidth 0.5


typedef void(^btnClick)();

@interface PriceChartView ()<UIGestureRecognizerDelegate, FTKlineViewDelegate,FTTimeChartDelegate,JXSegmentDelegate,SwitchIndexViewDelegate>

// 手势相关
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGestrue;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@property (nonatomic, strong) klineTopHighligthView *klineTopHighView;
@property (nonatomic, strong) TimeTopHighlitView *timeTopHighView;

@property (nonatomic, copy) NSString *openString;
@property (nonatomic, copy) NSString *highString;
@property (nonatomic, copy) NSString *lowString;
@property (nonatomic, copy) NSString *closeString;


@property (nonatomic, strong) SwitchIndexView *switchIndexView;
@property (nonatomic, copy) NSString *peirod;




@end

@implementation PriceChartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}


- (void)config {
    
    
    // 时间选择
    [self addSubview:self.segeMentView];
    
    // 添加分时图
    [self addSubview:self.timelineView];
    
    // 添加K线图
    [self addSubview:self.klineView];
    
    // 添加指标切换
    [self addSubview:self.switchIndexView];
 
    
    [self addGestures];
}


- (void)setChartDirection:(PriceChartDirection)chartDirection {
    _chartDirection = chartDirection;

    NSArray *array = @[@"分时", @"5日", @"日K", @"周K", @"月K", @"1分",@"5分",@"15分",@"30分",@"60分",@"240分"];
    
    if (chartDirection == PriceChartDirectionVertical) {
        [self.segeMentView updateChannels:array isVertical:YES];
    } else {
       [self.segeMentView updateChannels:array isVertical:NO];
    }
}


- (void)addGestures {
    [self.klineView addGestureRecognizer:self.longPressGesture];
    [self.klineView addGestureRecognizer:self.panGesture];
    [self.klineView addGestureRecognizer:self.pinchGestrue];
    
    [self addGestureRecognizer:self.tapGesture];
}





#pragma mark - publicMethod
- (void)setPriceChartIndex:(NSInteger)index {
    [self.segeMentView didChengeToIndex:index];
}


#pragma mark - 分时图
- (void)setTimeViewData:(NSArray *)dataArray period:(NSString *)peirod {

    if (self.modle.isTD == 1) {
        [self setTimeViewForTD:dataArray period:peirod];
    } else {
        [self setTimeViewForNormal:dataArray period:peirod];
    }
    
    
}


- (void)setTimeViewForNormal:(NSArray *)dataArray period:(NSString *)peirod {

    
    NSMutableArray *context = [NSMutableArray array];
    NSString *lastClose;
    NSMutableArray *dates = [NSMutableArray array];
    NSString *maxValue = nil;
    NSString *minValue = nil;
    NSMutableArray *dayTimeTitles = [NSMutableArray array];

    NSInteger currentCount = 0;
    
    float lastCurrentP = 0;//非当日最后数据补齐
    //开盘时间~第一条数据
    for (NSInteger j = dataArray.count - 1; j >= 0; j--) {
        
        FTTimelineData *timeLineData = dataArray[j];
        if (j == 0) {
            FTTimelineData *firstTimedata = dataArray[0];
            lastClose = firstTimedata.lastclose;
        }
        
        
        NSArray *durationArray = [[timeLineData.duration substringFromIndex:2] componentsSeparatedByString:@"H"];
        NSInteger hours = [[durationArray objectAtIndex:0] integerValue];
        NSInteger minutes = 0;
        if (durationArray.count == 2) {
            minutes = [[[durationArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@"M" withString:@""] integerValue];
        }
        
        int prei = 0;
        long durationTime = hours*60*60*1000+minutes*60*1000;
        int count;
        if (j == 0)
            count = (int) durationTime / 60000 + 1;
        else
            count = (int) durationTime / 60000;
        
        NSArray *yValue = timeLineData.timeLineItemList;
        long long openTime = timeLineData.openTime;
        
        for (int i = 0; i < count; i++, openTime += 60000) {
            
            if (prei < [yValue count]) {
                FTTimeLineEntity *timeLineEntity = ((FTTimeLineEntity*)[yValue objectAtIndex:prei]);
                if (timeLineEntity.time > openTime) {
                    [dates addObject:[NSString stringWithFormat:@"%lld",openTime]];
                    [context addObject:timeLineEntity.current];
                    continue;
                }
                [context addObject:timeLineEntity.current];
                [dates addObject:[NSString stringWithFormat:@"%lld",timeLineEntity.time]];
                prei++;
                lastCurrentP = [timeLineEntity.current floatValue];
                
            } else {
                if (j != 0) {//非今日最后无数据情况下取当日最后一条
                    [context addObject:[NSString stringWithFormat:@"%f",lastCurrentP]];
                    [dates addObject:[NSString stringWithFormat:@"%lld",openTime]];
                } else {//当日最后数据不处理
                    //[context addObject:[NSString stringWithFormat:@"0"]];
                    [context addObject:[NSNull null]];
                    [dates addObject:[NSString stringWithFormat:@"%lld",openTime]];
                }
            }
        }
        [dayTimeTitles addObject:@(currentCount)];
        currentCount += count;
    }
    
    
    
    
    
    NSMutableArray *tempContext = [NSMutableArray arrayWithCapacity:context.count];
    for (id obj in context) {
        if (![obj isKindOfClass:[NSNull class]]) {
            [tempContext addObject:obj];
        }
    }
    
    FTTimeData *data = [[FTTimeData alloc] init];
    maxValue = [tempContext valueForKeyPath:@"@max.floatValue"];
    minValue = [tempContext valueForKeyPath:@"@min.floatValue"];
    
    data.context = context;
    data.dates = dates;
    data.maxValue = maxValue;
    data.minValue = minValue;
    data.lastClose = lastClose;
    
    self.timeData = data;
    self.timelineView.dayTimeTitles = dayTimeTitles;
    self.timelineView.timeTypeCount = [peirod integerValue];
    self.timelineView.saveDecimalPlaces = self.lastSaveDecimalPlaces;
}


//- (void)setTimeViewForTD:(NSArray *)dataArray period:(NSString *)peirod {
//    
//    NSMutableArray *context = [NSMutableArray array];
//    NSMutableArray *dates = [NSMutableArray array];
//    NSString *lastClose;
//    
//    NSString *maxValue = nil;
//    NSString *minValue = nil;
//    
//    NSMutableArray *dayTimeTitles = [NSMutableArray array];
//    NSMutableArray *temp = [NSMutableArray new];
//    NSInteger currentCount = 0;
//    
//    
//    float lastCurrentP = 0;//非当日最后数据补齐
//    
//    for (NSInteger j = dataArray.count - 1; j >= 0; j--) {  //倒序遍历 j=0 今天 j=1 昨天 j=2 前天。。。。
//        
//        // 大的模型
//        FTTimelineData *timeLineData = dataArray[j];
//        
//        
//        NSString *TD5tradeData = timeLineData.tradeDate;
//        
//        // 获取 昨日收盘价
//        if (j == 0) {
//            FTTimelineData *firstTimedata = dataArray[0];
//            lastClose = firstTimedata.lastclose;
//        }
//        
//        
//        int prei = 0;
//    
// 
//        
//        int count;
//        
//        if (j == 0) {
//            count = (11 * 60 * 60 * 1000)/ 60000 + 1;
//        } else {
//            count = (11 * 60 * 60 * 1000)/ 60000;
//        }
//        
//        
//        
//        
//        NSArray *yValue = timeLineData.timeLineItemList;
//        
//        long long openTime = timeLineData.openTime;
//        long startTime = openTime;//openTime赋值方便计算分割点时间（跨过中间休市时间如：2：30-9：00，780*60000毫秒时间戳）
//        
//        for (int i = 0; i < 660; i++) {
//            
//            if (prei < yValue.count) {
//                
//                FTTimeLineEntity *timeLineEntity = ((FTTimeLineEntity*)[yValue objectAtIndex:prei]);
//                
//                if (i == 390) {
//                    openTime = startTime + 780 * 60000; //2:30/09:00 openTime  按9点
//                } else if (i == 540) {
//                    openTime = startTime + 1050 * 60000; //11:30/13:00 openTime按13点
//                }
//                
//                if (timeLineEntity.time > openTime) {
//                    [dates addObject:[NSString stringWithFormat:@"%lld",openTime]];
//                    [context addObject:timeLineEntity.current];
//                    openTime += 60000;//时间戳指针往后一分
//                    continue;
//                }
//                
//                [context addObject:timeLineEntity.current];
//                [dates addObject:[NSString stringWithFormat:@"%lld",timeLineEntity.time]];
//                [temp addObject:timeLineEntity.current];
//                lastCurrentP = [timeLineEntity.current floatValue];
//                prei++;
//                openTime += 60000;
//            }
//            
//            
//            else {
//                if (j != 0) {//非今日最后无数据情况下取当日最后一条
//                    [context addObject:[NSString stringWithFormat:@"%f",lastCurrentP]];
//                    [dates addObject:[NSString stringWithFormat:@"%lld",openTime]];
//                    [temp addObject:[NSString stringWithFormat:@"%f",lastCurrentP]];
//                    
//                } else {//当日最后数据不处理
//                    
//                    if (i == 390) {
//                        openTime = startTime + 780 * 60000;
//                    } else if (i == 540) {
//                        openTime = startTime + 1050 * 60000;
//                    }
//                    
//                    
//                    [context addObject:[NSNull null]];
//                    [dates addObject:[NSString stringWithFormat:@"%lld",openTime]];
//                }
//                openTime +=60000;
//            }
//        }
//        
//        [dayTimeTitles addObject:TD5tradeData];
//        currentCount += count;
//    }
//    
//    // 移除空数组
//    NSMutableArray *tempContext = [NSMutableArray arrayWithCapacity:context.count];
//    for (id obj in context) {
//        if (![obj isKindOfClass:[NSNull class]]) {
//            [tempContext addObject:obj];
//        }
//    }
//    
//    FTTimeData *data = [[FTTimeData alloc] init];
//    maxValue = [tempContext valueForKeyPath:@"@max.floatValue"];
//    minValue = [tempContext valueForKeyPath:@"@min.floatValue"];
//    
//    data.context = context;
//    data.dates = dates;
//    data.maxValue = maxValue;
//    data.minValue = minValue;
//    data.lastClose = lastClose;
//    
//    self.timeData = data;
//    self.timelineView.dayTimeTitles = dayTimeTitles;
//    self.timelineView.timeTypeCount = [peirod integerValue];
//    self.timelineView.saveDecimalPlaces = self.lastSaveDecimalPlaces;
//    
//}



- (void)setTimeViewForTD:(NSArray *)dataArray period:(NSString *)peirod {
    
    NSMutableArray *context = [NSMutableArray array];
    NSMutableArray *dates = [NSMutableArray array];
    NSString *lastClose;
    
    NSString *maxValue = nil;
    NSString *minValue = nil;
    
    NSMutableArray *dayTimeTitles = [NSMutableArray array];
    NSMutableArray *temp = [NSMutableArray new];
    NSInteger currentCount = 0;
    
    
    float lastCurrentP = 0;//非当日最后数据补齐
    
    for (NSInteger j = dataArray.count - 1; j >= 0; j--) {  //倒序遍历 j=0 今天 j=1 昨天 j=2 前天。。。。
        
        // 大的模型
        FTTimelineData *timeLineData = dataArray[j];
        NSString *TD5tradeData = timeLineData.tradeDate;
        // 获取 昨日收盘价
        if (j == 0) {
            FTTimelineData *firstTimedata = dataArray[0];
            lastClose = firstTimedata.lastclose;
        }
        
        
        
        NSArray *durationArray = [[timeLineData.duration substringFromIndex:2] componentsSeparatedByString:@"H"];
        NSInteger hours = [[durationArray objectAtIndex:0] integerValue];
        NSInteger minutes = 0;
        if (durationArray.count == 2) {
            minutes = [[[durationArray objectAtIndex:1] stringByReplacingOccurrencesOfString:@"M" withString:@""] integerValue];
        }
        
        
        int prei = 0;
        int count;
        
        if (j == 0) {
            count = (11 * 60 * 60 * 1000)/ 60000 + 1;
        } else {
            count = (11 * 60 * 60 * 1000)/ 60000;
        }
        NSArray *yValue = timeLineData.timeLineItemList;
        
        long long openTime = timeLineData.openTime;
        
        // openTime = openTime + (hours/24) * 24 * 60 * 60 * 1000;
        
        long startTime = openTime;
        
        //openTime赋值方便计算分割点时间（跨过中间休市时间如：2：30-9：00，780*60000毫秒时间戳）
        
        for (int i = 0; i < 660; i++) {
            
            if (prei < yValue.count) {
                
                FTTimeLineEntity *timeLineEntity = ((FTTimeLineEntity*)[yValue objectAtIndex:prei]);
                if (i == 390) {
                    NSLog(@"%ld", startTime);
                 //   openTime = startTime + 780 * 60000; //2:30/09:00 openTime  按9点
                    
                    openTime = startTime + 780 * 60000 + (hours/24) * 24 * 60 * 60 * 1000;
                    
                } else if (i == 540) {
                   // openTime = startTime + 1050 * 60000; //11:30/13:00 openTime按13点
                    openTime = startTime + 1050 * 60000 + (hours/24) * 24 * 60 * 60 * 1000;
                }
                
                
                // 补全
                if (timeLineEntity.time > openTime) {
                    [dates addObject:[NSString stringWithFormat:@"%lld",openTime]];
                    [context addObject:timeLineEntity.current];
                    openTime += 60000;//时间戳指针往后一分
                    continue;
                }
                
                [context addObject:timeLineEntity.current];
                [dates addObject:[NSString stringWithFormat:@"%lld",timeLineEntity.time]];
                [temp addObject:timeLineEntity.current];
                lastCurrentP = [timeLineEntity.current floatValue];
                prei++;
                openTime += 60000;
            }
            
            
            else {
                if (j != 0) {//非今日最后无数据情况下取当日最后一条
                    [context addObject:[NSString stringWithFormat:@"%f",lastCurrentP]];
                    [dates addObject:[NSString stringWithFormat:@"%lld",openTime]];
                    [temp addObject:[NSString stringWithFormat:@"%f",lastCurrentP]];
                    
                } else {//当日最后数据不处理
                    
                    if (i == 390) {
                        openTime = startTime + 780 * 60000;
                    } else if (i == 540) {
                        openTime = startTime + 1050 * 60000;
                    }
                    
                    
                    [context addObject:[NSNull null]];
                    [dates addObject:[NSString stringWithFormat:@"%lld",openTime]];
                }
                openTime +=60000;
            }
        }
        
        [dayTimeTitles addObject:TD5tradeData];
        currentCount += count;
    }
    
    // 移除空数组
    NSMutableArray *tempContext = [NSMutableArray arrayWithCapacity:context.count];
    for (id obj in context) {
        if (![obj isKindOfClass:[NSNull class]]) {
            [tempContext addObject:obj];
        }
    }
    
    FTTimeData *data = [[FTTimeData alloc] init];
    maxValue = [tempContext valueForKeyPath:@"@max.floatValue"];
    minValue = [tempContext valueForKeyPath:@"@min.floatValue"];
    
    data.context = context;
    data.dates = dates;
    data.maxValue = maxValue;
    data.minValue = minValue;
    data.lastClose = lastClose;
    
    self.timeData = data;
    self.timelineView.dayTimeTitles = dayTimeTitles;
    self.timelineView.timeTypeCount = [peirod integerValue];
    self.timelineView.saveDecimalPlaces = self.lastSaveDecimalPlaces;
    
}







- (void)drawTimeChrt {
    
    if (self.klineView) {
        [self.klineView setHidden:YES];
        [self.switchIndexView setHidden:YES];
    }
    
    [self.timelineView setHidden:NO];

    
    if (self.modle.isTD == 1) {
        self.timelineView.isTD = YES;
    } else {
        self.timelineView.isTD = NO;
    }
    

    [self.timelineView drawChartWithData:self.timeData];
}



#pragma mark - k线图
- (void)setKlineViewData:(NSArray *)dataArray TopType:(KLineChartTopType)topType bottomType:(KLineChartBottomType)bottomType peirod:(NSString *)peirod {
    
    _topType = topType;
    _bottomType = bottomType;
    _peirod = peirod;
    
    switch (topType) {
        case MA:{
            [self.switchIndexView didChengeToTopIndex:0];
            break;
        }
        case BOLL:{
            [self.switchIndexView didChengeToTopIndex:1];
            break;
        }
        default:
            break;
    }
    
    
    switch (bottomType) {
        case MACD: {
            [self.switchIndexView didChengeToIndex:0];
            break;
        }
        case KDJ: {
            [self.switchIndexView didChengeToIndex:1];
            break;
        }
        case RSI: {
            [self.switchIndexView didChengeToIndex:2];
            break;
        }
        case ADX: {
            [self.switchIndexView didChengeToIndex:3];
            break;
        }
        case ATR: {
            [self.switchIndexView didChengeToIndex:4];
            break;
        }
            
        default:
            break;
    }
    
    
    
    
    NSString *klineChangeTitle = [self configTopIndexdisplayName:topType];
    NSString *indexChangeTitle = [self configBottomIndexdisplayName:bottomType];

    
    NSMutableArray *dates = [NSMutableArray new];
    NSMutableArray *context = [NSMutableArray new];
    
    for (NSInteger i = dataArray.count - 1; i >= 0; i--) {
        FTKlineModel *model = dataArray[i];
        [dates addObject:model.time];
        [context addObject:model];
    }
    
    _klineData = [[FTKlineItemData alloc] init];
    _klineData.dates = dates;
    _klineData.context = context;
    
    if (topType == MA) {
        
        FTMaParamArray *maParamArray = [PriceIndexTool GetMaParamArray];
        NSArray *colorArray = maParamArray.colorArray;
        
        NSMutableArray *maLines = [NSMutableArray array];
        
        for (NSInteger i = 0; i < maParamArray.indexArray.count; i++) {
            CCSTitledLine *line = [FTComputerIndex computeMAData:_klineData param:maParamArray.indexArray[i]];
            line.color = colorArray[i];
            [maLines addObject:line];
        }
     
        _klineData.lineContexts = maLines;
        _klineData.indexContexts = [self ComputIndexChartWith:bottomType];
        
        
        self.klineView.topIndexType = topType;
        self.klineView.bottomIndexType = bottomType;
        
       
        self.klineView.klinItemData = _klineData;
    }
    
    if (topType == BOLL) {
        
        FTBollParam *bollParam = [PriceIndexTool GetBollParam];
        NSArray *lineContexts = [FTComputerIndex computeBOLLData:_klineData param:bollParam];
        
        _klineData.lineContexts = lineContexts;
        _klineData.indexContexts = [self ComputIndexChartWith:bottomType];
        
        self.klineView.topIndexType = topType;
        self.klineView.bottomIndexType = bottomType;
        
        self.klineView.klinItemData = _klineData;
    }
    
    
    self.klineView.klineChangeTitle = klineChangeTitle;
    self.klineView.indexChangeTitle = indexChangeTitle;

}


- (void)RedrawKlineChart:(KLineChartTopType)type {
    if (type == MA) {
        [self drawMaChart];
    }
    
    if (type == BOLL) {
        [self drawBOLLChart];
    }
}

- (void)RedrawIndexChart:(KLineChartBottomType)type {
    
    if (type == RSI) {
        [self drawRSIlineIndexChart];
    }
    
    if (type == KDJ) {
        [self drawKDJlineIndexChart];
    }
    
    if (type == MACD) {
        [self drawMacdIndexChart];
    }
    if (type == ADX) {
        [self drawADXLineIndexChart];
    }
    if (type == ATR) {
        [self drawATRLineIndexChart];
    }
    
}


- (void)drawKlineAllChart {
    if (self.timelineView) {
        [self.timelineView setHidden:YES];
    }

    [self.klineView setHidden:NO];
    self.switchIndexView.hidden = self.chartDirection == PriceChartDirectionVertical ? YES : NO;
    
    //横竖
    _klineView.direction = (self.chartDirection == PriceChartDirectionVertical) ? KlineChartDirectionVertical : KlineChartDirectionLandscape;

    
    CGRect klineVerticalFrame = self.klineView.frame;
    CGRect klineLandscapFrame = CGRectMake(0, 40, self.width - 60, self.height - (40));
    
    _klineView.frame = self.chartDirection == PriceChartDirectionVertical ? klineVerticalFrame : klineLandscapFrame;
    _switchIndexView.frame = CGRectMake(self.width - 36 - 12,40,36,self.height-40);
    

    _klineView.isShowKlineYAxisTitle = self.chartDirection == PriceChartDirectionVertical ? NO : YES;
    _klineView.isShowIndexYAxisTitle = self.chartDirection == PriceChartDirectionVertical ? NO : YES;
    
    if (self.chartDirection == PriceChartDirectionLandScape) {
        _klineView.leftMargin = 50;
        _klineView.rightMargin = 2;
        _klineView.topMargin = 0;
        _klineView.bottomMargin = 105;
        _klineView.yAxisIsOutSide = YES;
    }

    
    _klineView.period = _peirod;
    _klineView.lastSaveDecimalPlaces = self.lastSaveDecimalPlaces;
    
    [self.klineView drawChartWithData:_klineData];
}



- (void)reDrawAllChart {
    
    
    _klineView.period = _peirod;
    
    [self.klineView drawChart1111WithData:_klineData];
}




#pragma mark - MA Chart
// *********** K线视图
- (void)drawMaChart {
    
    self.topType = MA;
    
    NSMutableArray *lineContexts = [NSMutableArray array];
    FTMaParamArray *maParamArray = [PriceIndexTool GetMaParamArray];
    NSArray *colorArray = maParamArray.colorArray;
    
    
    for (NSInteger i = 0; i < maParamArray.indexArray.count; i++) {
        CCSTitledLine *line = [FTComputerIndex computeMAData:_klineData param:maParamArray.indexArray[i]];
        line.color = colorArray[i];
        [lineContexts addObject:line];
    }
    
    
    _klineData.lineContexts = lineContexts;
    
    self.klineView.topIndexType = MA;
    self.klineView.klinItemData = _klineData;
    self.klineView.klineChangeTitle = [self configTopIndexdisplayName:MA];
    [self.klineView setNeedsDisplay];
    
    
}

#pragma mark - BOLL Chart
- (void)drawBOLLChart {
    
    self.topType = BOLL;
    
    FTBollParam *bollParam = [PriceIndexTool GetBollParam];
    NSMutableArray *lineContexts = [FTComputerIndex computeBOLLData:_klineData param:bollParam];
    
    _klineData.lineContexts = lineContexts;
    self.klineView.topIndexType = BOLL;
    self.klineView.klinItemData = _klineData;
    self.klineView.klineChangeTitle = [self configTopIndexdisplayName:BOLL];
    
    [self.klineView setNeedsDisplay];
}


// *********** 指标视图
#pragma  mark - MACD Chart
- (void)drawMacdIndexChart {
    
    self.bottomType = MACD;
    
    FTMacdParam *macdParam = [PriceIndexTool GetMacdParam];
    NSArray *indexContexts = [FTComputerIndex computerMACDWithData:_klineData param:macdParam];
    _klineData.indexContexts = indexContexts;
    
    self.klineView.bottomIndexType = MACD;
    self.klineView.klinItemData = _klineData;
    self.klineView.indexChangeTitle = [self configBottomIndexdisplayName:MACD];
    [self.klineView setNeedsDisplay];
}

#pragma  mark - KDJ Chart
- (void)drawKDJlineIndexChart {
    
    self.bottomType = KDJ;

    FTKdjParam *kdjParam = [PriceIndexTool GetKdjParam];
    NSArray *indexContexts = [FTComputerIndex computeKDJData:_klineData kdjParam:kdjParam];
    _klineData.indexContexts = indexContexts;
    
    self.klineView.bottomIndexType = KDJ;
    self.klineView.klinItemData = _klineData;
    self.klineView.indexChangeTitle = [self configBottomIndexdisplayName:KDJ];
    [self.klineView setNeedsDisplay];
}

#pragma  mark - RSI Chart
- (void)drawRSIlineIndexChart {
    
    self.bottomType = RSI;

    FTRsiParam *rsiParam = [PriceIndexTool GetRsiParam];
    NSMutableArray *indexContexts = [NSMutableArray array];
    
    [indexContexts addObject:[FTComputerIndex computeRSIData:_klineData period:rsiParam.period1]];
    [indexContexts addObject:[FTComputerIndex computeRSIData:_klineData period:rsiParam.period2]];
    [indexContexts addObject:[FTComputerIndex computeRSIData:_klineData period:rsiParam.period3]];
    
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSInteger i = 0; i < indexContexts.count; i++) {
        CCSTitledLine *line = indexContexts[i];
        line.color = rsiParam.colorArray[i];
        [tempArray addObject:line];
    }
    
    indexContexts = tempArray;
    
    _klineData.indexContexts = indexContexts;
    
    self.klineView.bottomIndexType = RSI;
    self.klineView.klinItemData = _klineData;
    self.klineView.indexChangeTitle = [self configBottomIndexdisplayName:RSI];
    
    [self.klineView setNeedsDisplay];
    
}
#pragma  mark - ADX Chart
- (void)drawADXLineIndexChart {
    self.bottomType = ADX;
    
    NSArray *indexContexts = [FTComputerIndex computeADXData:_klineData];
    _klineData.indexContexts = indexContexts;
    
    self.klineView.bottomIndexType = ADX;
    self.klineView.klinItemData = _klineData;
    self.klineView.indexChangeTitle = [self configBottomIndexdisplayName:ADX];
    
    
    [self.klineView setNeedsDisplay];
}


- (void)drawATRLineIndexChart {
    self.bottomType = ATR;
    
    NSArray *indexContexts = [FTComputerIndex computeATRData:_klineData];
    _klineData.indexContexts = indexContexts;
    
    self.klineView.bottomIndexType = ATR;
    self.klineView.klinItemData = _klineData;
    self.klineView.indexChangeTitle = [self configBottomIndexdisplayName:ATR];
    
    [self.klineView setNeedsDisplay];
}


#pragma mark - 计算指标数据方法
- (NSArray *)ComputIndexChartWith:(KLineChartBottomType)type {
    
    NSMutableArray *indexLinesArray = [[NSMutableArray alloc] init];
    
    if (type == MACD) {
        FTMacdParam *macdParam = [PriceIndexTool GetMacdParam];
        indexLinesArray = [FTComputerIndex computerMACDWithData:_klineData param:macdParam];
        return indexLinesArray;
    }
    
    if (type == KDJ) {
        FTKdjParam *kdjParam = [PriceIndexTool GetKdjParam];
        indexLinesArray = [FTComputerIndex computeKDJData:_klineData kdjParam:kdjParam];
        return indexLinesArray;
    }
    
    if (type == RSI) {
        FTRsiParam *rsiParam = [PriceIndexTool GetRsiParam];
        CCSTitledLine *lineRSI1 = [FTComputerIndex computeRSIData:_klineData period:rsiParam.period1];
        CCSTitledLine *lineRSI2 = [FTComputerIndex computeRSIData:_klineData period:rsiParam.period2];
        CCSTitledLine *lineRSI3 = [FTComputerIndex computeRSIData:_klineData period:rsiParam.period3];
        indexLinesArray = @[lineRSI1,lineRSI2,lineRSI3].mutableCopy;
        
        NSMutableArray *tempArray = [NSMutableArray array];
        for (NSInteger i = 0; i < indexLinesArray.count; i++) {
            CCSTitledLine *line = indexLinesArray[i];
            line.color = rsiParam.colorArray[i];
            [tempArray addObject:line];
        }
        indexLinesArray = tempArray;
    }
    
    if (type == ADX) {
        indexLinesArray = [FTComputerIndex computeADXData:_klineData];
    }
    
    if (type == ATR) {
        indexLinesArray = [FTComputerIndex computeATRData:_klineData];
    }

    return indexLinesArray;
}

#pragma mark - KlineViewDelegate
- (void)klineView:(FTKlineView *)klineView ClickOnChangeTopIndex:(UIButton *)btn topIndexType:(KLineChartTopType)type{
    
    if (type == MA) {
        [PriceIndexTool saveTopBottomParamTop:BOLL];
        [self drawBOLLChart];
    } else if (type == BOLL) {
        [PriceIndexTool saveTopBottomParamTop:MA];
        [self drawMaChart];
        
    }
}



- (NSString *)configTopIndexdisplayName:(KLineChartTopType)type {
    NSString *displayName = nil;
    if (type == MA) {
        FTMaParamArray *maParamArray = [PriceIndexTool GetMaParamArray];
        displayName = maParamArray.displayName;
        return displayName;
    }
    
    if (type == BOLL) {
        
        FTBollParam *bollParam = [PriceIndexTool GetBollParam];
        displayName = bollParam.displayName;
        return displayName;
    }
    
    return displayName;
}


- (NSString *)configBottomIndexdisplayName:(KLineChartBottomType)type {
    NSString *displayName = nil;
    if (type == MACD) {
        FTMacdParam *macdParam = [PriceIndexTool GetMacdParam];
        displayName = [NSString stringWithFormat:@"MACD(%d,%d,%d)",macdParam.shortPeriod,macdParam.longPeriod,macdParam.macdPeriod];
        return displayName;
    }
    
    if (type == RSI) {
        FTRsiParam *rsiParam = [PriceIndexTool GetRsiParam];
        displayName = [NSString stringWithFormat:@"RSI(%d,%d,%d)",rsiParam.period1,rsiParam.period2,rsiParam.period3];
        return displayName;
    }
    
    if (type == KDJ) {
        FTKdjParam *kdjParam = [PriceIndexTool GetKdjParam];
        displayName = [NSString stringWithFormat:@"KDJ(%d,%d,%d)",kdjParam.Kperiod,kdjParam.Dperiod,kdjParam.Jperiod];
        return displayName;
    }
    
    if (type == ADX) {
        displayName = @"ADX";
    }
    
    if (type == ATR) {
        displayName = @"ATR";
    }
    
    return displayName;
}





// 跳转按钮
- (void)klineView:(FTKlineView *)klineView ClickOnChangeBottomIndex:(UIButton *)btn bottomIndexType:(KLineChartBottomType)type {
    if ([self.delegate respondsToSelector:@selector(clickOnBottomIndexBtn)]) {
        [self.delegate clickOnBottomIndexBtn];
    }
}

// 底部设置按钮
- (void)klineView:(FTKlineView *)klineView ClickOnSetIndexButton:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(clickOnSetIndexBtn)]) {
        [self.delegate clickOnSetIndexBtn];
    }
}


// 数据显示
- (void)klineView:(FTKlineView *)klineView TouchOnkline:(FTKlineModel *)kline Context:(NSArray *)context AtIndex:(NSInteger)index {
    
    if (self.klineView.hidden) {
        return;
    }
    
    self.klineTopHighView.hidden = NO;
    DLog(@"开:%@ 昨:%@ 高:%f 低:%f",kline.open,kline.close,kline.high,kline.low);
    
    self.klineTopHighView.value1.text = [FTChartDealvalueTool dealDecimalWithNum:@([kline.open floatValue]) DecimalPlaces:self.lastSaveDecimalPlaces];
    self.klineTopHighView.value2.text = [FTChartDealvalueTool dealDecimalWithNum:@(kline.high) DecimalPlaces:self.lastSaveDecimalPlaces];
    self.klineTopHighView.value3.text =  [FTChartDealvalueTool dealDecimalWithNum:@(kline.low) DecimalPlaces:self.lastSaveDecimalPlaces];
    self.klineTopHighView.value4.text = [FTChartDealvalueTool dealDecimalWithNum:@([kline.close floatValue]) DecimalPlaces:self.lastSaveDecimalPlaces];
    
    if (index == 0) {
        
        self.klineTopHighView.value1.textColor = [self compareValue:kline.open lastClose:kline.open];
        self.klineTopHighView.value2.textColor = [self compareValue:[NSString stringWithFormat:@"%f",kline.high] lastClose:kline.open];
        self.klineTopHighView.value3.textColor = [self compareValue:[NSString stringWithFormat:@"%f",kline.low] lastClose:kline.open];
        self.klineTopHighView.value4.textColor = [self compareValue:kline.close lastClose:kline.open];
        
    } else {
        
        FTKlineModel *lastKline = context[index - 1];
        self.klineTopHighView.value1.textColor = [self compareValue:kline.open lastClose:lastKline.close];
        self.klineTopHighView.value2.textColor = [self compareValue:[NSString stringWithFormat:@"%f",kline.high] lastClose:lastKline.close];
        self.klineTopHighView.value3.textColor = [self compareValue:[NSString stringWithFormat:@"%f",kline.low] lastClose:lastKline.close];
        self.klineTopHighView.value4.textColor = [self compareValue:kline.close lastClose:lastKline.close];
    }
    
}


- (void)klineViewLongPressCancle:(FTKlineView *)klineView {
    if (self.klineTopHighView.hidden == NO) {
        self.klineTopHighView.hidden = YES;
    }
}



#pragma mark - TimeChartDelegate
- (void)timeChart:(FTTimeChart *)timeChart timeData:(FTTimeData *)timeData longPressInTime:(NSString *)time price:(NSString *)price changeValue:(NSString *)changeValue {
    
    DLog(@"%@  %@  %@", time, price, changeValue);
    
    if (self.timelineView.hidden) {
        return;
    }
    
    self.timeTopHighView.hidden = NO;
    self.timeTopHighView.timeLabel.text = time;
    
    
    UIColor *textColor = [self compareValue:price lastClose:timeData.lastClose];
    self.timeTopHighView.priceValueLable.text = price;
    self.timeTopHighView.priceValueLable.textColor = textColor;
    
    self.timeTopHighView.changeValueLabel.text = changeValue;
    self.timeTopHighView.changeValueLabel.textColor = textColor;
}

- (void)timeChartLongPressCancle:(FTTimeChart *)timeChart {
    
    if (self.timeTopHighView.hidden == NO) {
        self.timeTopHighView.hidden = YES;
    }
    
}

- (void)timeChart:(FTTimeChart *)timeChart timeData:(FTTimeData *)timeData index:(NSInteger)index {
    
    NSLog(@"%ld", index);
    
}



#pragma mark -JXSegmentDelegate
- (void)JXSegment:(JXSegment*)segment didSelectIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(klineView:didSelectIndex:)]) {
        [self.delegate klineView:self didSelectIndex:index];
    }
  
}

#pragma mark - SwitchIndexViewDelegate
- (void)SwitchIndexView:(SwitchIndexView *)indexView didSelectTopIndex:(NSInteger)index {
    if (index == 0) {
        [PriceIndexTool saveTopBottomParamTop:MA];
        [self drawMaChart];
    }
    if (index == 1) {
        [PriceIndexTool saveTopBottomParamTop:BOLL];
        [self drawBOLLChart];
    }
}

- (void)SwitchIndexView:(SwitchIndexView *)indexView didSelectIndex:(NSInteger)index {
    if (index == 0) {
        [PriceIndexTool saveTopBottomParamBottom:MACD];
        [self drawMacdIndexChart];
    }
    if (index == 1) {
        [PriceIndexTool saveTopBottomParamBottom:KDJ];
        [self drawKDJlineIndexChart];
    }
    if (index == 2) {
        [PriceIndexTool saveTopBottomParamBottom:RSI];
        [self drawRSIlineIndexChart];
    }
    if (index == 3) {
        [PriceIndexTool saveTopBottomParamBottom:ADX];
        [self drawADXLineIndexChart];
    }
    if (index == 4) {
        [PriceIndexTool saveTopBottomParamBottom:ATR];
        [self drawATRLineIndexChart];
    }
}



- (UIColor *)compareValue:(NSString *)value lastClose:(NSString *)close {
    if ([value floatValue] > [close floatValue]) {
        return PriceRedColor;
    } else if ([value floatValue] < [close floatValue]) {
        return PriceGreenColor;
    } else {
        return PriceFontColor;
    }
    
}



#pragma mark EventMethod
- (void)longPressEvent:(UILongPressGestureRecognizer *)longPress {
    [self.klineView longPressEvent:longPress];
}


- (void)panEvent:(UIPanGestureRecognizer *)pan {
    [self.klineView panEventWith:pan];
}

- (void)pichEvent:(UIPinchGestureRecognizer *)pich {
    [self.klineView pichEventWith:pich];
}



- (void)tapEvent:(UITapGestureRecognizer *)tap {
    DLog(@"进入横屏模式");
    if ([self.delegate respondsToSelector:@selector(priceChartTapOn:)]) {
        [self.delegate priceChartTapOn:self];
    }
    
}




#pragma mark - getter
- (FTTimeChart *)timelineView {
    if (!_timelineView) {
        
        _timelineView = [[FTTimeChart alloc] initWithFrame:CGRectMake(0, Chart_SegeMentViewHeight, self.width, self.height - (Chart_SegeMentViewHeight))];
        
        _timelineView.delegate = self;
#warning test
        // 背景颜色
        _timelineView.backgroundColor = ChartBackGroudColor;
     //   _timelineView.backgroundColor = [UIColor grayColor];
        _timelineView.bottomMargin = 20;
        _timelineView.leftMargin = 0;
        
        
        // 文字颜色
        _timelineView.upperCloseColor = PriceRedColor;
        _timelineView.lowerCloseColor = PriceGreenColor;
        
        // 边框颜色
        _timelineView.axisBoderColor = ChartTBorderColor;
        _timelineView.axisBoderWidth = 0.5;
        //_timelineView.axisShadowWidth = 10.5;
        
        // 分割线颜色
        _timelineView.separatorColor = ChartTBorderColor;
        _timelineView.separatorWidth = ChartTBorderWidth;
        
        
        // 昨日收盘价线颜色
        _timelineView.lastCloseColor = ChartTCloseLineColor;
        
        // 折线颜色
        _timelineView.lineColor = ChartTimeLinecolor;
        
        // x轴y轴文字颜色
        _timelineView.yAxisTitleColor = PriceFontColor;
        _timelineView.xAxisTitleColor = PriceFontColor;
        
        // 阴影 51, 153, 255
        _timelineView.gradientStartColor = [ChartTimeLinecolor colorWithAlphaComponent:0.4];
        _timelineView.gradientEndColor = [ChartTimeGradientStartColor colorWithAlphaComponent:0.1];
        
        // 十字线
        _timelineView.crossLineColor = ChartTimeCrossLineColor;
        _timelineView.pointCrossLineWidth = 5;
        _timelineView.pointCrossColor = ChartTimeCrossPointColor;
        
        
        // 提示
        _timelineView.tipBackGroundColor = ChartTtipBgColor;
        _timelineView.tipBorderWidth = ChartTtipBorderWidth;
        _timelineView.tipBorderColor = ChartTtipBorderColor;
        
        // 方向
        _timelineView.direction = FTChartDirectionVertical;
        
        
        
#warning test
//        _timelineView.leftMargin = 30;
//        _timelineView.rightMargin = 30;
        
        
        _timelineView.saveDecimalPlaces = self.lastSaveDecimalPlaces;
        
        _timelineView.isTipsDisplayOutSide = NO;
        
        
        
        // 是否圆滑处理
        _timelineView.smoothPath = NO;
    }
    return _timelineView;
}

- (FTKlineView *)klineView {
    if (!_klineView) {
        _klineView = [[FTKlineView alloc] initWithFrame:CGRectMake(0, Chart_SegeMentViewHeight, self.width, self.height - (Chart_SegeMentViewHeight))];
        
        _klineView.delegate = self;
        
        _klineView.backgroundColor = ChartBackGroudColor;
        
        // 布局
        _klineView.leftMargin = 2;
        _klineView.rightMargin = 2;
        _klineView.topMargin = 0;
        _klineView.bottomMargin = 106;
        
        _klineView.showIndexChart = YES;
        _klineView.chartBackgroundColor = ChartBackGroudColor;
        
        // 边框颜色和宽度
        _klineView.axisShadowColor = ChartKBorderColor;
        _klineView.axisShadowWidth = ChartkBorderWidth;
        
        // 分割线颜色和宽度
        _klineView.separatorColor = ChartKBorderColor;
        _klineView.separatorWidth = ChartkBorderWidth;
        
        // X Y轴数值颜色
        _klineView.xAxisTitleColor = PriceLightGray;
        _klineView.xAxisTitleFont = GXFONT_PingFangSC_Regular(9);
        _klineView.yAxisTitleColor = PriceFontColor;
        _klineView.yAxisTitleFont = GXFONT_PingFangSC_Regular(9);
        
        //k线颜色
        _klineView.positiveLineColor = PositiveColor;
        _klineView.negativeLineColor = NegativeColor;
        
        //十字线颜色
        _klineView.croosLineColor = CroosLineColor;
        _klineView.pointCrossLineWidth = 5;
        
        // 提示
        _klineView.tipBackGroundColor = ChartTtipBgColor;
        _klineView.tipBorderWidth = ChartTtipBorderWidth;
        _klineView.tipBorderColor = ChartTtipBorderColor;
        _klineView.tipTextColor = [UIColor whiteColor];
        
        
       
        
        
        _klineView.isHollowLine = YES;
        
    }
    return _klineView;
}


- (JXSegment *)segeMentView {
    if (!_segeMentView) {
        _segeMentView = [[JXSegment alloc] initWithFrame:CGRectMake(0, 0, self.width, Chart_SegeMentViewHeight)];
        _segeMentView.backgroundColor = Chart_SegeMentViewColor;
        _segeMentView.divideSelectColor = GXRGBColor(62, 148, 251);
        _segeMentView.divideSelectColor = GXRGBColor(62, 148, 251);
        _segeMentView.titleSelectColor = GXRGBColor(62, 148, 251);
        _segeMentView.titleNormalColor = PriceLightGray;
        _segeMentView.textFont = GXFONT_PingFangSC_Regular(12);
        _segeMentView.delegate = self;
        [_segeMentView setBorderWithView:_segeMentView top:YES left:NO bottom:YES right:NO borderColor:Chart_SegeMentBoderColor borderWidth:Chart_SegeMentBoderWidth];
    
        
    }
    return _segeMentView;
}


- (klineTopHighligthView *)klineTopHighView {
    if (!_klineTopHighView) {
        _klineTopHighView = [[[NSBundle mainBundle] loadNibNamed:@"klineTopHighligthView" owner:self options:nil] firstObject];
        _klineTopHighView.frame = CGRectMake(0, 0, GXScreenWidth, Chart_SegeMentViewHeight - 1);
        _klineTopHighView.backgroundColor = TopHighligthViewColor;
        _klineTopHighView.hidden = YES;
        
        
        [self.segeMentView addSubview:_klineTopHighView];
    }
    return _klineTopHighView;
}





- (TimeTopHighlitView *)timeTopHighView {
    if (!_timeTopHighView) {
        _timeTopHighView = [[[NSBundle mainBundle] loadNibNamed:@"TimeTopHighlitView" owner:self options:nil] firstObject];
        _timeTopHighView.frame = CGRectMake(0, 0, GXScreenWidth, Chart_SegeMentViewHeight - 1);
        _timeTopHighView.backgroundColor = TopHighligthViewColor;
        _timeTopHighView.hidden = YES;
    
        [self.segeMentView addSubview:_timeTopHighView];
    }
    return _timeTopHighView;
}




- (SwitchIndexView *)switchIndexView {
    if (!_switchIndexView) {
        _switchIndexView = [[SwitchIndexView alloc] initWithFrame:CGRectMake(0,40,36,self.height-40)];
        _switchIndexView.backgroundColor = GXRGBColor(24, 24, 31);
        _switchIndexView.textFont = GXFONT_PingFangSC_Regular(11);
        _switchIndexView.titleSelectColor = GXRGBColor(62, 148, 251);
        _switchIndexView.titleNormalColor = GXRGBColor(101, 106, 137);
        [_switchIndexView setBorderWithView:_switchIndexView top:YES left:YES bottom:YES right:YES borderColor:Chart_SwitchIndexBoderColor borderWidth:Chart_SwitchIndexBoderWidth];
        _switchIndexView.delegate = self;
        [_switchIndexView updateTopChannels:@[@"MA",@"BOLL"]];
        [_switchIndexView updateBottomChannels:@[@"MACD",@"KDJ",@"RSI",@"ADX",@"ATR"]];
        _switchIndexView.hidden = YES;
        
    }
    return _switchIndexView;
}


- (UILongPressGestureRecognizer *)longPressGesture {
    if (!_longPressGesture) {
        _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    }
    return  _longPressGesture;
}

- (UIPanGestureRecognizer *)panGesture {
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
        _panGesture.delegate = self;
    }
    return _panGesture;
}

- (UIPinchGestureRecognizer *)pinchGestrue {
    if (!_pinchGestrue) {
        _pinchGestrue = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pichEvent:)];
    }
    return _pinchGestrue;
}


- (UITapGestureRecognizer *)tapGesture {
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
    }
    return _tapGesture;
}




@end
