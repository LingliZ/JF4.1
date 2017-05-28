//
//  GXPriceRemindParam.h
//  GXApp
//
//  Created by futang yang on 16/7/19.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

 //  增加报价提醒  code产品代码 upperBound lowerBound bySms

@interface GXPriceRemindParam : NSObject

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *upperBound;
@property (nonatomic, copy) NSString *lowerBound;
@property (nonatomic, assign) BOOL bySms;


@property (nonatomic, assign) BOOL upperOn;
@property (nonatomic, assign) BOOL lowerOn;


@end
