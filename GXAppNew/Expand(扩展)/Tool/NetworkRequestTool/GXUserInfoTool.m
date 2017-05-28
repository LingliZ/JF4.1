//
//  GXUserInfoTool.m
//  GXApp
//
//  Created by WangLinfang on 16/7/4.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXUserInfoTool.h"
#import "GXPriceDetailTool.h"
#import "Growing.h"
#import "AppDelegate+AppService.h"
#import "PriceIndexTool.h"



@implementation GXUserInfoTool
+(BOOL)isShowOpenAccount{
    return [GXUserdefult boolForKey:IsShowOpenAccount];
}
+(BOOL)isLogin
{
    return [GXUserdefult boolForKey:ISLOGIN];
}
+(void)loginSuccess
{
    [GXUserdefult setBool:YES forKey:ISLOGIN];
    [GXNotificationCenter postNotificationName:GXNotify_LoginSuccess object:nil];
    [GXUserdefult synchronize];
}
+(void)saveUserTocken:(NSString *)userTocken
{
    [GXUserdefult setObject:userTocken forKey:UserTocken];
    [GXUserdefult synchronize];
}
+(NSString*)getUserTocken
{
    return [GXUserdefult objectForKey:UserTocken];
}

+(NSString*)getUserSeesionTocken {
    return [GXUserdefult objectForKey:UserSeesionTocken];
}

+(void)loginOut
{

    NSMutableArray*keyArr=[[NSMutableArray alloc]initWithObjects:ISLOGIN,PhoneNumber,UserTocken,LoginAccount,UserReallyName,UserIDCardNum,UserSeesionTocken,UserID,nil];
    for(NSString*key in keyArr) {
        [GXUserdefult setObject:nil forKey:key];
        [GXUserdefult removeObjectForKey:key];
    }
    [GXUserdefult synchronize];
    [GXNotificationCenter postNotificationName:GXNotify_LoginOut object:nil];

    // 统计
    [Growing setCS1Value:nil forKey:@"user_id"];
    
    // 清除红点相关
//    [GXAppDelegate removeOnlineBadges];
//    [GXAppDelegate hideBadgeOnItemIndex:3];
//    [GXAppDelegate updateAppBadgeNumber];
    
    
    // 注销环信登录
    if ([[EaseMob sharedInstance].chatManager isLoggedIn]) {
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:NO];
    }

}
/**
 保存用户Id(登录成功后获取到的)
 */
+(void)saveUserId:(NSString*)userId
{
    GXLog(@"%@",userId);
    [GXUserdefult setObject:userId forKey:UserID];
    [GXUserdefult synchronize];
}
/**
 获取用户Id(登录成功后获取到的)
 */
+(NSString*)getUserId
{
    return [GXUserdefult objectForKey:UserID];
}
+(void)saveCustomerId:(NSString *)customerId
{
    [GXUserdefult setObject:customerId forKey:CustomerID];
    [GXUserdefult synchronize];
}
+(NSString*)getCUstomerId
{
    return [GXUserdefult objectForKey:CustomerID];
}

+(void)saveQuestionsArray:(NSMutableArray *)array withKey:(NSString *)key
{
    [GXUserdefult setObject:array forKey:key];
    [GXUserdefult synchronize];
}
+(NSMutableArray*)getQuestionsArrayWithKey:(NSString *)key
{
    return [GXUserdefult objectForKey:key];
}
/**
 *  保存用户姓名
 *
 *  @param userName 用户姓名
 */
+(void)saveUserReallyName:(NSString*)userName;
{
    [GXUserdefult setObject:userName forKey:UserReallyName];
    [GXUserdefult synchronize];
}
/**
 *  获取用户姓名
 *
 *  @return 用户姓名
 */
+(NSString*)getUserReallyName
{
    NSString *realname = [GXUserdefult objectForKey:UserReallyName];
    if (realname) {
        return  realname;
    } else {
        return  @"";
    }
}


/**
 *  保存用户昵称
 *
 *  @param nickName 用户昵称
 */
