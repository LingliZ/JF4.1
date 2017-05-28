//
//  FTComputerIndex.m
//  ChartDemo
//
//  Created by futang yang on 2016/10/18.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "FTComputerIndex.h"
#import "ta_libc.h"

#import "FTKlineModel.h"
#import "CCSTALibUtils.h"

#import "FTKlineItemData.h"


#import "FTLineData.h"
#import "CCSTitledLine.h"


#import "FTIndexParamHeader.h"



@implementation FTComputerIndex


#pragma mark - MA
+ (CCSTitledLine *)computeMAData:(FTKlineItemData *)itemData  param:(FTMaParam *) param {
    
    NSArray *items = itemData.context;
    NSMutableArray *arrCls = [[NSMutableArray alloc] init];
    switch (param.smaDataType) {
        case OPEN:
        {
            for (NSUInteger index = 0; index < items.count; index++) {
                FTKlineModel *item = [items objectAtIndex:index];
                [arrCls addObject:[NSNumber numberWithDouble:[item.open doubleValue]]];
            }
        }
            break;
        case HIGH:
        {
            for (NSUInteger index = 0; index < items.count; index++) {
                FTKlineModel *item = [items objectAtIndex:index];
                [arrCls addObject:[NSNumber numberWithDouble:item.high]];
            }
        }
            break;
        case LOW:
        {
            for (NSUInteger index = 0; index < items.count; index++) {
                FTKlineModel *item = [items objectAtIndex:index];
                [arrCls addObject:[NSNumber numberWithDouble:item.low]];
            }
        }
            break;
        case CLOSE:
        {
            for (NSUInteger index = 0; index < items.count; index++) {
                FTKlineModel *item = [items objectAtIndex:index];
                [arrCls addObject:[NSNumber numberWithDouble:[item.close doubleValue]]];
            }
        }
            break;
        default:
            break;
    }
    
    double *inCls = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrCls, inCls);
    
    int outBegIdx = 0, outNBElement = 0;
    double *outReal = malloc(sizeof(double) * items.count);
    
    TA_RetCode ta_retCode = TA_MA(0,
                                  (int) (items.count - 1),
                                  inCls,
                                  param.period,
                                  param.type,
                                  &outBegIdx,
                                  &outNBElement,
                                  outReal);
    
    NSMutableArray *maData = [[NSMutableArray alloc] init];
    
    if (TA_SUCCESS == ta_retCode) {
        NSArray *arr = CArrayToNSArray(outReal, (int) items.count, outBegIdx, outNBElement);
        
        for (NSInteger index = 0; index < arrCls.count; index++) {
            FTKlineModel *item = [items objectAtIndex:index];
            [maData addObject:[[FTLineData alloc] initWithValue:[[arr objectAtIndex:index] doubleValue] date:item.time]];
        }
        //freeAndSetNULL((__bridge void *)(arr));
    }
    
    freeAndSetNULL(inCls);
    freeAndSetNULL(outReal);
    
    CCSTitledLine *maline = [[CCSTitledLine alloc] init];
    maline.title = [NSString stringWithFormat:@"MA%d",param.period];
    
    
    if (param.tag == 0) {
        maline.color = [UIColor colorWithRed:224.0/255.0 green:159.0/255.0 blue:82.0/255.0 alpha:1.0];
    } else if (1 == param.tag) {
        maline.color =  [UIColor colorWithRed:35.0/255.0 green:163.0/255.0 blue:203.0/255.0 alpha:1.0];
    }else if (2 == param.tag) {
        maline.color = [UIColor colorWithRed:216.0/255.0 green:128.0/255.0 blue:210.0/255.0 alpha:1.0];
    }else if (3 == param.tag) {
        maline.color =[UIColor colorWithRed:0 green:.43 blue:.09 alpha:1];
    }

    maline.data = maData;
    
    return maline;
}


