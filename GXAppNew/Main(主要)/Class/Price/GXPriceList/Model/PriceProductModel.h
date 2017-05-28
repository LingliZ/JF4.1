//
//  PriceProductModel.h
//  GXApp
//
//  Created by yangfutang on 16/5/19.
//  Copyright © 2016年 yangfutang. All rights reserved.
//  产品模型

#import <Foundation/Foundation.h>

@interface PriceProductModel : NSObject

/**
 *  产品代码
 */
@property (nonatomic,copy) NSString *code;

/**
 *  产品名称
 */
@property (nonatomic,copy) NSString *name;


@property (nonatomic,copy) NSString *tradeDetail;

@end
