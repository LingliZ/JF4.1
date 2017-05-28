//
//  AppDelegate.m
//  GXAppNew
//
//  Created by futang yang on 2016/11/28.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+AppService.h"
#import "GXTabBarController.h"
#import "GXUserInfoTool.h"
#import "GXPushTool.h"
#import "GXGuideManager.h"
#import "GXInstantAdviceController.h"
#import "GXInstantAdviceListController.h"
#import "GXMessagesController.h"
#import "GXConsultantReplyViewController.h"
#import "GXPriceWarningController.h"
#import "ChatViewController.h"
#import "PriceIndexTool.h"
#import <UMSocialCore/UMSocialCore.h>
#import "GXAlertTestController.h"
#import "Growing.h"
#import <UMMobClick/MobClick.h>

// 引入JPush功能所需头文件
#import "JPUSHService.h"
#import "GXLiveCastViewController.h"
#import "GXLiveController.h"
#import "GXRegisterViewController.h"
#import "GXAddCountIndexController.h"
#import "GXInformationModel.h"
#import "GXGlobalArticleDetailController.h"
#import "GXBanAnaRemImpDetailController.h"



@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 请求交易所数据
    [AppDelegate getPlaformData];
    
    [self setMessage];
    [self setAppWindows];
    
    // GroingIO
    [Growing setDeviceIDModeToIDFA];
    [Growing startWithAccountId:GXGrowingAppKey];
    if ([GXUserInfoTool isLogin]) {
        [Growing setCS1Value:[GXUserInfoTool getLoginAccount] forKey:@"user_id"];
    }

    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    //友盟appkey
    [[UMSocialManager defaultManager]setUmSocialAppkey:GXUMSocialDataAppKey];
    //友盟统计
    [MobClick setLogEnabled:YES];
    //    UMConfigInstance.appKey = @"5776072967e58e9709003422";
    //    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.appKey = GXUMSocialDataAppKey;
    UMConfigInstance.channelId = @"App Store";
    //友盟统计的版本信息获取方式
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    GXLog(@"%@",version);
    [MobClick setAppVersion:version];
    [MobClick startWithConfigure:UMConfigInstance];
    //设置微信分享
    [[UMSocialManager defaultManager]setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxa0370a7b2fbc7736" appSecret:@"1b912a80f6c1886969bc76f5a72a4c1c" redirectURL:@"http://www.91jin.com"];
    //设置QQ分享
    [[UMSocialManager defaultManager]setPlaform:UMSocialPlatformType_QQ appKey:@"1104665409" appSecret:nil redirectURL:@"http://www.91jin.com"];
    //apns推送登录
    [GXPushTool registerSDKWithAppKey];
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    
    
    
    [JPUSHService setupWithOption:launchOptions appKey:JPushKey
                          channel:@"App Store"
                 apsForProduction:JpushApsForProduction
            advertisingIdentifier:nil];
    
    
    
    // 登录环信
    if (![GXUserInfoTool isLogin]) {
        [self registerEaseMob];
    }
    //获取行情数据配置指标数值
    if ([GXUserInfoTool isAppFirstLanuch]) {
        [GXUserInfoTool getDefaultPersonSelectPriceCode];
        [GXUserInfoTool configDefaultIndexRecord];
        [PriceIndexTool creatDefaultPeriodIndex];
        [PriceIndexTool creatDefaultTopBottomParam];
    }
    //第一次(版本更新)启动进入引导页
    [[GXGuideManager shareManager]setFirstTimeStar];
    self.window.rootViewController = [GXGuideManager shareManager].rootVC;
    [self.window makeKeyAndVisible];
    
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    [GXPushTool registerForRemoteNotificationsWith:application];
    
    /** app进程被杀死后，启动app获取推送消息 */
    NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo) {
        NSString *temp = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        if (temp.length > 0) {
            NSString *alert = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
            if (alert.length != 0 && alert.length >= 6) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSString *str = [alert substringWithRange:NSMakeRange(0, 6)];
                    [self detailActionClick:str];
                });
                
            }
        }
        
    }
    return YES;
}

