 //
//  AppDelegate+AppService.m
//  GXAppNew
//
//  Created by 王振 on 2016/11/29.
//  Copyright © 2016年 futang yang. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AppDelegate+AppService.h"
#import "GXPushTool.h"
#import "GXTabBarController.h"
#import "PricePlatformModel.h"
#import "GXFileTool.h"




@interface AppDelegate ()<UIAlertViewDelegate>

@end

@implementation AppDelegate (AppService)

- (void)configurationLaunchUserOption {
}

- (void)registerUmeng {
}


- (void) registerEaseMob {
    
    [GXPushTool RegisterEaseMob];
}


+ (void)updateAppBadgeNumber {
    [((AppDelegate *)[UIApplication sharedApplication].delegate) setMessage];
}


/**
 *   清除在线客服提醒数目
 */
+ (void)removeOnlineBadges {
    // 清除小红点
    NSInteger count = [GXUserInfoTool getCutomerNum];
    if (count > 0) {
        [GXUserInfoTool clearCutomerNum];
        [[NSNotificationCenter defaultCenter] postNotificationName:GXOnlineServiceCountNotificationName object:nil];
    }
}

/**
 *   增加界面红点
 */
+ (void)showBadgeOnItemIndex:(int)index {

}

/**
 *   清除界面红点
 */
+ (void)hideBadgeOnItemIndex:(int)index {
    
}

+ (UIViewController *)activityViewController
{
    UIViewController* activityViewController = nil;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if(window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows)
        {
            if(tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    NSArray *viewsArray = [window subviews];
    if([viewsArray count] > 0)
    {
        UIView *frontView = [viewsArray objectAtIndex:0];
        
        id nextResponder = [frontView nextResponder];
        
        if([nextResponder isKindOfClass:[UIViewController class]])
        {
            activityViewController = nextResponder;
        }
        else
        {
            activityViewController = window.rootViewController;
        }
    }
    
    return activityViewController;
}


+ (void)getPlaformData {
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"platform"] = @"ios";
    
    [GXHttpTool POST:GXUrl_marketInfo parameters:param  success:^(id responseObject) {
        
        if ([responseObject[GXSuccess] integerValue] == 1) {
            
            NSArray *array = [PricePlatformModel mj_objectArrayWithKeyValuesArray:responseObject[GXValue]];
            [GXFileTool saveObject:array byFileName:PricePlatformKey];
            
        } else {
            
        }
        
    } failure:^(NSError *error) {
        
    }];
}


+ (void)getUserInfo {
    [GXAddAccountTool getUserInfoSuccess:^(GXUserInfoModel *userInfoModel) {
        if(userInfoModel) {
            GXLog(@"%@",userInfoModel);
            [self dealWithUserInfoWithObjectToHeadImage:userInfoModel];
        }
    } Failure:^(NSError *error) { }];
}


+ (void)dealWithUserInfoWithObjectToHeadImage:(GXUserInfoModel*)model {
    
    NSString *headImageName = nil;
    if (model.avatar.length != 0) {
        headImageName =  [NSString stringWithFormat:@"%@%@",baseImageUrl,model.avatar];
    }
    
    [GXUserInfoTool saveUserHeadImage:headImageName];
}

@end
