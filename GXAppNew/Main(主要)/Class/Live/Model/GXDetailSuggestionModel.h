//
//  GXDetailSuggestionModel.h
//  GXApp
//
//  Created by zhudong on 16/7/22.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXDetailSuggestionModel : NSObject
@property (nonatomic,copy) NSString *Content;
@property (nonatomic,copy) NSString *ContentStr;
@property (nonatomic,copy) NSString *CreatedTime;
@property (nonatomic,copy) NSString *timeStr;
@property (nonatomic,copy) NSString *Direction;
@property (nonatomic,copy) NSString *Pattern;
@property (nonatomic,copy) NSString *Position;
@property (nonatomic,assign) NSDecimalNumber *StopLoss;
//@property (nonatomic,assign) NSDecimalNumber*TargetPrice;
@property (nonatomic,copy) NSDecimalNumber *TargetPrice;
@property (nonatomic,copy) NSString *Teacher;
@property (nonatomic,copy) NSString *Varieties;
@property (nonatomic,copy) NSString *TL;
@property (nonatomic,copy) NSString *Operation;
@property (nonatomic,copy) NSDecimalNumber *Price2;
@property (nonatomic,copy) NSDecimalNumber *TargetPriceOld;
@property (nonatomic,copy) NSString *I1;

+ (instancetype)detailSuggestionModelWithDict:(NSDictionary *)dict;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
