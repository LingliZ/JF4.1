//
//  GXSuggestionModel.m
//  GXAppNew
//
//  Created by maliang on 2016/12/19.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXSuggestionModel.h"
#import "NSDateFormatter+GXDateFormatter.h"
#import "NSDecimalNumber+GXDecimalNumber.h"
#import "GXSuggestCell.h"
#import "GXTimeDisposeTool.h"

@interface GXSuggestionModel ()

@end
@implementation GXSuggestionModel

+ (instancetype)suggestModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

- (void)setBuyingPrice:(NSDecimalNumber *)buyingPrice
{
    _buyingPrice = [NSDecimalNumber dealDecimalNumber:buyingPrice];
}
- (void)setSellingPrice:(NSDecimalNumber *)sellingPrice {
    _sellingPrice = [NSDecimalNumber dealDecimalNumber:sellingPrice];
}
- (void)setStopPrice:(NSDecimalNumber *)stopPrice
{
    _stopPrice = [NSDecimalNumber dealDecimalNumber:stopPrice];
}
- (void)setTargetPrice:(NSDecimalNumber *)targetPrice
{
    _targetPrice = [NSDecimalNumber dealDecimalNumber:targetPrice];
}


- (instancetype)initWithDict:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        
        [self setValuesForKeysWithDictionary:dict];
        
        _pattern = dict[@"pattern"];
        self.idNew = dict[@"newId"];
        self.directionStr = dict[@"direction"];
        if ([self.directionStr isEqualToString:@"做空"] || [self.directionStr isEqualToString:@"交货(卖出)"]) {
            self.directionStr = @"空";
            self.directionColor = GXRGBColor(47, 142, 0);
        } else {
            self.directionColor = GXRGBColor(216, 62, 33);
            self.directionStr = @"多";
        }
        // 判断type
        // 传入不同时间
        __block NSDateFormatter *formatter = [NSDateFormatter shareFormatter];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSString *createdTime = dict[@"createdTime"];
        __block NSDate *createDate = [formatter dateFromString:createdTime];
        
        self.timeStr = [GXTimeDisposeTool compareNowTime:createDate];
        
        NSArray *itemDict = dict[@"callRecordValues"];
        NSMutableArray *mArr = [[NSMutableArray alloc] init];
        if (itemDict.count > 0) {
            [itemDict enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GXOperationItemModel *item = [[GXOperationItemModel alloc] initWithDict:obj];
                
                if ([item.types integerValue] == 3) {
                    item.leftStr = @"撤单";
                    item.centerStr = nil;
                }
                
                if (idx == 0 && ([item.types integerValue] == 3 || [item.types integerValue] == 2)) {
                    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                    NSDate *cancelDate = [formatter dateFromString:item.createdTime];
                    self.timeStr = [GXTimeDisposeTool compareNowTime:cancelDate startDate:createDate];
                }
                if (idx == 0 && [item.types integerValue] == 3 && [self.pattern isEqualToString:@"挂单"]) {
                    
                    if ([[itemDict lastObject][@"types"] integerValue] == 5) {
                        NSDate *cancelDate = [formatter dateFromString:item.createdTime];
                        self.timeStr = [GXTimeDisposeTool compareNowTime: cancelDate startDate:createDate];
                    } else {
                        self.timeStr = @"--";
                        self.sellingPrice = (NSDecimalNumber *)@"--";
                        item.leftStr = @"撤单";
                        item.centerStr = nil;
                    }
                }
                
                [mArr addObject:item];
                
                item.directionStr = self.directionStr;
                
                if ([item.types integerValue] == 2) {
                    item.leftStr = @"已回购";
                    item.centerStr = [NSString stringWithFormat:@"点位:%@",item.stopPrice];
                }
                
            }];
        }
        
        GXOperationItemModel *model = [[GXOperationItemModel alloc] init];
        if ([self.pattern isEqualToString:@"挂单"] && itemDict.count == 0) {
            self.timeStr = @"--";
            self.sellingPrice = (NSDecimalNumber *)@"--";
            model.leftStr = @"挂单";
            model.centerStr = [NSString stringWithFormat:@"点位:%@",self.buyingPrice];
            
        }else if([self.pattern isEqualToString:@"挂单"]){
            model.leftStr = @"挂单";
            model.centerStr = [NSString stringWithFormat:@"点位:%@",self.buyingPrice];
        }else {
            model.leftStr = @"摘牌";
            model.createdTime = createdTime;
            model.centerStr = [NSString stringWithFormat:@"点位:%@",self.sellingPrice];
        }
        model.targetPrice = self.targetPrice;
        model.stopPrice = self.stopPrice;
        
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        NSDate *date = [formatter dateFromString:createdTime];
        formatter.dateFormat = @"MM月dd日HH:mm";
        NSString *timeStr = [formatter stringFromDate:date];
        model.rightStr = timeStr;
        [mArr addObject:model];
        self.operationItems = mArr;
        
        self.nID = [NSString stringWithFormat:@"%zd",[dict[@"newId"] integerValue]];
        self.contentStr = dict[@"content"];
        NSString * exMsg = self.directionStr;
        UIColor *color = [UIColor colorWithRed:66/255.0 green:66/255.0 blue:66/255.0 alpha:1];
        ;
        NSMutableAttributedString *attriM = [[NSMutableAttributedString alloc] initWithString:self.contentStr attributes:@{NSFontAttributeName : GXFONT_PingFangSC_Regular(GXFitFontSize14), NSForegroundColorAttributeName:color}];
        
        NSMutableAttributedString *attriMLive = [[NSMutableAttributedString alloc] initWithString:self.contentStr attributes:@{NSFontAttributeName : GXFONT_PingFangSC_Regular(GXFitFontSize14), NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.contentForLive = attriMLive;
        self.contentAttriStr = attriM;
        if ([exMsg isEqualToString:@"空"]) {
            UIColor *color = [UIColor colorWithRed:161/255.0 green:166/255.0 blue:187/255.0 alpha:1];
            NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"[止损价和目标价需另加点差]" attributes:@{NSFontAttributeName : GXFONT_PingFangSC_Regular(GXFitFontSize14), NSForegroundColorAttributeName:color}];
            
            
            [self.contentAttriStr appendAttributedString:attri];
            [self.contentForLive appendAttributedString:attri];
        } else if ([exMsg isEqualToString:@"多"]){
            
            
            UIColor *color = [UIColor colorWithRed:161/255.0 green:166/255.0 blue:187/255.0 alpha:1];
            NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"[进场价需另加点差]" attributes:@{NSFontAttributeName : GXFONT_PingFangSC_Regular(GXFitFontSize14), NSForegroundColorAttributeName:color}];
            
            [self.contentAttriStr appendAttributedString:attri];
            [self.contentForLive appendAttributedString:attri];
        }
        self.contentHeight = [GXAdaptiveHeightTool lableHeightWithText:self.contentAttriStr.string font:GXFONT_PingFangSC_Regular(GXFitFontSize14) Width:20] + HeightScale_IOS6(12);
        
        //建议详情的footerV显示
        NSString *contentStr;
        
        if ([self.pattern isEqualToString:@"挂单"]) {
            if (self.positions > 0) {
                contentStr = [NSString stringWithFormat:@"%@%@%@%@,止损价%@,目标价%@,仓位%ld%%,",self.varieties,self.pattern,self.buyingPrice,self.direction,self.stopPrice,self.targetPrice,self.positions];
            } else {
                contentStr = [NSString stringWithFormat:@"%@%@%@%@,止损价%@,目标价%@,",self.varieties,self.pattern,self.buyingPrice,self.direction,self.stopPrice,self.targetPrice];
            }
        } else {
            if (self.positions > 0) {
                contentStr = [NSString stringWithFormat:@"%@%@%@%@,止损价%@,目标价%@,仓位%ld%%,",self.varieties,self.pattern,self.sellingPrice,self.direction,self.stopPrice,self.targetPrice,self.positions];
            } else {
                contentStr = [NSString stringWithFormat:@"%@%@%@%@,止损价%@,目标价%@,",self.varieties,self.pattern,self.sellingPrice,self.direction,self.stopPrice,self.targetPrice];
            }
        }
        
        UIColor *contentColor = [UIColor colorWithRed:18.0/255.0 green:29.0/255.0 blue:61.0/255.0 alpha:1];
        ;
        NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
        paragraph.lineSpacing = 2;
        NSMutableAttributedString *attriMForContent = [[NSMutableAttributedString alloc] initWithString:contentStr attributes:@{NSFontAttributeName : GXFONT_PingFangSC_Regular(GXFitFontSize14), NSForegroundColorAttributeName:contentColor}];
        [attriMForContent addAttribute:NSParagraphStyleAttributeName
                                 value:paragraph
                                 range:NSMakeRange(0, [attriMForContent length])];
        [attriMForContent appendAttributedString: self.contentAttriStr];
        self.attriMForContent = attriMForContent;
        
    }
    return self;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if ([key isEqualToString:@"pattern"]) {
        _pattern = value;
    }
}


