//
//  PriceTipSuggestionModel.h
//  GXAppNew
//
//  Created by futang yang on 2017/1/4.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceTipSuggestionModel : NSObject

@property (nonatomic, strong) NSNumber *analystsNum;
@property (nonatomic, strong) NSNumber *roomCallNum;
@property (nonatomic, strong) NSNumber *roomNum;
@property (nonatomic, strong) NSNumber *userStatus;
@property (nonatomic, copy)   NSString *_SugguestNote;
@property (nonatomic, strong) NSArray *Table;

@end
