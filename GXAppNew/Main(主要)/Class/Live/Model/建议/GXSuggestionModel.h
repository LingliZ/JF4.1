//
//  GXSuggestionModel.h
//  GXAppNew
//
//  Created by maliang on 2016/12/19.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXOperationItemModel.h"

@interface GXSuggestionModel : NSObject
//视频直播用
@property (nonatomic,assign) BOOL isOpen;
//建立模型
@property(nonatomic, strong) NSString *content;
@property(nonatomic, strong) NSString *createdTime;
@property(nonatomic, strong) NSString *direction;
@property(nonatomic, strong) NSString *directionStr;
@property(nonatomic, strong) NSString *isClosed;
@property(nonatomic, strong) NSString *isDeleted;
@property(nonatomic, strong) NSString *isTop;
@property(nonatomic, strong) NSString *nID;
@property(nonatomic, strong) NSString *oldId;
@property(nonatomic, strong) NSString *pattern;
@property(nonatomic, strong) NSString *periodId;
@property(nonatomic, strong) NSString *roomId;
@property(nonatomic, strong) NSString *roomName;
@property(nonatomic, strong) NSString *userId;
@property(nonatomic, strong) NSString *userName;
@property(nonatomic, strong) NSString *userPhoto;
@property(nonatomic, strong) NSString *varieties;
@property(nonatomic, strong) NSString *varietiesCode;
@property(nonatomic, strong) NSString *contentStr;
@property(nonatomic, strong) NSString *idNew;
@property(nonatomic, assign) NSInteger positions;
@property(nonatomic, strong) NSDecimalNumber *buyingPrice;
@property(nonatomic, strong) NSDecimalNumber *sellingPrice;
@property(nonatomic, strong) NSDecimalNumber *stopPrice;
@property(nonatomic, strong) NSDecimalNumber *targetPrice;
@property(nonatomic, strong) NSMutableAttributedString *contentAttriStr;
@property(nonatomic, strong) NSMutableAttributedString *contentForLive;
@property(nonatomic, strong) NSMutableAttributedString *attriMForContent;

@property(nonatomic, strong) NSArray<GXOperationItemModel *> *operationItems;

@property(nonatomic, strong) UIColor *directionColor;
@property(nonatomic, strong) NSString *timeStr;

@property (nonatomic,assign)float contentHeight;

@property (nonatomic, strong)NSString *sell;
@property (nonatomic, strong)NSString *buy;

@property (nonatomic, copy) NSString *fuying;

@property (nonatomic, strong) UIColor *fuYingColor;


+ (instancetype)suggestModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
