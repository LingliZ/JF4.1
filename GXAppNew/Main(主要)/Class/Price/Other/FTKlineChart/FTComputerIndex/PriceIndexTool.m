//
//  PriceIndexTool.m
//  ChartDemo
//
//  Created by futang yang on 2016/12/22.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "PriceIndexTool.h"
#import "GXFileTool.h"


#define MaParamArrayfilePath @"MaParamArrayfilePath"
#define BOLLparamfilePath @"BOLLparamfilePath"
#define MACDparamfilePath @"MACDparamfilePath"
#define KDJparamfilePath @"KDJparamfilePath"
#define RSIparamfilePath @"RSIparamfilePath"

#define Price_PeriodIndexKey @"Price_PeriodIndexKey"   // 行情period下标
#define PriceTopBttomParamPath @"PriceTopBttomParamPath"


@implementation PriceIndexTool


#pragma mark - MA
+ (void)SaveMAparamArray:(FTMaParamArray *)MaParamArray {
    [GXFileTool saveObject:MaParamArray byFileName:MaParamArrayfilePath];
}

+ (FTMaParamArray *)GetMaParamArray {
   return [GXFileTool readObjectByFileName:MaParamArrayfilePath];
}


+ (void)SaveMA:(int)period index:(NSInteger)index {
    
    FTMaParamArray *ParamArray = [self GetMaParamArray];
    if (ParamArray.indexArray.count != 0) {
        FTMaParam *parma = ParamArray.indexArray[index];
        parma.period = period;
    }
    
    [self SaveMAparamArray:ParamArray];
}


+ (FTMaParam *)GetMaParam:(NSInteger)index {
    FTMaParamArray *ParamArray = [self GetMaParamArray];
    if (ParamArray.indexArray.count != 0) {
        FTMaParam *item = ParamArray.indexArray[index];
        return item;
    }
    return nil;
}

+ (void)creatDefaultMaParamArray {
    
    FTMaParam *MA1 = [[FTMaParam alloc] init];
    MA1.period = 5;

    FTMaParam *MA2 = [[FTMaParam alloc] init];
    MA2.period = 10;
    
    FTMaParam *MA3 = [[FTMaParam alloc] init];
    MA3.period = 20;
    
    FTMaParamArray *MAparamArray = [[FTMaParamArray alloc] init];
    MAparamArray.indexArray = [NSMutableArray arrayWithObjects:MA1,MA2,MA3,nil];
    MAparamArray.indexName = @"MA";
    MAparamArray.colorArray = @[MA1Color,MA2Color,MA3Color];
    
    [self SaveMAparamArray:MAparamArray];
}

+ (void)RestoreMAparamArray {
    [self creatDefaultMaParamArray];
}





#pragma mark - BOLL
// 保存BOLL指标数组
+ (void)SaveBOLLparam:(FTBollParam *)BollParam {
    [GXFileTool saveObject:BollParam byFileName:BOLLparamfilePath];
}
+ (FTBollParam *)GetBollParam {
    return [GXFileTool readObjectByFileName:BOLLparamfilePath];
}

+ (void)RestoreBollparam {
    [self creatDefaultBollParam];
}


//#define MIDColor [UIColor colorWithHexString:@"F5A623"]
//#define UPPERColor [UIColor colorWithHexString:@"4082F4"]
//#define LOWERColor [UIColor colorWithHexString:@"C7238B"]

+ (void)creatDefaultBollParam {
    FTBollParam *bollParam = [[FTBollParam alloc] init];
    bollParam.period = 20;
    bollParam.deviation = 2;
    bollParam.colorArray = @[MIDColor,UPPERColor,LOWERColor];
    [self SaveBOLLparam:bollParam];
}

//#define DIFColor [UIColor colorWithHexString:@"F5A623"]
//#define DEAColor [UIColor colorWithHexString:@"4082F4"]
//#define MACDColor [UIColor colorWithHexString:@"E7E7E7"]


#pragma mark - MACD
+ (void)SaveMACDparam:(FTMacdParam *)MacdParam {
    [GXFileTool saveObject:MacdParam byFileName:MACDparamfilePath];
}
+ (FTMacdParam *)GetMacdParam {
    return [GXFileTool readObjectByFileName:MACDparamfilePath];
}

+ (void)creatDefaultMacdParam {
    FTMacdParam *param = [[FTMacdParam alloc] init];
    param.shortPeriod = 12;
    param.longPeriod = 26;
    param.macdPeriod = 9;
    param.colorArray = @[DIFColor,DEAColor,MACDColor];
    [self SaveMACDparam:param];
}

+ (void)RestoreMacdParam {
    [self creatDefaultMacdParam];
}


#pragma mark - KDJ
// 保存KDJ指标
+ (void)SaveKDJParam:(FTKdjParam *)KdjParam {
    [GXFileTool saveObject:KdjParam byFileName:KDJparamfilePath];
}
+ (FTKdjParam *)GetKdjParam {
    return [GXFileTool readObjectByFileName:KDJparamfilePath];
}

+ (void)RestoreKdjParam {
    [self creatDefaultKdjParam];
}

+ (void)creatDefaultKdjParam {
    FTKdjParam *param = [[FTKdjParam alloc] init];
    param.Kperiod = 9;
    param.Dperiod = 3;
    param.Jperiod = 3;
    param.colorArray = @[KColor,DColor,JColor];
    [self SaveKDJParam:param];
}

// 保存RSI指标
+ (void)SaveRSIParam:(FTRsiParam *)RsiParam {
    [GXFileTool saveObject:RsiParam byFileName:RSIparamfilePath];
}
+ (FTRsiParam *)GetRsiParam {
    return [GXFileTool readObjectByFileName:RSIparamfilePath];
}


+ (void)creatDefaultRsiParam {
    FTRsiParam *param = [[FTRsiParam alloc] init];
    param.period1 = 6;
    param.period2 = 12;
    param.period3 = 24;
    param.colorArray = @[RSI1Color,RSI2Color,RSI3Color];
    [self SaveRSIParam:param];
}

+ (void)RestoreRsiParam {
    [self creatDefaultRsiParam];
}



#pragma mark - 指标period设置
+ (void)creatDefaultPeriodIndex {
    [self savePricePeriodIndex:0];
}


+ (void)savePricePeriodIndex:(NSInteger)index {
    [GXUserdefult setInteger:index forKey:Price_PeriodIndexKey];
    [GXUserdefult synchronize];
}

+ (NSInteger)getPricePeriodIndex {
    return [GXUserdefult integerForKey:Price_PeriodIndexKey];
}



+ (void)creatDefaultTopBottomParam {
    PriceTopBttomParam *param = [[PriceTopBttomParam alloc] init];
    param.topType = MA;
    param.bottomType = MACD;
    [GXFileTool saveObject:param byFileName:PriceTopBttomParamPath];
}

+ (PriceTopBttomParam *)getTopBottomParam {
    return [GXFileTool readObjectByFileName:PriceTopBttomParamPath];
}


+ (void)saveTopBottomParam:(PriceTopBttomParam *)param {
    [GXFileTool saveObject:param byFileName:PriceTopBttomParamPath];
}

+ (void)saveTopBottomParamTop:(KLineChartTopType)type {
    PriceTopBttomParam *param = [self getTopBottomParam];
    param.topType = type;
    [self saveTopBottomParam:param];
}

+ (void)saveTopBottomParamBottom:(KLineChartBottomType)type {
    PriceTopBttomParam *param = [self getTopBottomParam];
    param.bottomType = type;
    [self saveTopBottomParam:param];
}






@end
