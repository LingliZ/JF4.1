//
//  GXPriceDetailTool.h
//  GXApp
//
//  Created by futang yang on 16/7/26.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GXPriceDetailTool : NSObject

+ (void)choosePersonSelectPrice:(BOOL)isSelect Key:(NSString *)code;

+ (BOOL)getPersonSelectBtnIsSelectedWithCode:(NSString *)code;

+ (BOOL)isKeepAtLeastTwoPersonOptionalsWithSenderSelect:(BOOL)select;

/**
 *  给本地自选添加code
 *
 *  @param code code参数
 */
+ (void)PersonSelectAddCode:(NSString *)code;


+ (NSArray *)retrunPopularSelectList;



@end
