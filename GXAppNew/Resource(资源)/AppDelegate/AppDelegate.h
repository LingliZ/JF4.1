//
//  AppDelegate.h
//  GXAppNew
//
//  Created by futang yang on 2016/11/28.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,EMChatManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

-(void)setMessage;

@end