#pragma mark - BOLL
+ (NSMutableArray *)computeBOLLData:(FTKlineItemData *)itemData param:(FTBollParam *)param {
    
    
    NSArray *items = itemData.context;
    NSMutableArray *arrCls = [[NSMutableArray alloc] init] ;
    
    for (NSUInteger index = 0; index < items.count; index++) {
        FTKlineModel *item = [items objectAtIndex:index];
        [arrCls addObject:[NSNumber numberWithDouble:[item.close doubleValue]]];
    }
    double *inCls = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrCls, inCls);
    
    int outBegIdx = 0, outNBElement = 0;
    double *outRealUpperBand = malloc(sizeof(double) * items.count);
    double *outRealBollBand = malloc(sizeof(double) * items.count);
    double *outRealLowerBand = malloc(sizeof(double) * items.count);
    
    TA_RetCode ta_retCode = TA_BBANDS(0,
                                      (int) (items.count - 1),
                                      inCls,
                                      param.period,
                                      param.deviation,
                                      2,
                                      TA_MAType_SMA,
                                      &outBegIdx,
                                      &outNBElement,
                                      outRealUpperBand,
                                      outRealBollBand,
                                      outRealLowerBand);
    
    NSMutableArray *bollLinedataUPPER = [[NSMutableArray alloc] init];
    NSMutableArray *bollLinedataLOWER = [[NSMutableArray alloc] init];
    NSMutableArray *bollLinedataBOLL = [[NSMutableArray alloc] init];
    
    if (TA_SUCCESS == ta_retCode) {
        
        NSArray *arrUPPER = CArrayToNSArray(outRealUpperBand, (int) items.count, outBegIdx, outNBElement);
        NSArray *arrBOLL = CArrayToNSArray(outRealBollBand, (int) items.count, outBegIdx, outNBElement);
        NSArray *arrLOWER = CArrayToNSArray(outRealLowerBand, (int) items.count, outBegIdx, outNBElement);
        
        for (NSInteger index = 0; index < arrCls.count; index++) {
            FTKlineModel *item = [items objectAtIndex:index];
            [bollLinedataUPPER addObject:[[FTLineData alloc] initWithValue:[[arrUPPER objectAtIndex:index] doubleValue] date:item.time]];
            [bollLinedataLOWER addObject:[[FTLineData alloc] initWithValue:[[arrLOWER objectAtIndex:index] doubleValue] date:item.time]];
            [bollLinedataBOLL addObject:[[FTLineData alloc] initWithValue:[[arrBOLL objectAtIndex:index] doubleValue] date:item.time]];
        }
    }
    
    freeAndSetNULL(inCls);
    freeAndSetNULL(outRealUpperBand);
    freeAndSetNULL(outRealBollBand);
    freeAndSetNULL(outRealLowerBand);
    
    // 颜色取值
    NSArray *colorArray = param.colorArray;
    
    CCSTitledLine *bollLineMid = [[CCSTitledLine alloc] init];
    bollLineMid.data = bollLinedataBOLL;
    bollLineMid.color = colorArray[0];
    bollLineMid.title = @"MID";
    
    CCSTitledLine *bollLineUPPER = [[CCSTitledLine alloc] init];
    bollLineUPPER.data = bollLinedataUPPER;
    bollLineUPPER.color =  colorArray[1];
    bollLineUPPER.title = @"UPPER";
    
    CCSTitledLine *bollLineLOWER = [[CCSTitledLine alloc] init];
    bollLineLOWER.data = bollLinedataLOWER;
    bollLineLOWER.color = colorArray[2];
    bollLineLOWER.title = @"LOWER";
    
    NSMutableArray *bollBanddata = [[NSMutableArray alloc] init];
    [bollBanddata addObject:bollLineMid];
    [bollBanddata addObject:bollLineUPPER];
    [bollBanddata addObject:bollLineLOWER];
    
    return bollBanddata;
}



