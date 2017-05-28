//
//  FTComputerIndex.h
//  ChartDemo
//
//  Created by futang yang on 2016/10/18.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FTKlineItemData;
@class CCSTitledLine;
@class FTBollParam;
@class FTMaParam;
@class FTMacdParam;
@class FTKdjParam;


@interface FTComputerIndex : NSObject



+ (CCSTitledLine *)computeMAData:(FTKlineItemData *)itemData  param:(FTMaParam *) param;
+ (NSMutableArray *)computeBOLLData:(FTKlineItemData *)itemData param:(FTBollParam *)param;

+ (NSMutableArray *)computerMACDWithData:(FTKlineItemData *)itemData  param:(FTMacdParam *)parama;
+ (NSMutableArray *)computeKDJData:(FTKlineItemData *)itemData kdjParam:(FTKdjParam *)param;
+ (CCSTitledLine *)computeRSIData:(FTKlineItemData *)itemData period:(int)period;
+ (NSMutableArray *)computeADXData:(FTKlineItemData *)itemData;
+ (NSMutableArray *)computeATRData:(FTKlineItemData *)itemData;
+ (NSMutableArray *)computeDMIData:(FTKlineItemData *)itemData;








@end
