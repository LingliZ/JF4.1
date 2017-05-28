//
//  PriceChartView.h
//  GXAppNew
//
//  Created by futang yang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FTTimeChart.h"
#import "FTKlineView.h"
#import "PriceMarketModel.h"



@class PriceChartView;
@class FTKlineItemData;
@class FTTimelineData;
@class FTTimeData;
@class JXSegment;




typedef NS_ENUM(NSUInteger, PriceChartDirection) {
    PriceChartDirectionVertical,
    PriceChartDirectionLandScape
};


@protocol PriceChartViewDelegate <NSObject>

@optional;

- (void)clickOnBottomIndexBtn;
- (void)clickOnSetIndexBtn;
- (void)klineView:(PriceChartView *)klineView didSelectIndex:(NSInteger)index;
- (void)priceChartTapOn:(PriceChartView *)chartView;


@end


@interface PriceChartView : UIView

@property (nonatomic, assign) id<PriceChartViewDelegate> delegate;

@property (nonatomic, strong) FTTimeChart *timelineView;
@property (nonatomic, strong) FTKlineView *klineView;
@property (nonatomic, strong) JXSegment *segeMentView;

@property (nonatomic, strong) FTTimeData *timeData;
@property (nonatomic, strong) FTKlineItemData *klineData;

@property (nonatomic, assign) KLineChartTopType topType;
@property (nonatomic, assign) KLineChartBottomType bottomType;
@property (nonatomic, assign) PriceChartDirection chartDirection;
@property (nonatomic, assign) NSInteger lastSaveDecimalPlaces;


@property (nonatomic, strong) PriceMarketModel *modle;





- (void)setPriceChartIndex:(NSInteger)index;
- (void)RedrawKlineChart:(KLineChartTopType)type;
- (void)RedrawIndexChart:(KLineChartBottomType)type;

- (void)setKlineViewData:(NSArray *)dataArray TopType:(KLineChartTopType)topType bottomType:(KLineChartBottomType)bottomType peirod:(NSString *)peirod;
- (void)drawKlineAllChart;


- (void)setTimeViewData:(NSArray *)dataArray  period:(NSString *)peirod;
- (void)drawTimeChrt;

- (void)reDrawAllChart;




- (void)drawMaChart;
- (void)drawBOLLChart;

- (void)drawMacdIndexChart;
- (void)drawRSIlineIndexChart;
- (void)drawKDJlineIndexChart;
- (void)drawADXLineIndexChart;
- (void)drawATRLineIndexChart;

@end
