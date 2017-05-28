//
//  GXExchangeModel.h
//  GXAppNew
//
//  Created by maliang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXExchangeModel : NSObject


@property(nonatomic, copy) NSString *periodId;
@property(nonatomic, copy) NSString *idNew;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, copy) NSString *auditTime1;
@property(nonatomic, copy) NSString *replyNickName;
@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *roomId;
@property(nonatomic, copy) NSString *roomName;
@property(nonatomic, copy) NSString *replyUserId;
@property(nonatomic, copy) NSString *replyTo;
@property(nonatomic, copy) NSString *createdTime;
@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *replyContent;
@property(nonatomic, copy) NSString *userPic;

+ (instancetype)exchangeModel:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
