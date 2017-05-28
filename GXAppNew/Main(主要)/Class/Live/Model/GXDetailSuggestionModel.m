//
//  GXDetailSuggestionModel.m
//  GXApp
//
//  Created by zhudong on 16/7/22.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXDetailSuggestionModel.h"
#import "NSDateFormatter+GXDateFormatter.h"
#import "NSDecimalNumber+GXDecimalNumber.h"

@implementation GXDetailSuggestionModel
+ (instancetype)detailSuggestionModelWithDict:(NSDictionary *)dict{
    return [[self alloc] initWithDict:dict];
}
- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    [self setValuesForKeysWithDictionary:dict];
    [self dealContentStr];
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}
- (void)setCreatedTime:(NSString *)CreatedTime{
    _CreatedTime = CreatedTime;
    NSDateFormatter *formatter = [NSDateFormatter shareFormatter];
    /*
     yyyy-MM-dd HH:mm:ss.SSS
     */
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:CreatedTime];
    formatter.dateFormat = @"MM.dd  HH:mm";
    NSString *dateStr = [formatter stringFromDate:date];
    self.timeStr = dateStr;
}

-(void)setStopLoss:(NSDecimalNumber *)StopLoss{
    _StopLoss = [NSDecimalNumber dealDecimalNumber:StopLoss];
}
- (void)setTargetPrice:(NSDecimalNumber *)TargetPrice{
    _TargetPrice = [NSDecimalNumber dealDecimalNumber:TargetPrice];
}
- (void)setPrice2:(NSDecimalNumber *)Price2{
    _Price2 = [NSDecimalNumber dealDecimalNumber:Price2];
}
- (void)setTargetPriceOld:(NSDecimalNumber *)TargetPriceOld{
    _TargetPriceOld = [NSDecimalNumber dealDecimalNumber:TargetPriceOld];
}
- (void)setTL:(NSString *)TL{
    _TL = TL;
    NSInteger type = [TL integerValue];
    NSString *suggestioinStr;
    switch (type) {
        case 0:
            suggestioinStr = @"已建仓";
            break;
        case 1:
            suggestioinStr = @"已减持";
            break;
        case 2:
            suggestioinStr = @"已平仓";
            break;
        case 3:
            suggestioinStr = @"已撤销";
            break;
        case 4:
            suggestioinStr = @"已修改";
            break;
            
        default:
            break;
    }
    self.Operation = suggestioinStr;
}
- (void)dealContentStr{
    NSInteger type = [self.TL integerValue];
    NSString *contentStr;
    switch (type) {
        case 0:
            if ([self.Position integerValue] > 0) {
                contentStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@,仓位%@%%,%@",self.Varieties,self.Pattern,self.Price2,self.Direction,@",止损价",self.StopLoss,@",目标价",self.TargetPrice,self.Position,self.Content];
            }else{
                contentStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",self.Varieties,self.Pattern,self.Price2,self.Direction,@",止损价",self.StopLoss,@",目标价",self.TargetPrice,self.Content];
            }
            break;
        case 1:
            contentStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",self.Price2,@"的",self.Varieties,self.Direction,@",",self.TargetPriceOld,@"减持",self.I1,@"%"];
            break;
        case 2:
            contentStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",self.Price2,@"的",self.Varieties,self.Direction,@",现价",self.TargetPrice,@"平仓"];
            break;
        case 3:
            contentStr = [NSString stringWithFormat:@"%@%@%@%@%@",@"撤销",self.Varieties,self.Price2,@"价位",self.Direction];
            break;
        case 4:
            contentStr = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",self.Price2,@"的",self.Varieties,self.Direction,@",修改为止损价",self.StopLoss,@",目标价",self.TargetPrice];
            break;
            
        default:
            break;
    }
    if([self.Direction isEqualToString:@"做空"]){
        contentStr = [NSString stringWithFormat:@"%@\n止损价和目标价需另加点差",contentStr];
    } else if ([self.Pattern isEqualToString:@"挂单"]){
        contentStr = [NSString stringWithFormat:@"%@\n进场价需另加点差",contentStr];
    }

    self.ContentStr = contentStr;
}

@end
