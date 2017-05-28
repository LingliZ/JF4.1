//
//  GXQuestion.h
//  GXApp
//
//  Created by zhudong on 2016/11/2.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDateFormatter+GXDateFormatter.h"

@interface GXQuestion : NSObject
@property (nonatomic,copy) NSString *auditTime1;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *createdTime;
@property (nonatomic,copy) NSString *id;
@property (nonatomic,assign) long long questionNewId;
@property (nonatomic,copy) NSString *nickName;
@property (nonatomic,copy) NSString *periodId;
@property (nonatomic,copy) NSString *replyTo;
@property (nonatomic,copy) NSString *roomId;
@property (nonatomic,copy) NSString *roomName;
@property (nonatomic,copy) NSString *userId;
@property (nonatomic,copy) NSString *questionTimeStr;
@property (nonatomic,copy) NSString *replyNickName;
@property (nonatomic,copy) NSString *userPic;

+ (instancetype)questionWithDict: (NSDictionary *) dict;
- (instancetype)initWithDict:(NSDictionary* )dict;
@end
