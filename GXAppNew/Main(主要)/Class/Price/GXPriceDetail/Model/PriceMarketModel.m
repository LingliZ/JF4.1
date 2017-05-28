//
//  PriceMarketModel.m
//  GXApp
//
//  Created by yangfutang on 16/5/20.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "PriceMarketModel.h"
#import "NSString+Add.h"
#import "NSDecimalNumber+GXDecimalNumber.h"

@implementation PriceMarketModel



//code GET
//- (NSString *)code {
//    return [_code lowercaseString];
//}


// 交易时间
- (NSString *)quoteTime {
    return [NSString StringFromquoteTime:_quoteTime];
}

// 交易状态
- (NSString *)status {
    
    if ([_status isEqualToString:@"open"]) {
        return @"交易中";
    } else if ([_status isEqualToString:@"close"]) {
        return @"结束交易";
    } else if (_status.length == 0) {
        return @"";
    }
    return @"";
}


- (NSString *)buy {

    CGFloat floatBuy = [_buy floatValue];
    
    if (floatBuy != 0) {
        return _buy;
    } else {
        return _sell;
    }
    
}


- (NSInteger)saveDecimalPlaces {
    
    if (self.last && self.last.length != 0) {
        if ([self.last rangeOfString:@"."].location != NSNotFound) {
            NSArray *temp = [self.last componentsSeparatedByString:@"."];
            NSString *last = temp.lastObject;
            return last.length;
        }
    }
    return 0;
    
}


// 涨幅
- (NSString *)increase {
    
    float increaseNumber = [self.last floatValue] - [self.lastclose floatValue];
    
    if (increaseNumber > 0) {
        //  return [NSString stringWithFormat:@"+%.2f",increaseNumber];
        return [NSString stringWithFormat:@"+%@",[self dealincreaseWithLast:increaseNumber]];
    } else {
        return [NSString stringWithFormat:@"%@",[self dealincreaseWithLast:increaseNumber]];
        // return [NSString stringWithFormat:@"%.2f",increaseNumber];
    }
}



- (NSString *)dealincreaseWithLast:(CGFloat)floatValue {
    if (self.saveDecimalPlaces == 0) {
        return [NSString stringWithFormat:@"%.0f",floatValue];
    }
    if (self.saveDecimalPlaces == 1) {
        return [NSString stringWithFormat:@"%.1f",floatValue];
    }
    
    if (self.saveDecimalPlaces == 2) {
        return [NSString stringWithFormat:@"%.2f",floatValue];
    }
    if (self.saveDecimalPlaces == 3) {
        return [NSString stringWithFormat:@"%.3f",floatValue];
    }
    if (self.saveDecimalPlaces == 4) {
        return [NSString stringWithFormat:@"%.4f",floatValue];
    }
    if (self.saveDecimalPlaces == 5) {
        return [NSString stringWithFormat:@"%.5f",floatValue];
    }
    return nil;
}


// 涨幅百分比
- (NSString *)increasePercentage {
    
    float increaseNumber = [self.last floatValue] - [self.lastclose floatValue];
    float increasePercentage = increaseNumber  * 100 / [self.lastclose floatValue];
    
    if (increasePercentage > 0 ) {
        return [NSString stringWithFormat:@"+%.2f%%",increasePercentage];
    } else {
        return [NSString stringWithFormat:@"%.2f%%",increasePercentage];
    }
}

// 颜色
- (UIColor *)increaseBackColor {
    
    if ([self.increasePercentage floatValue] > 0) {
        return PriceRedColor;
    } else if ([self.increasePercentage floatValue] < 0) {
        return PriceGreenColor;
    }
    
    return PriceLightGray;
}



/**
 *  最新价格颜色
 */
- (UIColor *)lastColor {
    return [self compareWithLastClose:self.last];
}


/**
 *  卖价的颜色
 */
- (UIColor *)sellColor {
    return [self compareWithLastClose:self.sell];
}


/**
 *  买价的颜色
 */
- (UIColor *)buyColor {
    return [self compareWithLastClose:self.buy];
}

/**
 *  最高的颜色
 */
- (UIColor *)highColor {
    return [self compareWithLastClose:self.high];
}

/**
 *  最低的颜色
 */
- (UIColor *)lowColor {
    return [self compareWithLastClose:self.low];
}

/**
 *  今开的颜色
 */
- (UIColor *)openColor {
    return [self compareWithLastClose:self.open];
}

/**
 *  根据昨收的比较
 *
 *  @param value 参数
 *
 *  @return 不同的颜色
 */
- (UIColor *)compareWithLastClose:(NSString *)value {
    if ([value floatValue] > [self.lastclose floatValue]) {
        return PriceRedColor;
    } else if ([value floatValue] < [self.lastclose floatValue]) {
        return PriceGreenColor;
    } else {
        return PriceLightGray;
    }
}


//-(BOOL) isHiddenPme
//{
//    if([[_excode lowercaseString]isEqualToString:@"qilu"]||[[_excode lowercaseString]isEqualToString:@"tjpmev3"])
//    {
//        return NO;
//    }
//    
//    return YES;
//}



@end
