//
//  AppDelegate+AppService.h
//  GXAppNew
//
//  Created by 王振 on 2016/11/29.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (AppService)

/**
 *  基本配置
 */
- (void)configurationLaunchUserOption;

/**
 *  友盟注册
 */
- (void)registerUmeng;



/**
 获取个人数据
 */
+ (void)getUserInfo;

/**
 *   注册环信
 */
- (void)registerEaseMob;


/**
 *   更新提醒数量
 */
+ (void)updateAppBadgeNumber;

/**
 *   清除在线客服提醒数目
 */
+ (void)removeOnlineBadges;

/**
 *   清除我的界面红点
 */
+ (void)removeMineBadges;


+ (void)showBadgeOnItemIndex:(int)index;

/**
 *   清除我的界面红点
 */
+ (void)hideBadgeOnItemIndex:(int)index;

/**
 *   当前控制器
 */
+ (UIViewController *)activityViewController;


/**
 请求交易所数据
 */
+ (void)getPlaformData;

@end
