//
//  GXNoticeModel.h
//  GXAppNew
//
//  Created by maliang on 2016/12/7.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXNoticeModel : NSObject

@property(nonatomic, copy) NSString *isDeleted;
@property(nonatomic, copy) NSString *creatorId;
@property(nonatomic, copy) NSString *creatorName;
@property(nonatomic, copy) NSString *startTime;
@property(nonatomic, copy) NSString *endTime;
@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *roomId;
+ (instancetype)modelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;


@end
