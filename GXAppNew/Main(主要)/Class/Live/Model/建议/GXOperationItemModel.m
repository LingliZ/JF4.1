//
//  GXOperationItemModel.m
//  GXAppNew
//
//  Created by maliang on 2016/12/19.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXOperationItemModel.h"
#import "NSDateFormatter+GXDateFormatter.h"
#import "NSDecimalNumber+GXDecimalNumber.h"

@implementation GXOperationItemModel

- (void)setStopPrice:(NSDecimalNumber *)stopPrice
{
    _stopPrice = [NSDecimalNumber dealDecimalNumber:stopPrice];
}
- (void)setStopPriceOriginal:(NSDecimalNumber *)stopPriceOriginal
{
    _stopPriceOriginal = [NSDecimalNumber dealDecimalNumber:stopPriceOriginal];
}
- (void)setTargetPrice:(NSDecimalNumber *)targetPrice
{
    _targetPrice = [NSDecimalNumber dealDecimalNumber:targetPrice];
}
- (void)setTargetPriceOriginal:(NSDecimalNumber *)targetPriceOriginal
{
    _targetPriceOriginal = [NSDecimalNumber dealDecimalNumber:targetPriceOriginal];
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
        NSInteger type = [self.types integerValue];
        switch (type) {
            case 1:
                self.leftStr = @"减持";
                self.isDouble = YES;
                break;
            case 2:
                self.isDouble = NO;
                break;
            case 3:
                self.leftStr = @"撤单";
                self.isDouble = NO;
                break;
            case 4: //修改价位
            {
                BOOL resultOne = ([self.targetPrice integerValue] != [self.targetPriceOriginal integerValue]) && ([self.stopPrice integerValue] != [self.stopPriceOriginal integerValue]);
                self.isDouble = resultOne ;
                self.leftStr = @"修改价位";
            }
                break;
                //挂单
            case 5:
                self.leftStr = @"摘牌";
                self.isDouble = NO;
                break;
                
            default:
                self.isDouble = NO;
                break;
        }
        if (self.targetPriceOriginal && [self.targetPrice integerValue] == [self.targetPriceOriginal integerValue]) {
            self.centerStr = [NSString stringWithFormat:@"止损价改为:%@",self.stopPrice];
        }else if([self.leftStr isEqualToString:@"摘牌"]){
            self.centerStr = [NSString stringWithFormat:@"点位:%@",self.stopPrice];
        }
        else {
            self.centerStr = [NSString stringWithFormat:@"目标价改为:%@",self.targetPrice];
        }
        NSDateFormatter *formatter = [NSDateFormatter shareFormatter];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *createTime = dict[@"createdTime"];
        NSDate *date = [formatter dateFromString:createTime];
        formatter.dateFormat = @"MM月dd日HH:mm";
        self.rightStr = [formatter stringFromDate:date];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{}

@end
