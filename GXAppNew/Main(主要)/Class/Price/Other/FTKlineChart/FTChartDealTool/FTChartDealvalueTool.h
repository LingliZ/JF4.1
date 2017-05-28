//
//  FTChartDealvalueTool.h
//  GXAppNew
//
//  Created by futang yang on 2017/1/12.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FTChartDealvalueTool : NSObject

+ (NSString *)dealDecimalWithNum:(NSNumber *)number DecimalPlaces:(NSInteger)decimalPlaces;

+ (CGSize)boundingString:(NSString *)string WithSize:(CGSize)size FontSize:(CGFloat)fontsize;

@end