+(void)saveUserNickName:(NSString*)nickName {
    
//    if (nickName.length == 0) {
//        [GXUserdefult setObject:@"" forKey:userNickName];
//    } else {
//        
//    }
    [GXUserdefult setObject:nickName forKey:userNickName];
    [GXUserdefult synchronize];
}
/**
 *  获取用户昵称
 *
 *  @return 用户昵称
 */
+(NSString*)getUserNickName {
    NSString *nickName = [GXUserdefult objectForKey:userNickName];
    if (nickName) {
        return  nickName;
    } else {
        return  @"";
    }
}


/**
 *  保存用户头像
 *
 *  @param imageName 用户头像
 */
+(void)saveUserHeadImage:(NSString*)imageName {
    [GXUserdefult setObject:imageName forKey:userHeadImage];
    [GXUserdefult synchronize];
}


/**
 *  获取用户头像
 *
 *  @return 用户头像
 */
+(NSString*)getUserHeadImageName {
    NSString *headImage = [GXUserdefult objectForKey:userHeadImage];
    if (headImage) {
        return headImage;
    }
    
    return UserDefineHeadImage;
}



+(void)savePhoneNum:(NSString *)phoneNum
{
    [GXUserdefult setObject:phoneNum forKey:PhoneNumber];
    [GXUserdefult synchronize];
}

//获取用户电话号码
+(NSString*)getPhoneNum
{
    NSString *phone = [GXUserdefult objectForKey:PhoneNumber];
    
    if (phone) {
        return phone;
    } else {
        return  @"";
    }
}

/**
 *  保存登录账号
 *
 *  @param loginAccount 登录账号
 */
+(void)saveLoginAccount:(NSString*)loginAccount
{
    [GXUserdefult setObject:loginAccount forKey:LoginAccount];
    [GXUserdefult synchronize];
}
/**
 *  获取登录账号
 *
 *  @return 登录账号
 */
+(NSString*)getLoginAccount
{
    return [GXUserdefult objectForKey:LoginAccount];
}

/**
 *  保存用户身份证号码
 *
 *  @param idCardNum 身份证号码
 */
+(void)saveUserIDCardNum:(NSString*)idCardNum
{
    [GXUserdefult setObject:idCardNum forKey:UserIDCardNum];
    [GXUserdefult synchronize];
}
/**
 *  获取用户身份证号码
 *
 *  @return 身份证号码
 */
+(NSString*)getIDCardNum
{
    return [GXUserdefult objectForKey:UserIDCardNum];
}
/**
 *  是否联网
 *
 *  @return 结果
 */
+(BOOL)isConnectToNetwork
{
//同步
//#if (defined(__IPHONE_OS_VERSION_MIN_REQUIRED) && __IPHONE_OS_VERSION_MIN_REQUIRED >= 90000) || (defined(__MAC_OS_X_VERSION_MIN_REQUIRED) && __MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
//    struct sockaddr_in6 address;
//    bzero(&address, sizeof(address));
//    address.sin6_len = sizeof(address);
//    address.sin6_family = AF_INET6;
//#else
//    struct sockaddr_in address;
//    bzero(&address, sizeof(address));
//    address.sin_len = sizeof(address);
//    address.sin_family = AF_INET;
//#endif
//    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr *)&address);
//
//    SCNetworkReachabilityFlags flags;
//    if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
//        BOOL isReachable = ((flags & kSCNetworkReachabilityFlagsReachable) != 0);
//        return isReachable;
//    }
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    return [[AFNetworkReachabilityManager sharedManager]isReachable];
    
 //   return NO;
}
/**
 *  是否接收即时建议消息
 *  @return 是否接收
 */
+(BOOL)isReceiveAdviceMsg
{
    if(![GXUserdefult boolForKey:@"IsReceiveAdviceMsgFirstTime"])
    {
        [GXUserdefult setBool:YES forKey:@"IsReceiveAdviceMsgFirstTime"];
        [GXUserdefult setBool:YES forKey:IsReceiveAdviceMsg];
        [GXUserdefult synchronize];
    }
    return [GXUserdefult boolForKey:IsReceiveAdviceMsg];
}
/**
 *  是否接收顾问回复消息
 *  @return 是否接收
 */