#pragma mark - MACD
+ (NSMutableArray *)computerMACDWithData:(FTKlineItemData *)itemData  param:(FTMacdParam *)param{
    
    NSArray *items = itemData.context;
    NSMutableArray *arrCls = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        FTKlineModel *item = [itemData.context objectAtIndex:index];
        [arrCls addObject:[NSNumber numberWithDouble:[item.close floatValue]]];
 
    }
    double *inCls = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrCls, inCls);
    
    int outBegIdx = 0, outNBElement = 0;
    double *outMACD = malloc(sizeof(double) * items.count);
    double *outMACDSignal = malloc(sizeof(double) * items.count);
    double *outMACDHist = malloc(sizeof(double) * items.count);
    
    TA_RetCode ta_retCode = TA_MACD(0,
                                    (int) (items.count - 1),
                                    inCls,
                                    param.shortPeriod,
                                    param.longPeriod,
                                    param.macdPeriod,
                                    &outBegIdx,
                                    &outNBElement,
                                    outMACD,
                                    outMACDSignal,
                                    outMACDHist);    
    
    NSMutableArray *deaArray = [NSMutableArray array];
    NSMutableArray *diffArray = [NSMutableArray array];
    NSMutableArray *macdArray = [NSMutableArray array];
    
    if (TA_SUCCESS == ta_retCode) {
        
        NSArray *arrMACDSignal = CArrayToNSArray(outMACDSignal, (int) items.count, outBegIdx, outNBElement);
        NSArray *arrMACD = CArrayToNSArray(outMACD, (int) items.count, outBegIdx, outNBElement);
        NSArray *arrMACDHist = CArrayToNSArray(outMACDHist, (int) items.count, outBegIdx, outNBElement);
        
        for (NSInteger index = 0; index < arrCls.count; index++) {
            //两倍表示MACD
            FTKlineModel *item = [items objectAtIndex:index];
            [deaArray addObject:[[FTLineData alloc] initWithValue: [[arrMACDSignal objectAtIndex:index] doubleValue] * 1000000/1000000 date:item.time]];
            [diffArray addObject:[[FTLineData alloc] initWithValue: [[arrMACD objectAtIndex:index] doubleValue] * 1000000/1000000 date:item.time]];
            [macdArray addObject:[[FTLineData alloc] initWithValue: [[arrMACDHist objectAtIndex:index] doubleValue] * 2 * 1000000/1000000  date:item.time]];
        }
    }
    
    freeAndSetNULL(inCls);
    freeAndSetNULL(outMACD);
    freeAndSetNULL(outMACDSignal);
    freeAndSetNULL(outMACDHist);
    
    
    
    
    CCSTitledLine *diffLine = [[CCSTitledLine alloc] init];
    diffLine.data = diffArray;
    diffLine.color = param.colorArray[0];
    diffLine.title = @"DIFF";
    
    CCSTitledLine *deaLine = [[CCSTitledLine alloc] init];
    deaLine.data = deaArray;
    deaLine.color = param.colorArray[1];
    deaLine.title = @"DEA";

    CCSTitledLine *macdLine = [[CCSTitledLine alloc] init];
    macdLine.data = macdArray;
    macdLine.color = param.colorArray[2];
    macdLine.title = @"MACD";

    NSMutableArray *macdData = [[NSMutableArray alloc] init];
    [macdData addObject:diffLine];
    [macdData addObject:deaLine];
    [macdData addObject:macdLine];
    
    return macdData;
}



