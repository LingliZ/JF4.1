//
//  FTKlineView.h
//  ChartDemo
//
//  Created by futang yang on 2016/10/13.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FTKlineItemData;
@class FTKlineView;
@class FTKlineModel;

typedef NS_ENUM(NSUInteger, KlineChartDirection) {
    KlineChartDirectionVertical,
    KlineChartDirectionLandscape
};




@protocol FTKlineViewDelegate <NSObject>

@optional
- (void)klineView:(FTKlineView *)klineView ClickOnChangeTopIndex:(UIButton *)btn topIndexType:(KLineChartTopType)type;
- (void)klineView:(FTKlineView *)klineView ClickOnChangeBottomIndex:(UIButton *)btn bottomIndexType:(KLineChartBottomType)type;
- (void)klineView:(FTKlineView *)klineView ClickOnSetIndexButton:(UIButton *)btn;
- (void)klineView:(FTKlineView *)klineView TouchOnkline:(FTKlineModel *)kline Context:(NSArray *)context AtIndex:(NSInteger)index;
- (void)klineViewLongPressCancle:(FTKlineView *)klineView;


@end



@interface FTKlineView : UIView

@property (nonatomic, assign) CGFloat topMargin;
@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nonatomic, assign) CGFloat bottomMargin;
@property (nonatomic, assign) CGFloat xAxisWidth;
@property (nonatomic, assign) CGFloat timeAxisHeight;



/**
 图表的背景颜色
 */
@property (nonatomic, strong) UIColor *chartBackgroundColor;

/**
 K线宽度
 */
@property (nonatomic, assign) CGFloat klineWidth;

/**
 K线之间宽度
 */
@property (nonatomic, assign) CGFloat klinePadding;

/**
 均线颜色
 */
@property (nonatomic, assign) CGFloat movingAvgLineWidth;

/**
 阳线颜色
 */
@property (nonatomic, strong) UIColor *positiveLineColor;

/**
 阴线颜色
 */
@property (nonatomic, strong) UIColor *negativeLineColor;



/**
 y轴字体大小
 */
@property (nonatomic, strong) UIFont *yAxisTitleFont;

/**
 y轴数值颜色
 */
@property (nonatomic, strong) UIColor *yAxisTitleColor;

/**
 x轴数值大小
 */
@property (nonatomic, strong) UIFont *xAxisTitleFont;

/**
 x轴字体颜色
 */
@property (nonatomic, strong) UIColor *xAxisTitleColor;


/**
 边框颜色
 */
@property (nonatomic, strong) UIColor *axisShadowColor;

/**
 边框宽度
 */
@property (nonatomic, assign) CGFloat axisShadowWidth;

/**
 分割线颜色
 */
@property (nonatomic, strong) UIColor *separatorColor;
/**
 分割线宽度
 */
@property (nonatomic, assign) CGFloat separatorWidth;

/**
 分割线数量
 */
@property (nonatomic, assign) NSInteger separatorNum;


/**
 交叉点
 */
@property (nonatomic, strong) UIView *pointCrossLine;

/**
 交叉点宽度
 */
@property (nonatomic, assign) float pointCrossLineWidth;

/**
 十字线颜色
 */
@property (nonatomic, strong) UIColor *croosLineColor;

/**
 是否可缩放
 */
@property (nonatomic, assign) BOOL zommEnable;

/**
 是否可滑动
 */
@property (nonatomic, assign) BOOL scrollEnable;

/**
 是否显示均线
 */
@property (nonatomic, assign) BOOL showAvgLine;

/**
 Y轴数据是否跟着变化
 */
@property (nonatomic, assign) BOOL yAxisTitleIsChange;

/**
 是否显示indexChart
 */
@property (nonatomic, assign) BOOL showIndexChart;

/**
 保留小数点位
 */
@property (nonatomic, assign) NSInteger saveDecimalPlaces;


/**
 依靠外界保留的小数点位
 */
@property (nonatomic, assign) NSInteger lastSaveDecimalPlaces;

/**
 K线最大宽度
 */
@property (nonatomic, assign) CGFloat maxKlineWidth;

/**
 K线最小宽度
 */
@property (nonatomic, assign) CGFloat minKlineWidth;

/**
 是否支持手势
 */
@property (nonatomic, assign) BOOL supportGesture;

@property (nonatomic, assign) BOOL isYAxisTitleOutSide;
@property (nonatomic, assign) BOOL isXAxisTitleOutside;

/**
 提示框边框的颜色
 */
@property (nonatomic, strong) UIColor *tipBorderColor;
/**
 提示框的颜色
 */
@property (nonatomic, strong) UIColor *tipBackGroundColor;
/**
 提示框边框的宽度
 */
@property (nonatomic, assign) CGFloat tipBorderWidth;
/**
 提示字体颜色
 */
@property (nonatomic, strong) UIColor *tipTextColor;



/**
 显示K线最大最小值
 */
@property (nonatomic, assign) BOOL isShowMaxMinValue;

/**
 是否显示K线Y轴数据
 */
@property (nonatomic, assign) BOOL isShowKlineYAxisTitle;
/**
 是否显示IndexChartY轴数据
 */
@property (nonatomic, assign) BOOL isShowIndexYAxisTitle;

/**
 是否显示实体阳线
 */
@property (nonatomic, assign) BOOL isHollowLine;

/**
 是否在表格外边
 */
@property (nonatomic, assign) BOOL yAxisIsOutSide;

/**
 k线指标类型
 */
@property (nonatomic, assign) KLineChartTopType topIndexType;

/**
 指标视图类型
 */
@property (nonatomic, assign) KLineChartBottomType bottomIndexType;

/**
 指标切换名称
 */
@property (nonatomic, copy) NSString *indexChangeTitle;
@property (nonatomic, copy) NSString *klineChangeTitle;


/**
 横竖屏
 */
@property (nonatomic, assign) KlineChartDirection direction;

// 数据模型
@property (nonatomic, strong) FTKlineItemData *klinItemData;
// 数据
@property (nonatomic, strong) NSArray *contexts;
@property (nonatomic, strong) NSArray *dates;
@property (nonatomic, strong) NSArray *lineContexts;
@property (nonatomic,strong) NSArray *IndexContexts;


//周期
@property (nonatomic, strong) NSString *period;


// 代理对象
@property (nonatomic, weak) id<FTKlineViewDelegate>delegate;


//传入数据
- (void)drawChartWithData:(FTKlineItemData *)klineItemData;

// 长按
- (void)longPressEvent:(UIGestureRecognizer *)longPress;
// 滑动
- (void)panEventWith:(UIPanGestureRecognizer *)pan;
// 缩放
- (void)pichEventWith:(UIPinchGestureRecognizer *)pinch;


- (void)drawChart1111WithData:(FTKlineItemData *)klineItemData;


@end