- (NSString *)fuying {
    
    if (self.sell.length == 0 && self.buy.length == 0) {
        return  @"--";
        self.fuYingColor = [UIColor blackColor];
    }
    
    if ([self.pattern isEqualToString:@"挂单"]){
        //有成交
        float price=0;
        //0,挂单 1，成交 2，撤单
        int controlType=0;
        
        for (GXOperationItemModel *operationItemModel in self.operationItems) {
            if(operationItemModel.types!=nil){
                
                if ([operationItemModel.types integerValue]==3) {
                    controlType=2;
                
                }else if([operationItemModel.types integerValue]==5){
                     controlType=1;
                    price=[[operationItemModel stopPrice] floatValue];
                }
            }
        }
        if (controlType==1) {
            if ([self.directionStr isEqualToString:@"多"]) {
                if ([_fuying floatValue] > 0) {
                    _fuying = [NSString stringWithFormat:@"+%.2f%%",(([self.sell floatValue] - price) / price) * 100];
                    if ([self.stopPrice floatValue]==0) {
                        _fuying = @"--";
                        self.fuYingColor = [UIColor blackColor];
                    }
                } else {
                    _fuying = [NSString stringWithFormat:@"%.2f%%",(([self.sell floatValue] - price) /price) * 100];
                    if (price==0) {
                        _fuying = @"--";
                        self.fuYingColor = [UIColor blackColor];
                    }
                }
                self.fuYingColor = [self dealWithYuyingNum:_fuying];
            }else{
                if ([_fuying floatValue] > 0) {
                    _fuying = [NSString stringWithFormat:@"+%.2f%%",((price - [self.buy floatValue]) / price) * 100];
                    if (price==0) {
                        _fuying = @"--";
                        self.fuYingColor = [UIColor blackColor];
                    }
                } else {
                    _fuying = [NSString stringWithFormat:@"%.2f%%",((price - [self.buy floatValue]) / price) * 100];
                    if (price==0) {
                        _fuying = @"--";
                        self.fuYingColor = [UIColor blackColor];
                    }
                }
                self.fuYingColor = [self dealWithYuyingNum:_fuying];
            }
        }
        else if (controlType==2){
        
            _fuying = @"--";
            self.fuYingColor = [UIColor blackColor];
        
        }else if(controlType==0){
        
             _fuying = @"--";
            self.fuYingColor = [UIColor blackColor];
        }
        return _fuying;
    }else{
        if ([self.directionStr isEqualToString:@"多"]) {
            if ([_fuying floatValue] > 0) {
                _fuying = [NSString stringWithFormat:@"+%.2f%%",(([self.sell floatValue] - [self.sellingPrice floatValue]) / [self.sellingPrice floatValue]) * 100];
                if ([self.sellingPrice floatValue]==0) {
                    _fuying = @"--";
                }
            } else {
                _fuying = [NSString stringWithFormat:@"%.2f%%",(([self.sell floatValue] - [self.sellingPrice floatValue]) / [self.sellingPrice floatValue]) * 100];
                if ([self.sellingPrice floatValue]==0) {
                    _fuying = @"--";
                }
            }
            self.fuYingColor = [self dealWithYuyingNum:_fuying];
        } else {
            if ([_fuying floatValue] > 0) {
                _fuying = [NSString stringWithFormat:@"+%.2f%%",(([self.sellingPrice floatValue] - [self.buy floatValue]) / [self.sellingPrice floatValue]) * 100];
                if ([self.sellingPrice floatValue]==0) {
                    _fuying = @"--";
                }
            } else {
                _fuying = [NSString stringWithFormat:@"%.2f%%",(([self.sellingPrice floatValue] - [self.buy floatValue]) / [self.sellingPrice floatValue]) * 100];
                if ([self.sellingPrice floatValue]==0) {
                    _fuying = @"--";
                }
            }
            self.fuYingColor = [self dealWithYuyingNum:_fuying];
        }
        return _fuying;
    }
}

//浮盈文字的颜色显示
- (UIColor *)dealWithYuyingNum:(NSString *)string
{
    UIColor *zeroFyColor = [UIColor blackColor];
    if ([string floatValue] > 0) {
        return GXRGBColor(216, 62, 33);
    } else if ([string floatValue] < 0){
        return GXRGBColor(0, 168, 74);
    } else {
        return zeroFyColor;
    }
}
@end