#pragma mark - KDJ
+ (NSMutableArray *)computeKDJData:(FTKlineItemData *)itemData kdjParam:(FTKdjParam *)param {
    
    NSArray *items = itemData.context;
    
    NSMutableArray *arrHigval = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        FTKlineModel *item = [items objectAtIndex:index];
        [arrHigval addObject:[NSNumber numberWithDouble: item.high]];
    }
    double *inHigval = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrHigval, inHigval);
    
    NSMutableArray *arrLowval = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        FTKlineModel *item = [items objectAtIndex:index];
        [arrLowval addObject:[NSNumber numberWithDouble:item.low]];
    }
    double *inLowval = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrLowval, inLowval);
    
    NSMutableArray *arrCls = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        FTKlineModel *item = [items objectAtIndex:index];
        [arrCls addObject:[NSNumber numberWithDouble:[item.close doubleValue]]];
    }
    double *inCls = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrCls, inCls);
    
    int outBegIdx = 0, outNBElement = 0;
    double *outSlowK = malloc(sizeof(double) * items.count);
    double *outSlowD = malloc(sizeof(double) * items.count);

    
    TA_RetCode ta_retCode = TA_STOCH(0,
                                     (int) (items.count - 1),
                                     inHigval,
                                     inLowval,
                                     inCls,
                                     param.Kperiod,
                                     param.Dperiod,
                                     TA_MAType_EMA,
                                     param.Jperiod,
                                     TA_MAType_EMA,
                                     &outBegIdx,
                                     &outNBElement,
                                     outSlowK,
                                     outSlowD);
    
    NSMutableArray *slowKLineData = [[NSMutableArray alloc] init];
    NSMutableArray *slowDLineData = [[NSMutableArray alloc] init];
    NSMutableArray *slow3K2DLineData = [[NSMutableArray alloc] init];
    
    if (TA_SUCCESS == ta_retCode) {
        NSArray *arrSlowK = CArrayToNSArray(outSlowK, (int) items.count, outBegIdx, outNBElement);
        NSArray *arrSlowD = CArrayToNSArray(outSlowD, (int) items.count, outBegIdx, outNBElement);
        
        for (NSInteger index = 0; index < arrCls.count; index++) {
            FTKlineModel *item = [items objectAtIndex:index];
            [slowKLineData addObject:[[FTLineData alloc] initWithValue:[[arrSlowK objectAtIndex:index] doubleValue] date:item.time]];
            [slowDLineData addObject:[[FTLineData alloc] initWithValue:[[arrSlowD objectAtIndex:index] doubleValue] date:item.time]];
            
            double slowKLine3k2d = 3 * [[arrSlowK objectAtIndex:index] doubleValue] - 2 * [[arrSlowD objectAtIndex:index] doubleValue];
            [slow3K2DLineData addObject:[[FTLineData alloc] initWithValue:slowKLine3k2d date:item.time]];
        }
    }
    
    freeAndSetNULL(inHigval);
    freeAndSetNULL(inLowval);
    freeAndSetNULL(inCls);
    freeAndSetNULL(outSlowK);
    freeAndSetNULL(outSlowD);
    
    
    
    CCSTitledLine *slowKLine = [[CCSTitledLine alloc] init];
    slowKLine.data = slowKLineData;
    slowKLine.color = param.colorArray[0];
    slowKLine.title = @"K";
    
    CCSTitledLine *slowDLine = [[CCSTitledLine alloc] init];
    slowDLine.data = slowDLineData;
    slowDLine.color = param.colorArray[1];
    slowDLine.title = @"D";
    
    CCSTitledLine *slow3K2DLine = [[CCSTitledLine alloc] init];
    slow3K2DLine.data = slow3K2DLineData;
    slow3K2DLine.color =  param.colorArray[2];
    slow3K2DLine.title = @"J";
    
    NSMutableArray *kdjData = [[NSMutableArray alloc] init];
    [kdjData addObject:slowKLine];
    [kdjData addObject:slowDLine];
    [kdjData addObject:slow3K2DLine];
    
    return kdjData;
}


#pragma mark - RSI
+ (CCSTitledLine *)computeRSIData:(FTKlineItemData *)itemData period:(int)period {
    
    NSArray *items = itemData.context;
    
    NSMutableArray *arrCls = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        FTKlineModel *item = [items objectAtIndex:index];
        [arrCls addObject:[NSNumber numberWithDouble:[item.close doubleValue]]];
    }
    double *inCls = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrCls, inCls);
    
    int outBegIdx = 0, outNBElement = 0;
    double *outReal = malloc(sizeof(double) * items.count);
    
    TA_RetCode ta_retCode = TA_RSI(0,
                                   (int) (items.count - 1),
                                   inCls,
                                   period,
                                   &outBegIdx,
                                   &outNBElement,
                                   outReal);
    
    NSMutableArray *rsiLineData = [[NSMutableArray alloc] init];
    
    if (TA_SUCCESS == ta_retCode) {
        NSArray *arr = CArrayToNSArray(outReal, (int) items.count, outBegIdx, outNBElement);
        
        for (NSInteger index = 0; index < arrCls.count; index++) {
            FTKlineModel *item = [items objectAtIndex:index];
            [rsiLineData addObject:[[FTLineData alloc] initWithValue:[[arr objectAtIndex:index] doubleValue] date:item.time]];
        }
    }
    
    freeAndSetNULL(inCls);
    freeAndSetNULL(outReal);
    
    CCSTitledLine *rsiLine = [[CCSTitledLine alloc] init];
    rsiLine.title = [NSString stringWithFormat:@"RSI%d", period];
    rsiLine.data = rsiLineData;
    
    return rsiLine;
}