- (void)doSomething:(NSString *)param {
    
    if (param == nil) {
        param = @"空的";
    }
    // 自定义事件
    UIAlertController *alertController=[UIAlertController alertControllerWithTitle:param message:param preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *sureAction=[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"do somting");
    }];
    [alertController addAction:sureAction];
    
    
    UIWindow *alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    alertWindow.rootViewController = [[UIViewController alloc] init];
    alertWindow.windowLevel = UIWindowLevelAlert + 1;
    [alertWindow makeKeyAndVisible];
    [alertWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}


//分享系统回调
-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
- (void)setAppWindows {
    // 创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    [[NSNotificationCenter defaultCenter]postNotificationName:NotyFicationForDidEnterForeground object:nil];
}
- (void)applicationWillTerminate:(UIApplication *)application {
    [[EaseMob sharedInstance] applicationWillTerminate:application];
}

#pragma mark - EMChatManagerDelegate
- (void)didReceiveMessage:(EMMessage *)message{
    NSString *alertText = ((EMTextMessageBody *)message.messageBodies.firstObject).text;
    [self configMessageWithEMMessage:message alertStr:alertText];
}
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages {
    for (EMMessage * message in offlineMessages) {
        NSString *alertText = ((EMTextMessageBody*)[message.messageBodies objectAtIndex:0]).text;
        if ([alertText containsString:@"[即时建议]"]){
            [GXUserdefult setObject:alertText forKey:suggestLocalMsg];
        }else if ([alertText containsString:@"[顾问回复]"]){
            [GXUserdefult setObject:alertText forKey:replyLocalMsg];
        }else if ([alertText containsString:@"[国鑫消息]"]){
            [GXUserdefult setObject:alertText forKey:GXMessageLocalMsg];
        }else{
            [GXUserdefult setObject:alertText forKey:priceAlarmLocalMsg];
        }
        [GXUserdefult synchronize];

        if(!([alertText containsString:@"[顾问回复]"]||[alertText containsString:@"[报价提醒]"]||[alertText containsString:@"[即时建议]"]||[alertText containsString:@"[国鑫消息]"])) {
            alertText = [NSString stringWithFormat:@"[在线客服]%@",alertText];
        }
        NSString *title = [alertText substringToIndex:6];
        NSString *contentStr = [alertText substringFromIndex:6];
        NSString *newStr = [self filterHTML:contentStr];
        if ([title isEqualToString:@"[顾问回复]"]) {
            contentStr = newStr;
        }

        [self saveTag:title];
        if ([title isEqualToString:@"[报价提醒]"]) {
            [self savePriceAlarmAlert:title Message:message];
        }
//        [self configMessageWithEMMessage:message alertStr:alert];
    }
}
-(void)configMessageWithEMMessage:(EMMessage *)message alertStr:(NSString *)alertText{
    if ([alertText containsString:@"[即时建议]"]){
        [GXUserdefult setObject:alertText forKey:suggestLocalMsg];
    }else if ([alertText containsString:@"[顾问回复]"]){
        [GXUserdefult setObject:alertText forKey:replyLocalMsg];
    }else if ([alertText containsString:@"[国鑫消息]"]){
        [GXUserdefult setObject:alertText forKey:GXMessageLocalMsg];
    }else{
        [GXUserdefult setObject:alertText forKey:priceAlarmLocalMsg];
    }
    [GXUserdefult synchronize];
    if (!([alertText containsString:@"[顾问回复]"]
          || [alertText containsString:@"[报价提醒]"]
          || [alertText containsString:@"[即时建议]"]
          || [alertText containsString:@"[国鑫消息]"])) {
        alertText = [NSString stringWithFormat:@"[在线客服]%@", alertText];
    }
    NSString *title = [alertText substringToIndex:6];
    NSString *contentStr = [alertText substringFromIndex:6];
    NSString *newStr = [self filterHTML:contentStr];
    if ([title isEqualToString:@"[顾问回复]"]) {
        contentStr = newStr;
    }
    //后台
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:2];
        UILocalNotification *localNotify = [[UILocalNotification alloc] init];
        if (localNotify) {
            localNotify.fireDate = date;
            localNotify.timeZone = [NSTimeZone defaultTimeZone];
            localNotify.alertTitle = title;
            localNotify.alertBody = contentStr;
            localNotify.soundName = UILocalNotificationDefaultSoundName;
            //发送通知
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotify];
            [self saveTag:title];
            if ([alertText containsString:@"[报价提醒]"]) {
                [self savePriceAlarmAlert:contentStr Message:message];
            }
            
        }
    }else{
        if ([alertText containsString:@"[报价提醒]"]) {
            [self savePriceAlarmAlert:contentStr Message:message];
        }
        
        //接受及时建议
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:title message:contentStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureA = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
        UIAlertAction *detailA = [UIAlertAction actionWithTitle:@"查看详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self detailActionClick:title];
        }];
        [alertC addAction:sureA];
        [alertC addAction:detailA];
        bool settingResult =
        ([GXUserInfoTool isReceiveAdviceMsg] && [title isEqualToString:@"[即时建议]"])
        || ([GXUserInfoTool isReceivePriceWarnMsg] && [title isEqualToString:@"[报价提醒]"])
        || ([GXUserInfoTool isReceiveReplayMsg] && [title isEqualToString:@"[顾问回复]"])
        || ([GXUserInfoTool isRecieveGuoXinMsg] && [title isEqualToString:@"[国鑫消息]"]);
        
        if (settingResult) {
            [self.window.rootViewController presentViewController:alertC animated:true completion:nil];
        } else {
            [self saveTag:title];
        }
    }
}
- (void)saveTag:(NSString *)title{
    if ([title isEqualToString:@"[顾问回复]"]) {
        [GXUserInfoTool addReplyNum];
    }else if ([title isEqualToString:@"[即时建议]"]){
        [GXUserInfoTool addSuggestNum];
    }else if ([title isEqualToString:@"[报价提醒]"]){
        [GXUserInfoTool addAlarmNum];
    }else if ([title isEqualToString:@"[国鑫消息]"]){
        [GXUserInfoTool addGXMessageNum];
    }else if ([title isEqualToString:@"[在线客服]"]){
        [GXUserInfoTool addCutomerNum];
        // 如果在后台
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            // 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:GXOnlineServiceCountNotificationName object:nil];
        }
    }
    [self setMessage];
}

