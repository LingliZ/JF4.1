//
//  GXAccountOrderListModel.h
//  GXAppNew
//
//  Created by shenqilong on 16/12/26.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXAccountOrderListModel : NSObject
@property(nonatomic,copy)NSString* brandNum;
@property(nonatomic,copy)NSString* lastUpdateDate;
@property(nonatomic,copy)NSString* openPrice;//摘牌价
@property(nonatomic,copy)NSString* oppositeMark;
@property(nonatomic,copy)NSString* brokerNo;
@property(nonatomic,copy)NSString* openQuantity;
@property(nonatomic,copy)NSString* entrustorNo;
@property(nonatomic,copy)NSString* oppositeNo;
@property(nonatomic,copy)NSString* frozenQuantity;
@property(nonatomic,copy)NSString* accountNo;
@property(nonatomic,copy)NSString* symbolName;//持牌
@property(nonatomic,copy)NSString* holdPrice;//持牌价
//@property(nonatomic,copy)NSString* id;
@property(nonatomic,copy)NSString* amount;
@property(nonatomic,copy)NSString* quantity;//持牌量
@property(nonatomic,copy)NSString* organizationName;
@property(nonatomic,copy)NSString* delayFee;
@property(nonatomic,copy)NSString* holdNo;
@property(nonatomic,copy)NSString* marginRatio;
@property(nonatomic,copy)NSString* lateDeliveryTime;
@property(nonatomic,copy)NSString* settlementDate;
@property(nonatomic,copy)NSString* dealNo;
@property(nonatomic,copy)NSString* holdMargin;
@property(nonatomic,copy)NSString* bsFlag;//1，1.0是买，去行情里的最新价。2就是卖，取holdprice
@property(nonatomic,copy)NSString* settlementPl;
@property(nonatomic,copy)NSString* holdTime;
@property(nonatomic,copy)NSString* holdStatus;
@property(nonatomic,copy)NSString* createTime;
@property(nonatomic,copy)NSString* stopLoss;
@property(nonatomic,copy)NSString* exchange;
@property(nonatomic,copy)NSString* holdSettlementDay;
@property(nonatomic,copy)NSString* stopProfit;


@property(nonatomic,copy)NSString* bsFlag_lb;
@property(nonatomic,copy)NSString* myCode;//用symbol那个接口取得，用于查行情

@end
