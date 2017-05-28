//
//  GXAccountOrderListModel.m
//  GXAppNew
//
//  Created by shenqilong on 16/12/26.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXAccountOrderListModel.h"

@implementation GXAccountOrderListModel
-(NSString *)bsFlag_lb
{
    if([_bsFlag intValue]==1)
    {
        return @"买";
    }
    return @"卖";
}
@end
