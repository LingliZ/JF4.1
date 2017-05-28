//
//  GXUserInfoTool.h
//  GXApp
//
//  Created by WangLinfang on 16/7/4.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GXUserInfoTool : NSObject


#pragma ----- isShowOpenAccount -----
/*
 *是否显示开户功能条
 */
+(BOOL)isShowOpenAccount;

#pragma mark--返回当前是否已登录
/**
*  返回当前是否已登录
*
*  @return 登录状态
*/
+(BOOL)isLogin;

#pragma mark--登录成功
/**
 *  登录成功
 */
+(void)loginSuccess;

#pragma mark--登录后保存用户Tocken
/**
 *   登录后保存用户Tocken
 *
 *  @param userTocken
 */
+(void)saveUserTocken:(NSString *)userTocken;

#pragma mark--获取用户Tocken
/**
 获取用户Tocken
 */
+(NSString*)getUserTocken;

#pragma mark--获取用户SeesionTocken
/**
 获取用户SeesionTocken
 */
+(NSString*)getUserSeesionTocken;

#pragma mark--退出登录
/**
 退出登录
 */
+(void)loginOut;

#pragma mark--保存用户Id(登录成功后获取到的)
/**
 保存用户Id(登录成功后获取到的)
 */
+(void)saveUserId:(NSString*)userId;

#pragma mark--获取用户Id(登录成功后获取到的)
/**
 获取用户Id(登录成功后获取到的)
 */
+(NSString*)getUserId;

#pragma mark--保存用户Id(开户时获取到的)
/**
 保存用户Id(开户时获取到的)
 */
+(void)saveCustomerId:(NSString*)customerId;

#pragma mark--获取用户Id(开户时)
/**
获取用户Id(开户时)
 */
+(NSString*)getCUstomerId;
/**
 保存问卷题目
 */
+(void)saveQuestionsArray:(NSMutableArray*)array withKey:(NSString*)key;
/**
 获取问卷题目
 */
+(NSMutableArray*)getQuestionsArrayWithKey:(NSString *)key;

#pragma mark--保存用户姓名
/**
 *  保存用户姓名
 *
 *  @param userName 用户姓名
 */
+(void)saveUserReallyName:(NSString*)userName;

#pragma mark--获取用户姓名
/**
 *  获取用户姓名
 *
 *  @return 用户姓名
 */
+(NSString*)getUserReallyName;



/**
 *  保存用户昵称
 *
 *  @param userName 用户昵称
 */
+(void)saveUserNickName:(NSString*)nickName;
/**
 *  获取用户昵称
 *
 *  @return 用户昵称
 */
+(NSString*)getUserNickName;


/**
 *  保存用户头像
 *
 *  @param image 用户头像
 */
+(void)saveUserHeadImage:(NSString*)imageName;
/**
 *  获取用户头像
 *
 *  @return 用户头像
 */
+(NSString*)getUserHeadImageName;

#pragma mark--保存用户手机号
/**
 保存用户手机号
 */
+(void)savePhoneNum:(NSString*)phoneNum;

#pragma mark--获取用户手机号
/**
 获取用户手机号
 */
+(NSString*)getPhoneNum;

#pragma mark--保存登录账号
/**
 *  保存登录账号
 *
 *  @param loginAccount 登录账号
 */
+(void)saveLoginAccount:(NSString*)loginAccount;

#pragma mark--获取登录账号
/**
 *  获取登录账号
 *
 *  @return 登录账号
 */
+(NSString*)getLoginAccount;

#pragma mark--保存用户身份证号码
/**
 *  保存用户身份证号码
 *
 *  @param idCardNum 身份证号码
 */
+(void)saveUserIDCardNum:(NSString*)idCardNum;

#pragma mark--获取用户身份证号码
/**
 *  获取用户身份证号码
 *
 *  @return 身份证号码
 */
+(NSString*)getIDCardNum;

#pragma mark--是否联网
/**
 *  是否联网
 *
 *  @return 结果
 */
