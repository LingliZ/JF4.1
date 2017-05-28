//
//  GXShareConfigManager.m
//  GXAppNew
//
//  Created by 王振 on 2017/3/13.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXShareConfigManager.h"

@implementation GXShareConfigManager

+(instancetype)shareManager{
    static GXShareConfigManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [GXShareConfigManager new];
        }
    });
    return manager;
}
-(void)setPlaform:(GXSocialPlatConfigType)platformType appKey:(NSString *)appKey appSecret:(NSString *)appSecret redirectURL:(NSString *)redirectURL{
    switch (platformType) {
        case GXSocialPlatConfigType_WeChat:
            self.GXSocialPlatConfigType_Wechat_AppKey = appKey;
            self.GXSocialPlatConfigType_Wechat_AppSecret = appSecret;
            self.GXSocialPlatConfigType_Wechat_RedirectURL = redirectURL;
            break;
        case GXSocialPlatConfigType_Tencent:
            self.GXSocialPlatConfigType_Tencent_AppKey = appKey;
            self.GXSocialPlatConfigType_Tencent_AppSecret = appSecret;
            self.GXSocialPlatConfigType_Tencent_RedirectURL = redirectURL;
        default:
            break;
    }
}



@end
