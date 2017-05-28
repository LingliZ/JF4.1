//
//  PriceCalendarDataModel.h
//  GXAppNew
//
//  Created by futang yang on 2016/12/7.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PriceCanlendarBaseModel.h"

@interface PriceCalendarDataModel : PriceCanlendarBaseModel

@property (nonatomic,copy) NSString *frontValue;
@property (nonatomic,copy) NSString *forecast;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *result;
@property (nonatomic,copy) NSString *affect;
@property (nonatomic, copy) NSString *res;


@end
