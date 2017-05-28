//
//  GXQAndAModel.h
//  GXAppNew
//
//  Created by maliang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXAskModel.h"

@interface GXQAndAModel : NSObject
@property(nonatomic, copy) NSString * answerId;
@property(nonatomic, copy) NSString * askPics;
@property(nonatomic, copy) NSString * answerName;
@property(nonatomic, copy) NSString * answerTime;
@property(nonatomic, copy) NSString * askerName;
@property(nonatomic, copy) NSString * source;
@property(nonatomic, copy) NSString * roomId;
@property(nonatomic, copy) NSString * qStatus;
@property(nonatomic, copy) NSString * marrowTitle;
@property(nonatomic, copy) NSString * createdTime;
@property(nonatomic, copy) NSString * periodId;
@property(nonatomic, copy) NSString * question;
@property(nonatomic, copy) NSString * nickName;
@property(nonatomic, copy) NSString * answerPics;
@property(nonatomic, strong) NSArray * answerPicsArray;
@property(nonatomic, copy) NSString * photo;
@property(nonatomic, copy) NSString * avatar;
@property(nonatomic, copy) NSString * askerId;
@property(nonatomic, copy) NSString * oldId;
@property(nonatomic, copy) NSString * customerLevel;
@property(nonatomic, copy) NSString * roomName;
@property(nonatomic, copy) NSString * isRoomUser;
@property(nonatomic, copy) NSString * productCode;
@property(nonatomic, copy) NSString * answer;
@property(nonatomic, copy) NSString * isMarrow;
@property(nonatomic, copy) NSString * isPravicy;
@property(nonatomic, strong) NSArray * askerList;
@property(nonatomic, strong) NSArray * askerListArray;
@property(nonatomic, strong) NSArray * askPicsArray;
@property(nonatomic, copy) NSString *idNew ;

+ (instancetype)qAndAModel:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;
@end
