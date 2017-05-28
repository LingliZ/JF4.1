//
//  PriceCanlendarBaseModel.m
//  GXAppNew
//
//  Created by futang yang on 2016/12/7.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "PriceCanlendarBaseModel.h"
#import "PriceCalendarDataModel.h"
#import "PriceCalendarEventModel.h"
#import "GXAdaptiveHeightTool.h"

#define timeMargin 12
#define nameMargin 10
#define frontMargin 8
#define bottomMargin 18




@implementation PriceCanlendarBaseModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary[@"type"] isEqualToString:@"data"]) {
        PriceCalendarDataModel *dataModel = [PriceCalendarDataModel new];
        [dataModel setValuesForKeysWithDictionary:dictionary];
        
        CGFloat timeLableHeight = [GXAdaptiveHeightTool lableHeightWithText:dataModel.time font:GXFONT_PingFangSC_Regular(11) Width:MAXFLOAT];
        CGFloat nameLabelHeight = [GXAdaptiveHeightTool lableHeightWithText:dataModel.name font:GXFONT_PingFangSC_Regular(14) Width:132];
        CGFloat frontLableHeight = [GXAdaptiveHeightTool lableHeightWithText:dataModel.frontValue font:GXFONT_PingFangSC_Regular(14) Width:0];
        
        dataModel.cellHeight = timeMargin + timeLableHeight + nameMargin + nameLabelHeight + frontMargin + frontLableHeight + bottomMargin;
        
        return dataModel;
        
    } else if ([dictionary[@"type"] isEqualToString:@"event"]) {
        PriceCalendarEventModel *eventModel = [PriceCalendarEventModel new];
        [eventModel setValuesForKeysWithDictionary:dictionary];
        CGFloat eventHeight = [GXAdaptiveHeightTool lableHeightWithText:[NSString stringWithFormat:@"【事件】%@", eventModel.event] font:GXFONT_PingFangSC_Regular(14) Width:30];
        eventModel.cellHeight = eventHeight;
        return eventModel;
    }
    return nil;
}


@end