#pragma mark - ADX
+ (NSMutableArray *)computeADXData:(FTKlineItemData *)itemData {
    
    NSArray *items = itemData.context;
    NSMutableArray *arrHigval = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        FTKlineModel *item = [items objectAtIndex:index];
        [arrHigval addObject:[NSNumber numberWithDouble: item.high]];
    }
    double *inHigval = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrHigval, inHigval);
    
    NSMutableArray *arrLowval = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        FTKlineModel *item = [items objectAtIndex:index];
        [arrLowval addObject:[NSNumber numberWithDouble:item.low]];
    }
    double *inLowval = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrLowval, inLowval);
    
    NSMutableArray *arrCls = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        FTKlineModel *item = [items objectAtIndex:index];
        [arrCls addObject:[NSNumber numberWithDouble:[item.close doubleValue]]];
    }
    double *inCls = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrCls, inCls);
    
    int outBegIdx = 0, outNBElement = 0;
    double *outADX = malloc(sizeof(double) * items.count);
    
    
    TA_RetCode ta_retCode = TA_ADX(0,
                                   (int) (items.count - 1),
                                   inHigval,
                                   inLowval,
                                   inCls,
                                   9,
                                   &outBegIdx,
                                   &outNBElement,
                                   outADX);
    
    NSMutableArray *ADXLineData = [[NSMutableArray alloc] init];
    
    if (TA_SUCCESS == ta_retCode) {
        NSArray *arrAdx = CArrayToNSArray(outADX, (int) items.count, outBegIdx, outNBElement);
        
        for (NSInteger index = 0; index < arrCls.count; index++) {
            FTKlineModel *item = [items objectAtIndex:index];
            [ADXLineData addObject:[[FTLineData alloc] initWithValue:[[arrAdx objectAtIndex:index] doubleValue] date:item.time]];
        }
    }
    
    freeAndSetNULL(inHigval);
    freeAndSetNULL(inLowval);
    freeAndSetNULL(inCls);
    freeAndSetNULL(outADX);
    
    CCSTitledLine *adxLine = [[CCSTitledLine alloc] init];
    adxLine.data = ADXLineData;
    adxLine.color = ADXColor;
    adxLine.title = @"ADX";
    
    
    NSMutableArray *adxData = [[NSMutableArray alloc] init];
    [adxData addObject:adxLine];
    
    return adxData;
    
}

