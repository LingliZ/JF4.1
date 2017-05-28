//
//  FTChartDealvalueTool.m
//  GXAppNew
//
//  Created by futang yang on 2017/1/12.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "FTChartDealvalueTool.h"
#import <UIKit/UIKit.h>


@implementation FTChartDealvalueTool

+ (NSString *)dealDecimalWithNum:(NSNumber *)number DecimalPlaces:(NSInteger)decimalPlaces {
    
    NSString *dealString;
    
    switch (decimalPlaces) {
        case 0: {
            dealString = [NSString stringWithFormat:@"%ld",(long)floor(number.floatValue)];
            break;
        }
        case 1: {
            dealString = [NSString stringWithFormat:@"%.1f",number.floatValue];
            break;
        }
            
        case 2:{
            dealString = [NSString stringWithFormat:@"%.2f",number.floatValue];
            break;
        }
        case 3:{
            dealString = [NSString stringWithFormat:@"%.3f",number.floatValue];
            break;
        }
        case 4:{
            dealString = [NSString stringWithFormat:@"%.4f",number.floatValue];
            break;
        }
        case 5:{
            dealString = [NSString stringWithFormat:@"%.5f",number.floatValue];
            break;
        }
        case 6:{
            dealString = [NSString stringWithFormat:@"%.6f",number.floatValue];
            break;
        }
            
        default:
            break;
    }
    return dealString;
}


+ (CGSize)boundingString:(NSString *)string WithSize:(CGSize)size FontSize:(CGFloat)fontsize {
    
    CGSize stringSize = [string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontsize]} context:nil].size;
    return stringSize;
}



@end
