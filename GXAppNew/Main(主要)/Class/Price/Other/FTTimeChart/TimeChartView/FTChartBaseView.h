//
//  FTChartBaseView.h
//  FTChart
//
//  Created by futang yang on 2017/3/20.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 横竖屏
 */
typedef NS_ENUM(NSUInteger, FTChartDirection) {
    FTChartDirectionVertical,
    FTChartDirectionLandscape
};


@interface FTChartBaseView : UIView

/**
 顶部距离
 */
@property (nonatomic, assign) CGFloat topMargin;

/**
 左边距离
 */
@property (nonatomic, assign) CGFloat leftMargin;

/**
 右边距离
 */
@property (nonatomic, assign) CGFloat rightMargin;


/**
 底部距离
 */
@property (nonatomic, assign) CGFloat bottomMargin;





/**
 *  坐标轴边框颜色
 */
@property (nonatomic, strong) UIColor *axisBoderColor;
/**
 *  坐标轴边框宽度
 */
@property (nonatomic, assign) CGFloat axisBoderWidth;



/**
 *  Y轴坐标字体
 */
@property (nonatomic, strong) UIFont *yAxisTitleFont;

/**
 *  Y轴坐标标题颜色
 */
@property (nonatomic, strong) UIColor *yAxisTitleColor;

/**
 *  y轴标题与轴线文字距离
 */
@property (nonatomic, assign) CGFloat yAxisTitleMargin;


/**
 *  x坐标轴字体
 */
@property (nonatomic, strong) UIFont *xAxisTitleFont;
/**
 *  x坐标轴标题颜色
 */
@property (nonatomic, strong) UIColor *xAxisTitleColor;

/**
 *  x轴标题与轴线文字距离
 */
@property (nonatomic, assign) CGFloat xAxisTitleMargin;





@end