// 设置首页推送个数
-(void) setMessage {
    GXTabBarController *controller = (GXTabBarController*)[self activityViewController];
    int msgCount = [GXUserInfoTool getAlarmNum]+[GXUserInfoTool getReplyNum]+[GXUserInfoTool getSuggestNum] + [GXUserInfoTool getGXMessageNum];
    int serviceCount = [GXUserInfoTool getCutomerNum];
    //    if(controller.selectedIndex == 0){
    NSInteger subCount = [controller.selectedViewController.childViewControllers count];
    if (subCount == 1) {
        // GXHomeController *gxControll=[controller.selectedViewController.childViewControllers objectAtIndex:0];
        if (msgCount > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GXHomeCountNotificationName object:[NSNumber numberWithInt:msgCount]];
        }
        if (serviceCount > 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GXOnlineServiceCountNotificationName object:nil];
        }
    }
    //    }
    if ((msgCount + serviceCount) > 0) {
         [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    }
}

//记录报价提醒
-(void) savePriceAlarmAlert:(NSString *) alert Message:(EMMessage *)message {
    
        if([message.ext objectForKey:@"msg"]!=nil){
            NSDictionary * alertDic = @{@"code":[[[message.ext objectForKey:@"msg"] componentsSeparatedByString:@"|"] objectAtIndex:0],@"time":[[[message.ext objectForKey:@"msg"] componentsSeparatedByString:@"|"] objectAtIndex:1],@"content":alert};
            NSMutableArray *priceAlarmArray=[GXUserInfoTool getPriceAlarmArray];
            [priceAlarmArray insertObject:alertDic atIndex:0];
            [GXUserInfoTool savePriceAlarmArray:priceAlarmArray];
            //  [[NSNotificationCenter defaultCenter] postNotificationName:GXAppDelegateRemindNotificationName object:nil];
        }
    
}
#pragma mark - 接收到Apns通知 应用没有运行
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    if (application.applicationState != UIApplicationStateActive) {
        NSString *alertTitle = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] substringFromIndex:6];
        [self saveTag:alertTitle];
    }

   
    // 激光推送
    [JPUSHService handleRemoteNotification:userInfo];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    if (application.applicationState == UIApplicationStateActive) {
        return;
    }
    [self dkfldjfkldjfl:userInfo];
    [JPUSHService handleRemoteNotification:userInfo];
}


- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([Growing handleUrl:url]) // 请务必确保该函数被调用
    {
        return YES;
    }
    return NO;
}



- (void)dkfldjfkldjfl:(NSDictionary *)userInfo {
    
    NSString *str = [userInfo objectForKey:@"exMessage"];

    if (str.length != 0) {
        NSArray *array = [str componentsSeparatedByString:@"|"];
        
      [self detailJPushActionClick:array];
        
    }
}

#pragma mark - 注册Apns通知
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString *tokenStr = [[NSString alloc] initWithData:deviceToken encoding:NSASCIIStringEncoding];
    GXLog(@"tokenStr:%@",tokenStr);
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    GXLog(@"注册远程通知错误:%@",error);
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}
#pragma mark - 接收到本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [self detailActionClick:notification.alertTitle];
}

- (void)detailJPushActionClick: (NSArray *)array {
    
    NSString *temp1 = [array firstObject];
    NSString *temp2 = [array lastObject];
    
    UIViewController *vc;
    if ([temp1 isEqualToString:@"LiveVideo"]) {
        
        [GXUserdefult setObject:@"31" forKey:GXRoomId];
        vc = [[GXLiveCastViewController alloc] init];
    }
    else if ([temp1 isEqualToString:@"DiscoverPlatform"])
    {
        vc = [[GXLiveController alloc] init];
        
        GXTabBarController *tabBarC = (GXTabBarController *)self.window.rootViewController;
        [tabBarC setSelectedIndex:2];
        
        return;
    }
    else if ([temp1 isEqualToString:@"UserRegister"])
    {
        vc = [[GXRegisterViewController alloc] init];
        
    }
    else if ([temp1 isEqualToString:@"OpenAccount"])
    {
        vc = [[GXAddCountIndexController alloc] init];
        
    }
    else if ([temp1 isEqualToString:@"Information"])
    {
        GXInformationModel *model=[[GXInformationModel alloc]init];
        model.ID=temp2;
        
        GXGlobalArticleDetailController *vvv = [[GXGlobalArticleDetailController alloc] init];
        vvv.informationModel=model;
        
        vc=vvv;
        
    }
    else if ([temp1 isEqualToString:@"Active"])
    {
        GXBanAnaRemImpDetailController *vvv=[[GXBanAnaRemImpDetailController alloc]init];
        
        if(![temp2 hasPrefix:@"http"])
        {
            temp2=[@"http://" stringByAppendingString:temp2];
        }
        
        vvv.webUrl=temp2;
        vvv.title=@"活动";

        vc=vvv;
    
    }
    
    if ([self.window.rootViewController isKindOfClass:[GXTabBarController class]]) {
        GXTabBarController *tabBarC = (GXTabBarController *)self.window.rootViewController;
        UINavigationController *selectedNav = tabBarC.childViewControllers[tabBarC.selectedIndex];
        [selectedNav pushViewController:vc animated:true];
    }
}


- (void)detailActionClick: (NSString *)title{
    UIViewController *vc;
    if ([title isEqualToString:@"[顾问回复]"]) {
        vc = [[GXConsultantReplyViewController alloc]init];
    }else if ([title isEqualToString:@"[即时建议]"]){
        vc = [[GXInstantAdviceListController alloc]init];
    }else if ([title isEqualToString:@"[报价提醒]"]){
        vc = [[GXPriceWarningController alloc]init];
    }else if ([title isEqualToString:@"[国鑫消息]"]){
        vc = [[GXMessagesController alloc]init];
    }else if ([title isEqualToString:@"[在线客服]"]){
        vc = [[ChatViewController alloc]init];
    }

    if ([self.window.rootViewController isKindOfClass:[GXTabBarController class]]) {
        GXTabBarController *tabBarC = (GXTabBarController *)self.window.rootViewController;
        UINavigationController *selectedNav = tabBarC.childViewControllers[tabBarC.selectedIndex];
        [selectedNav pushViewController:vc animated:true];
    }
}
// 获取当前处于activity状态的view controller
- (UIViewController *)activityViewController
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
//去掉 HTML 字符串中的标签
- (NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}
@end
