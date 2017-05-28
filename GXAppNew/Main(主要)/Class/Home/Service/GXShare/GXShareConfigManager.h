//
//  GXShareConfigManager.h
//  GXAppNew
//
//  Created by 王振 on 2017/3/13.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define GXShareManager [GXShareConfigManager shareManager]

//配置类型 目前只支持微信、腾讯
typedef NS_ENUM(NSInteger,GXSocialPlatConfigType){
    GXSocialPlatConfigType_WeChat,
    GXSocialPlatConfigType_Tencent,
};
//平台类型 目前只支持微信聊天、微信朋友圈、QQ聊天、qq空间
typedef NS_ENUM(NSInteger,GXSocialPlatformType){
    GXSocialPlatformType_UnKnown,      //未指定
    GXSocialPlatformType_WechatSession, //微信
    GXSocialPlatformType_WechatTimeLine,//微信朋友圈
    GXSocialPlatformType_QQ,            //QQ
    GXSocialPlatformType_Qzone,         //qq空间
};
@interface GXShareConfigManager : NSObject
//友盟分享配置 友盟key,是否开启SDK调试
@property (strong, nonatomic) NSString *shareAppKey;
@property (nonatomic,getter=isLogEnabled) BOOL shareLogEnabled;

//其它配置 分享成功跟失败的提示语
@property (strong, nonatomic) NSString *shareSuccessMessage;
@property (strong, nonatomic) NSString *shareFailMessage;

//设置微信
@property (strong, nonatomic) NSString *GXSocialPlatConfigType_Wechat_AppKey;
@property (strong, nonatomic) NSString *GXSocialPlatConfigType_Wechat_AppSecret;
@property (strong, nonatomic) NSString *GXSocialPlatConfigType_Wechat_RedirectURL;

//设置腾讯
@property (strong, nonatomic) NSString *GXSocialPlatConfigType_Tencent_AppKey;
@property (strong, nonatomic) NSString *GXSocialPlatConfigType_Tencent_AppSecret;
@property (strong, nonatomic) NSString *GXSocialPlatConfigType_Tencent_RedirectURL;

+(instancetype)shareManager;

/**
 设置平台配置内容
 
 @param platformType 平台类型
 @param appKey       appKey
 @param appSecret    appSecret
 @param redirectURL  redirectURL
 */
-(void)setPlaform:(GXSocialPlatConfigType)platformType
            appKey:(NSString *)appKey
         appSecret:(NSString *)appSecret
       redirectURL:(NSString *)redirectURL;


@end
