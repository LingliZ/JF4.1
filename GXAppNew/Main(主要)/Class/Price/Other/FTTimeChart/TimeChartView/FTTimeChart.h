//
//  FTTimeChart.h
//  FTChart
//
//  Created by futang yang on 2017/3/20.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FTChartBaseView.h"
#import "TimeChartsHeader.h"

@class FTTimeChart;
@class FTTimeData;


@protocol FTTimeChartDelegate <NSObject>

@optional
- (void)timeChart:(FTTimeChart *)timeChart timeData:(FTTimeData *)timeData longPressInTime:(NSString *)time price:(NSString *)price changeValue:(NSString *)changeValue;
- (void)timeChart:(FTTimeChart *)timeChart timeData:(FTTimeData *)timeData index:(NSInteger)index;
- (void)timeChartLongPressCancle:(FTTimeChart *)timeChart;



@end





@interface FTTimeChart : FTChartBaseView



/**
 *  线宽度
 */
@property (nonatomic, assign) CGFloat lineWidth;
/**
 *  线的颜色
 */
@property (nonatomic, strong) UIColor *lineColor;
/**
 *  阴影开始的颜色
 */
@property (nonatomic, strong) UIColor *gradientStartColor;
/**
 *  阴影结束的颜色
 */
@property (nonatomic, strong) UIColor *gradientEndColor;
/**
 *  点与点之间的间距
 */
@property (nonatomic, assign) CGFloat pointPadding;

/**
 *  横向分时图左侧间距
 */
@property (nonatomic, assign) CGFloat landPointPadding;









/**
 昨日收盘价线颜色
 */
@property (nonatomic, strong) UIColor *lastCloseColor;
/**
 昨日收盘价线宽度
 */
@property (nonatomic, assign) CGFloat lastCloseLineWidth;
/**
 超过昨收颜色
 */
@property (nonatomic, strong) UIColor *upperCloseColor;

/**
 低过昨收颜色
 */
@property (nonatomic, strong) UIColor *lowerCloseColor;





/**
 *  时间轴高度（默认20.0f）
 */
@property (nonatomic, assign) CGFloat timeAxisHeighth;

/**
 *  分割线条数， 默认4条
 */
@property (nonatomic, assign) NSInteger separtorNum;

/**
 *  分割线大小
 */
@property (nonatomic, assign) CGFloat separatorWidth;

/**
 *  分割线颜色
 */
@property (nonatomic, strong) UIColor *separatorColor;




/**
 *  是否分割线是虚线
 */
@property (nonatomic, assign) BOOL isSeparatorLash;

/**
 *  十字线的颜色
 */
@property (nonatomic, strong) UIColor *crossLineColor;

/**
 十字线交点的颜色
 */
@property (nonatomic, strong) UIColor *pointCrossColor;

/**
 十字线的宽度
 */
@property (nonatomic, assign) CGFloat crossLineWidth;

/**
 *  交叉点的大小(长宽一样) 默认不设置是4
 */
@property (nonatomic, assign) CGFloat pointCrossLineWidth;


/**
 是否显示十字线
 */
@property (nonatomic, assign) BOOL isShowCrossLine;

/**
 十字线是否附着在
 */
@property (nonatomic, assign) BOOL isLdCrosslineAttachmentPoint;

/**
 十字线是否附着在
 */
@property (nonatomic, assign) BOOL isVtCrosslineAttachmentPoint;


/**
 延时多少秒后消失十字线（默认0.3秒）
 */
@property (nonatomic, assign) CGFloat delayDisappearCrossLine;






/**
 *  时间和价格提示的字体颜色
 */
@property (nonatomic, strong) UIColor *timeTipTextColor;
/**
 *  时间和价格提示的背景颜色
 */
@property (nonatomic, strong) UIColor *timeTipBackgroundColor;






/**
 提示框边框的颜色
 */
@property (nonatomic, strong) UIColor *tipBorderColor;

/**
 提示框边框的宽度
 */
@property (nonatomic, assign) CGFloat tipBorderWidth;

/**
 提示框背景的颜色
 */
@property (nonatomic, strong) UIColor *tipBackGroundColor;

/**
 价格和百分比是否显示在图表外界
 */
@property (nonatomic, assign) BOOL isTipsDisplayOutSide;



/**
 保留小数点位(如果没有设置默认为2位)
 */
@property (nonatomic, assign) NSInteger saveDecimalPlaces;

/**
 *  圆滑曲线，默认YES
 */
@property (nonatomic, assign) BOOL smoothPath;




/**
 *  闪烁点的颜色
 */
@property (nonatomic, strong) UIColor *flashPointColor;
/**
 *  闪烁点， 默认不显示
 */
@property (nonatomic, assign) BOOL flashPoint;

/**
 *  YES表示：Y坐标的值根据视图中呈现的k线图的最大值最小值变化而变化；NO表示：Y坐标的最大和最小值初始设定多少就多少，不管k线图呈现如何都不会变化。默认YES
 */
@property (nonatomic, assign) BOOL yAxisTitleIsChange;




/**
 是否是TD
 */
@property (nonatomic, assign) BOOL isTD;



/**
 多日分时天下标
 */
@property (nonatomic, strong) NSArray *dayTimeTitles;

/**
 分时图类型
 */
@property (nonatomic, assign) NSInteger timeTypeCount;



/**
 图表显示方向
 */
@property (nonatomic, assign) FTChartDirection direction;


/**
 图表的代理
 */
@property (nonatomic, weak) id <FTTimeChartDelegate>delegate;




// 赋值数据 绘图
- (void)drawChartWithData:(FTTimeData *)data;


@end
