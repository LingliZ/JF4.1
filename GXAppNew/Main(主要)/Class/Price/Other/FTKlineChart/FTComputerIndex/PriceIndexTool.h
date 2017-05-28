//
//  PriceIndexTool.h
//  ChartDemo
//
//  Created by futang yang on 2016/12/22.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FTMaParamArray.h"
#import "FTIndexParamHeader.h"
#import "PriceTopBttomParam.h"



@interface PriceIndexTool : NSObject


// 创建默认数据
+ (void)creatDefaultMaParamArray;
+ (void)creatDefaultBollParam;
+ (void)creatDefaultMacdParam;
+ (void)creatDefaultKdjParam;
+ (void)creatDefaultRsiParam;




// 保存MA指标数组
+ (void)SaveMAparamArray:(FTMaParamArray *)MaParamArray;
+ (FTMaParamArray *)GetMaParamArray;

+ (void)SaveMA:(int)period index:(NSInteger)index;
+ (FTMaParam *)GetMaParam:(NSInteger)index;
+ (void)RestoreMAparamArray;


// 保存BOLL指标数组
+ (void)SaveBOLLparam:(FTBollParam *)BollParam;
+ (FTBollParam *)GetBollParam;
+ (void)RestoreBollparam;

// 保存Macd指标
+ (void)SaveMACDparam:(FTMacdParam *)MacdParam;
+ (FTMacdParam *)GetMacdParam;
+ (void)RestoreMacdParam;


// 保存KDJ指标
+ (void)SaveKDJParam:(FTKdjParam *)KdjParam;
+ (FTKdjParam *)GetKdjParam;
+ (void)RestoreKdjParam;

// 保存RSI指标
+ (void)SaveRSIParam:(FTRsiParam *)RsiParam;
+ (FTRsiParam *)GetRsiParam;
+ (void)RestoreRsiParam;



#pragma mark - 指标period设置

/**
 保存默认的
 */
+ (void)creatDefaultPeriodIndex;
/**
 保存行情period字段
 
 @param index 日 5日  日K 周K。。。。
 */
+ (void)savePricePeriodIndex:(NSInteger)index;


/**
 获取行情period字段
 */
+ (NSInteger)getPricePeriodIndex;


#pragma mark - 保存的
+ (void)creatDefaultTopBottomParam;

+ (PriceTopBttomParam *)getTopBottomParam;


+ (void)saveTopBottomParam:(PriceTopBttomParam *)param;

+ (void)saveTopBottomParamTop:(KLineChartTopType)type;

+ (void)saveTopBottomParamBottom:(KLineChartBottomType)type;


@end