+(BOOL)isReceiveReplayMsg
{
    if(![GXUserdefult boolForKey:@"IsReceiveReplayMsgFirstTime"])
    {
        [GXUserdefult setBool:YES forKey:@"IsReceiveReplayMsgFirstTime"];
        [GXUserdefult setBool:YES forKey:IsReceiveReplayMsg];
        [GXUserdefult synchronize];
    }
    return [GXUserdefult boolForKey:IsReceiveReplayMsg];
}
/**
 *  是否接收国新消息消息
 *  @return 是否接收
 */
+(BOOL)isRecieveGuoXinMsg
{
    if(![GXUserdefult boolForKey:@"IsRecieveGuoXinMsgFirstTime"])
    {
        [GXUserdefult setBool:YES forKey:@"IsRecieveGuoXinMsgFirstTime"];
        [GXUserdefult setBool:YES forKey:IsRecieveGuoXinMsg];
        [GXUserdefult synchronize];
    }
    return [GXUserdefult boolForKey:IsRecieveGuoXinMsg];
}
/**
 *  是否接收报价提醒消息
 *  @return 是否接收
 */
+(BOOL)isReceivePriceWarnMsg
{
    if(![GXUserdefult boolForKey:@"IsReceivePriceWarnMsgFirstTime"])
    {
        [GXUserdefult setBool:YES forKey:@"IsReceivePriceWarnMsgFirstTime"];
        [GXUserdefult setBool:YES forKey:IsReceivePriceWarnMsg];
        [GXUserdefult synchronize];
    }
    return [GXUserdefult boolForKey:IsReceivePriceWarnMsg];
}
/**
 *  是否接收即时建议短信提醒
 *
 *  @return 是否接收
 */
+(BOOL)isReceiveShortMsg_Suggestion {
    if(![GXUserdefult boolForKey:@"isFirstReceiveShortMsg_Suggestion"])
    {
        [GXUserdefult setBool:NO forKey:@"isFirstReceiveShortMsg_Suggestion"];
        [GXUserdefult setBool:NO forKey:IsRecieveShortMsg_Suggestion];
        [GXUserdefult synchronize];
        return NO;
    }
    return [GXUserdefult boolForKey:IsRecieveShortMsg_Suggestion];
}
/**
 *  是否接报价提醒短信提醒
 *
 *  @return 是否接收
 */
+(BOOL)isReceiveShortMsg_PriceAlert {
    if(![GXUserdefult boolForKey:@"isFirstReceiveShortMsg_PriceAlert"])
    {
        [GXUserdefult setBool:NO forKey:@"isFirstReceiveShortMsg_PriceAlert"];
        [GXUserdefult setBool:NO forKey:IsRecieveShortMsg_Price];
        [GXUserdefult synchronize];
        return NO;
    }
    return [GXUserdefult boolForKey:IsRecieveShortMsg_Price];
}
/**
 *  根据用户身份证号码获取用户的年龄
 *
 *  @param id_CardNum 身份证号码
 *
 *  @return 用户年龄
 */