#pragma mark - ATR
+ (NSMutableArray *)computeATRData:(FTKlineItemData *)itemData {
    
    NSArray *items = itemData.context;
    NSMutableArray *arrHigval = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        FTKlineModel *item = [items objectAtIndex:index];
        [arrHigval addObject:[NSNumber numberWithDouble:item.high]];
    }
    double *inHigval = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrHigval, inHigval);
    
    NSMutableArray *arrLowval = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        FTKlineModel *item = [items objectAtIndex:index];
        [arrLowval addObject:[NSNumber numberWithDouble:item.low]];
    }
    double *inLowval = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrLowval, inLowval);
    
    NSMutableArray *arrCls = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        FTKlineModel *item = [items objectAtIndex:index];
        [arrCls addObject:[NSNumber numberWithDouble:[item.close doubleValue]]];
    }
    double *inCls = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrCls, inCls);
    
    int outBegIdx = 0, outNBElement = 0;
    double *outATR = malloc(sizeof(double) * items.count);
    
    
    TA_RetCode ta_retCode = TA_ATR(0,
                                   (int) (items.count - 1),
                                   inHigval,
                                   inLowval,
                                   inCls,
                                   15,
                                   &outBegIdx,
                                   &outNBElement,
                                   outATR);
    
    NSMutableArray *ATRLineData = [[NSMutableArray alloc] init];
    
    if (TA_SUCCESS == ta_retCode) {
        NSArray *arrAdx = CArrayToNSArray(outATR, (int) items.count, outBegIdx, outNBElement);
        
        for (NSInteger index = 0; index < arrCls.count; index++) {
            FTKlineModel *item = [items objectAtIndex:index];
            [ATRLineData addObject:[[FTLineData alloc] initWithValue:[[arrAdx objectAtIndex:index] doubleValue] date:item.time]];
        }
    }
    
    freeAndSetNULL(inHigval);
    freeAndSetNULL(inLowval);
    freeAndSetNULL(inCls);
    freeAndSetNULL(outATR);
    
    CCSTitledLine *atrLine = [[CCSTitledLine alloc] init];
    atrLine.data = ATRLineData;
    atrLine.color = ATRColor;
    atrLine.title = @"ATR";
    
    NSMutableArray *atrData = [[NSMutableArray alloc] init];
    [atrData addObject:atrLine];
    
    return atrData;

}

#pragma mark - DMI
+ (NSMutableArray *)computeDMIData:(FTKlineItemData *)itemData {
    
    NSArray *items = itemData.context;
    NSMutableArray *arrHigval = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        FTKlineModel *item = [items objectAtIndex:index];
        [arrHigval addObject:[NSNumber numberWithDouble:item.high]];
    }
    double *inHigval = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrHigval, inHigval);
    
    NSMutableArray *arrLowval = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        FTKlineModel *item = [items objectAtIndex:index];
        [arrLowval addObject:[NSNumber numberWithDouble:item.low]];
    }
    double *inLowval = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrLowval, inLowval);
    
    NSMutableArray *arrCls = [[NSMutableArray alloc] init];
    for (NSUInteger index = 0; index < items.count; index++) {
        FTKlineModel *item = [items objectAtIndex:index];
        [arrCls addObject:[NSNumber numberWithDouble:[item.close doubleValue]]];
    }
    double *inCls = malloc(sizeof(double) * items.count);
    NSArrayToCArray(arrCls, inCls);
    
    int outBegIdx = 0, outNBElement = 0;
    double *outDX = malloc(sizeof(double) * items.count);
    
    
    TA_RetCode ta_retCode = TA_DX(0,
                                  (int) (items.count - 1),
                                  inHigval,
                                  inLowval,
                                  inCls,
                                  20,
                                  &outBegIdx,
                                  &outNBElement,
                                  outDX);
    
    NSMutableArray *DXLineData = [[NSMutableArray alloc] init];
    
    if (TA_SUCCESS == ta_retCode) {
        NSArray *arrAdx = CArrayToNSArray(outDX, (int) items.count, outBegIdx, outNBElement);
        
        for (NSInteger index = 0; index < arrCls.count; index++) {
            FTKlineModel *item = [items objectAtIndex:index];
            [DXLineData addObject:[[FTLineData alloc] initWithValue:[[arrAdx objectAtIndex:index] doubleValue] date:item.time]];
        }
    }
    
    freeAndSetNULL(inHigval);
    freeAndSetNULL(inLowval);
    freeAndSetNULL(inCls);
    freeAndSetNULL(outDX);
    
    CCSTitledLine *dxLine = [[CCSTitledLine alloc] init];
    dxLine.data = DXLineData;
    dxLine.color =  [UIColor colorWithRed:224.0/255.0 green:159.0/255.0 blue:82.0/255.0 alpha:1.0];
    dxLine.title = @"DMI(20)";

    NSMutableArray *dxData = [[NSMutableArray alloc] init];
    [dxData addObject:dxLine];
    
    return dxData;

    
}







@end
