//
//  GXGuideManager.m
//  GXAppNew
//
//  Created by 王振 on 2017/3/13.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXGuideManager.h"
#import "GXGuidePageController.h"
#import "GXTabBarController.h"
@implementation GXGuideManager

+(instancetype)shareManager{
    static GXGuideManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[GXGuideManager alloc]init];
        }
    });
    return manager;
}
-(void)setFirstTimeStar{
    if ([self isFirstTimeStart]) {
        [self.dk_manager dawnComing];
        GXGuidePageController *guideController = [[GXGuidePageController alloc] init];
        self.rootVC = guideController;
        NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        NSMutableDictionary * parameter = [NSMutableDictionary new];
        parameter[@"idfa"] = adId;
        [GXHttpTool POSTCache:GXUrl_idfa parameters:parameter success:^(id responseObject) {
        } failure:^(NSError *error) {}];
    }else{
        GXTabBarController *tabbarVC = [[GXTabBarController alloc] init];
        self.rootVC = tabbarVC;
    }
}

- (BOOL)isFirstTimeStart{
    //取出版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults]objectForKey:@"CFBundleShortVersionString"];
    //获取当前版本  GXAppVersion CFBundleVerson CFBundleShortVersionString
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if(![currentVersion isEqualToString:lastVersion])
    {
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"CFBundleShortVersionString"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
    else
    {
        return NO;
    }
}

@end