+(NSString*)getUserAgeWithID_CardNum:(NSString*)id_CardNum
{
    NSDateFormatter *formatterTow = [[NSDateFormatter alloc]init];
    [formatterTow setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatterTow setDateFormat:@"yyyy-MM-dd"];
    NSDate *bsyDate = [formatterTow dateFromString:[self birthdayStrFromIdentityCard:id_CardNum]];
    
    NSTimeInterval dateDiff = [bsyDate timeIntervalSinceNow];
    
    int age = trunc(dateDiff/(60*60*24))/365;
    
    return [NSString stringWithFormat:@"%d",-age];
}
+(NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr
{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    
    BOOL isAllNumber = YES;
    
    NSString *day = nil;
    if([numberStr length]<14)
        return result;
    if([numberStr length]==18)
    {
            //**截取前14位
            NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 13)];
        
            //**检测前14位否全都是数字;
            const char *str = [fontNumer UTF8String];
            const char *p = str;
            while (*p!='\0') {
                if(!(*p>='0'&&*p<='9'))
                    isAllNumber = NO;
                p++;
            }
            if(!isAllNumber)
                return result;
        
            year = [numberStr substringWithRange:NSMakeRange(6, 4)];
            month = [numberStr substringWithRange:NSMakeRange(10, 2)];
            day = [numberStr substringWithRange:NSMakeRange(12,2)];
        
            [result appendString:year];
            [result appendString:@"-"];
            [result appendString:month];
            [result appendString:@"-"];
            [result appendString:day];
            return result;

    }
    else
    {
        //**截取前12位
        NSString *fontNumer = [numberStr substringWithRange:NSMakeRange(0, 11)];
        
        //**检测前12位否全都是数字;
        const char *str = [fontNumer UTF8String];
        const char *p = str;
        while (*p!='\0') {
            if(!(*p>='0'&&*p<='9'))
                isAllNumber = NO;
            p++;
        }
        if(!isAllNumber)
            return result;
        
        
        year = [NSString stringWithFormat:@"19%@",[numberStr substringWithRange:NSMakeRange(6, 2)]];
        month = [numberStr substringWithRange:NSMakeRange(8, 2)];
        day = [numberStr substringWithRange:NSMakeRange(10,2)];
        
        
        [result appendString:year];
        [result appendString:@"-"];
        [result appendString:month];
        [result appendString:@"-"];
        [result appendString:day];
        return result;
    }
    
    return @"";
    
}
/***
 *发送验证码
 */
+(void)sendVerCodeForViewController:(UIViewController*)viewController WithPhoneNumber:(NSString*)phoneNum FromButton:(UIButton*)button
{
    [button turnModeForSendVertyCodeWithTimeInterval:30];
    NSMutableDictionary*params=[[NSMutableDictionary alloc]init];
    params[@"mobile"]=phoneNum;
    [GXHttpTool POST:GXUrl_sendVerCode parameters:params success:^(id responseObject) {
        if([responseObject[@"success"]integerValue]!=1)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [viewController.view showFailWithTitle:responseObject[@"message"]];
            });
        }
        GXLog(@"%@",responseObject);
        
        
    } failure:^(NSError *error) {
        
        [viewController.view showFailWithTitle:@"验证码获取失败，请检查网络设置"];
        //[vi editClick];
    }];

}

/**
 *  获取默认的自选行情
 */
+ (NSString *)getDefaultPersonSelectPriceCode {
    
    NSString *key = nil;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GXpersonSelect" ofType:@"plist"];
    NSArray *defaultArray = [NSArray arrayWithContentsOfFile:path];
    
    // 同时保存自选状态
    for (NSString *priceKey in defaultArray) {
        [GXPriceDetailTool choosePersonSelectPrice:YES Key:[priceKey lowercaseString]];
    }
    
    key = [defaultArray componentsJoinedByString:@","];
    return key;
}

/**
 配置默认指标设置值
 */
+ (void)configDefaultIndexRecord {
    [PriceIndexTool creatDefaultMaParamArray];
    [PriceIndexTool creatDefaultBollParam];
    [PriceIndexTool creatDefaultRsiParam];
    [PriceIndexTool creatDefaultKdjParam];
    [PriceIndexTool creatDefaultMacdParam];
}


/**
 *  是否第一次启动
 *
 */
