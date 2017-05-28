//
//  GXAccountBalanceModel.h
//  GXAppNew
//
//  Created by shenqilong on 16/12/26.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXAccountBalanceModel : NSObject
@property(nonatomic,copy)NSString*inoutAmount;
@property(nonatomic,copy)NSString*margin;
@property(nonatomic,copy)NSString*organizationName;
@property(nonatomic,copy)NSString*delayFee;
@property(nonatomic,copy)NSString*fee;
@property(nonatomic,copy)NSString*frozenBalance;
@property(nonatomic,copy)NSString*transferAmount;
@property(nonatomic,copy)NSString*frozenFee;
@property(nonatomic,copy)NSString*settlementDate;
@property(nonatomic,copy)NSString*usableBalance;
@property(nonatomic,copy)NSString*closePl;
@property(nonatomic,copy)NSString*beginEquities;
@property(nonatomic,copy)NSString*riskRate;//风险率 需要*100%,如果大于1.2,显示安全
@property(nonatomic,copy)NSString*createTime;
@property(nonatomic,copy)NSString*accountNo;
@property(nonatomic,copy)NSString*mainBankCode;
@property(nonatomic,copy)NSString*equities;//当前权益
@property(nonatomic,copy)NSString*exchange;
//@property(nonatomic,copy)NSString*id;
@property(nonatomic,copy)NSString*holdPl;//浮动盈亏


@property(nonatomic,copy)NSString*riskRate_lb;


@end
