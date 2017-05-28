//
//  GXLiveModel.h
//  GXAppNew
//
//  Created by maliang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXLiveModel : NSObject

@property(nonatomic, copy) NSString * periodId;
@property(nonatomic, copy) NSString * livePics;
@property(nonatomic, copy) NSString * oldId;
@property(nonatomic, copy) NSString * topTime;
@property(nonatomic, copy) NSString * userName;
@property(nonatomic, copy) NSString * userId;
@property(nonatomic, copy) NSString * content;
@property(nonatomic, copy) NSString * roomId;
@property(nonatomic, copy) NSString * roomName;
@property(nonatomic, copy) NSString * topUser;
@property(nonatomic, copy) NSString * isClosed;
@property(nonatomic, copy) NSString * isDeleted;
@property(nonatomic, copy) NSString * isTop;
@property(nonatomic, copy) NSString * createdTime;
@property(nonatomic, copy) NSString * id;
@property(nonatomic, copy) NSString * idNew;
@property(nonatomic, copy) NSString * photo;
@property(nonatomic, strong) NSArray * livePicsArray;


- (instancetype)initWithDict: (NSDictionary *)dict;
+ (instancetype)modelWthDict: (NSDictionary *)dict;
@end