+ (BOOL)isAppFirstLanuch {
    if (![GXUserdefult boolForKey:@"isAppFirstLanuchNew"]) {
        [GXUserdefult setBool:YES forKey:@"isAppFirstLanuchNew"];
        [GXUserdefult synchronize];
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isFirstTimeStart{
    //取出版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults]objectForKey:@"CFBundleShortVersionString"];
    //获取当前版本  GXAppVersion CFBundleVerson CFBundleShortVersionString
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if(![currentVersion isEqualToString:lastVersion])
    {
        [GXUserdefult setObject:currentVersion forKey:@"CFBundleShortVersionString"];
        [GXUserdefult synchronize];
        return YES;
    }
    else
    {
        return NO;
    }
}



+(int)getAlarmNum
{
    return [[GXUserdefult objectForKey:priceAlarmNumber] intValue];
}


+(int)getSuggestNum
{
    return [[GXUserdefult objectForKey:suggestNumber] intValue];
}


+(int)getReplyNum
{
    return [[GXUserdefult objectForKey:replyNumber] intValue];
}


+(int)getGXMessageNum
{
    return [[GXUserdefult objectForKey:GXMessageNumber] intValue];
}

+(void)addAlarmNum
{
      int number=[[GXUserdefult objectForKey:priceAlarmNumber] intValue];
      number+=1;
      [GXUserdefult setObject:[NSNumber numberWithInt:number] forKey:priceAlarmNumber];
      [GXUserdefult synchronize];
}


+(void)addSuggestNum
{
    int number=[[GXUserdefult objectForKey:suggestNumber] intValue];
    number+=1;
    [GXUserdefult setObject:[NSNumber numberWithInt:number] forKey:suggestNumber];
    [GXUserdefult synchronize];
}


+(void)addReplyNum
{
    int number=[[GXUserdefult objectForKey:replyNumber] intValue];
    number+=1;
    [GXUserdefult setObject:[NSNumber numberWithInt:number] forKey:replyNumber];
    [GXUserdefult synchronize];

}


+(void)addGXMessageNum
{
    int number = [[GXUserdefult objectForKey:GXMessageNumber] intValue];
    number+=1;
    [GXUserdefult setObject:[NSNumber numberWithInt:number] forKey:GXMessageNumber];
    [GXUserdefult synchronize];
    
}

+(void)clearSuggestNum
{
    [GXUserdefult setObject:[NSNumber numberWithInt:0] forKey:suggestNumber];
    [GXUserdefult synchronize];
}


/**
 增加客服回复数
 */
+ (void)addCutomerNum {
    int number = [[GXUserdefult objectForKey:cutomerNumber] intValue];
    number += 1;
    [GXUserdefult setObject:[NSNumber numberWithInt:number] forKey:cutomerNumber];
    [GXUserdefult synchronize];
}


/*
 *获取客服提醒数
 */
+ (NSInteger)getCutomerNum {
    return [[GXUserdefult objectForKey:cutomerNumber] integerValue];
}

/*
 *清除客服提醒数
 */
+ (void)clearCutomerNum {
    [GXUserdefult setObject:[NSNumber numberWithInteger:0] forKey:cutomerNumber];
    [GXUserdefult synchronize];
}



+(void)clearAlarmNum
{
    [GXUserdefult setObject:[NSNumber numberWithInt:0] forKey:priceAlarmNumber];
    [GXUserdefult synchronize];
    
}


+(void)clearGXMessageNum
{
    [GXUserdefult setObject:[NSNumber numberWithInt:0] forKey:GXMessageNumber];
    [GXUserdefult synchronize];
}


+(void)clearReplyNum
{
    [GXUserdefult setObject:[NSNumber numberWithInt:0] forKey:replyNumber];
    [GXUserdefult synchronize];
    
}




+ (NSMutableArray *)getPriceAlarmArray{

    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,                                                                          NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[self getLoginAccount],PriceAlarm]];
    

    
    NSMutableArray *defaultArray = [NSMutableArray arrayWithContentsOfFile:path];
    if (defaultArray==nil) {
        defaultArray=[[NSMutableArray alloc] init];
    }
    return defaultArray;
}


+ (void)savePriceAlarmArray:(NSMutableArray *) array{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory,                                                                          NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",[self getLoginAccount],PriceAlarm]];
    [[array copy] writeToFile:path atomically:YES];
}



// 保存环信账号
+ (void)saveEaseMobAccount:(NSString *)account Password:(NSString *)password {
    [GXUserdefult setObject:account forKey:EaseMobAccount];
    [GXUserdefult setObject:password forKey:EaseMobPassword];
    [GXUserdefult synchronize];
}


+ (NSDictionary *)getEaseMobAccoutAndPassword {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    dict[EaseMobAccount] = [GXUserdefult objectForKey:EaseMobAccount];
    dict[EaseMobPassword] = [GXUserdefult objectForKey:EaseMobPassword];
    
    return dict;
}







@end
