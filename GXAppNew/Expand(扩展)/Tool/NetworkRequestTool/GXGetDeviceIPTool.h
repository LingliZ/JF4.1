//
//  GXGetDeviceIPTool.h
//  GXApp
//
//  Created by WangLinfang on 16/6/28.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <arpa/inet.h>
#import <ifaddrs.h>

@interface GXGetDeviceIPTool : NSObject
+(NSString *)deviceIPAdress;
@end
