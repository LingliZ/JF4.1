//
//  GXAccountDetailModel.m
//  GXAppNew
//
//  Created by shenqilong on 16/12/22.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXAccountDetailModel.h"

@implementation GXAccountDetailModel
-(NSString *)accountStatus
{
    if([_accountStatus isEqualToString:@"正常"])
    {
        return @"已激活";
    }
    return _accountStatus;
}
@end
