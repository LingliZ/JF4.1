//
//  NSString+Add.h
//  GXApp
//
//  Created by yangfutang on 16/6/29.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Add)

#pragma mark--返回一字符串的大小
/**
 *  返回一字符串的大小
 *
 *  @param size     最大size
 *  @param fontsize font大小
 *
 *  @return string的size
 */
- (CGSize)boundingWithSize:(CGSize)size FontSize:(CGFloat)fontsize;

#pragma mark--是否为正整数
/**
 *  是否为正整数
 */
- (BOOL)validatePositiveNumber:(NSString *)String;

#pragma mark--判断字符串是否是纯汉字
/**
 *  判断字符串是否是纯汉字
 *
 *  @return 结果
 */
-(BOOL)isChinese;

#pragma mark--校验姓名格式
/**
 *  校验姓名格式
 *
 *  @return 校验结果
 */
-(NSString*)checkName;
#pragma mark--校验身份证号码格式
/**
 *  校验身份证号码格式
 *
 *  @return 校验结果
 */
-(BOOL)isLegalID_CardNum;
#pragma mark--校验密码格式
/**
 *  校验密码格式
 *
 *  @return 校验结果
 */
-(NSString*)checkPassword;

#pragma mark--校验交易密码格式
/**
 *校验交易密码格式
 *
 *@return 校验结果
 */
-(BOOL)checkPay_password;
#pragma mark--校验广贵交易密码格式
/**
 *校验广贵交易密码格式
 *
 *@return 校验结果
 */
-(NSString*)checkDeal_password_Guanggui;
#pragma mark--校验昵称
/**
 *  校验昵称
 *
 *  @return 校验结果
 */
-(NSString*)checkNickName;

#pragma mark--校验意见反馈中的联系方式格式
/**
 *  校验意见反馈中的联系方式格式
 *
 *  @return 校验结果
 */
-(NSString*)checkContactForFeedBack;
#pragma mark--邮箱格式是否合法
/*
 *邮箱格式是否合法
 */
-(BOOL)isValidateEmail;

#pragma mark--时间戳
/**
 *  返回时间
 *
 *  @param quoteTime 时间戳(秒)
 *
 *  @return 时间
 */
+ (NSString *)StringFromquoteTime:(NSString *)quoteTime;

#pragma mark--传入float 转成相应的string
/**
 *  传入float 转成相应的string
 *
 *  @param floatValue float
 *
 *  @return string
 */
+ (NSString *)getKlineValue:(CGFloat )floatValue;

@end
