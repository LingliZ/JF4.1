//
//  GXAddAccountTool.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/4.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GXUserInfoModel.h"
@interface GXAddAccountTool : NSObject

#pragma mark--获取用户开户状态
/**
 *获取用户开户状态
 */
+(void)getAccountStatusSuccess:(void(^)(id responseObject))success Failure:(void(^)(NSError*error))failure;

#pragma mark--是否开过户
/**
 *是否开过户
 */
+(void)isAddAccountSucess:(void(^)(BOOL addAccountResult))success Failure:(void(^)(NSError*error))failure;

#pragma mark--获取用户信息
/**
 *获取用户信息
 */
+(void)getUserInfoSuccess:(void(^)(GXUserInfoModel*userInfoModel))success Failure:(void(^)(NSError*error))failure;
@end
