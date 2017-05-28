//
//  PricePlatformModel.h
//  GXApp
//
//  Created by yangfutang on 16/5/19.
//  Copyright © 2016年 yangfutang. All rights reserved.
//  交易所模型

#import <Foundation/Foundation.h>

@interface PricePlatformModel : NSObject<NSCoding>


/**
 *  交易所代码号
 */
@property (nonatomic,copy) NSString *excode;
/**
 *  交易所名称
 */
@property (nonatomic,copy) NSString *exname;
/**
 *  产品列表
 */
@property (nonatomic, strong) NSArray *tradeInfoList;


/**
 *  是否展开
 */
@property (nonatomic,copy) NSString *isOpen;//1展开 0不


/**
 *  交易所名称自定义
 */
@property (nonatomic,copy) NSString *exname_custom;


@end