+(BOOL)isConnectToNetwork;

#pragma mark--是否接收即时建议消息
/**
 *  是否接收即时建议消息
 *  @return 是否接收
 */
+(BOOL)isReceiveAdviceMsg;

#pragma mark--是否接收顾问回复消息
/**
 *  是否接收顾问回复消息
 *  @return 是否接收
 */
+(BOOL)isReceiveReplayMsg;

#pragma mark--是否接收国新消息消息
/**
 *  是否接收国新消息消息
 *  @return 是否接收
 */
+(BOOL)isRecieveGuoXinMsg;

#pragma mark--是否接收报价提醒消息
/**
 *  是否接收报价提醒消息
 *  @return 是否接收
 */
+(BOOL)isReceivePriceWarnMsg;

#pragma mark--是否接收即时建议短信提醒
/**
 *  是否接收即时建议短信提醒
 *
 *  @return 是否接收
 */
+(BOOL)isReceiveShortMsg_Suggestion;

#pragma mark--是否接报价提醒短信提醒
/**
 *  是否接报价提醒短信提醒
 *
 *  @return 是否接收
 */
+(BOOL)isReceiveShortMsg_PriceAlert;

#pragma mark--根据用户身份证号码获取用户的年龄
/**
 *  根据用户身份证号码获取用户的年龄
 *
 *  @param id_CardNum 身份证号码
 *
 *  @return 用户年龄
 */
+(NSString*)getUserAgeWithID_CardNum:(NSString*)id_CardNum;

#pragma mark--发送验证码
/***
 *发送验证码
 */
+(void)sendVerCodeForViewController:(UIViewController*)viewController WithPhoneNumber:(NSString*)phoneNum FromButton:(UIButton*)button;

#pragma mark--获取默认的自选行情
/**
 *  获取默认的自选行情
 */
+ (NSString *)getDefaultPersonSelectPriceCode;

#pragma mark-- 配置默认指标设置值
/**
 配置默认指标设置值
 */
+ (void)configDefaultIndexRecord;

#pragma mark--是否是第一次启动
/**
 *  是否是第一次启动
 */
+ (BOOL)isAppFirstLanuch;

+ (BOOL)isFirstTimeStart;

#pragma mark--获取报价提醒列表
/**
 *  获取报价提醒列表
 */
+ (NSMutableArray *)getPriceAlarmArray;


#pragma mark--保存报价提醒列表
/**
 *  保存报价提醒列表
 */
+ (void)savePriceAlarmArray:(NSMutableArray *) array;

#pragma mark--增加报价数
/*
 *增加报价数
 */
+(void)addAlarmNum;

#pragma mark--增加建议数
/**
 增加建议数
 */
+(void)addSuggestNum;

#pragma mark--增加回复数
/**
增加回复数
 */
+(void)addReplyNum;

#pragma mark-- 增加客服回复数
/**
 增加客服回复数
 */
+ (void)addCutomerNum;

#pragma mark--获取客服提醒数
/*
 *获取客服提醒数
 */
+ (NSInteger)getCutomerNum;

#pragma mark--获取消息提醒数
/*
 *获取消息提醒数
 */
+(int)getAlarmNum;

#pragma mark--获取建议数
/**
 获取建议数
 */
+(int)getSuggestNum;

#pragma mark-- 获取回复个数
/**
 获取回复个数
 */
+(int)getReplyNum;

+(void)clearAlarmNum;


+(void)clearSuggestNum;


+(void)clearReplyNum;

+(void)addGXMessageNum;

+(void)clearGXMessageNum;

+(int)getGXMessageNum;

+ (void)clearCutomerNum;




#pragma mark--保存环信账号密码
/*
 * 保存环信账号密码
 */
+ (void)saveEaseMobAccount:(NSString *)account Password:(NSString *)password;

#pragma mark--获取环信账号密码
/*
 * 获取环信账号密码
 */
+ (NSDictionary *)getEaseMobAccoutAndPassword;


@end
