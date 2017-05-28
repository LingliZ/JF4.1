//
//  GXChildBaseController.h
//  GXAppNew
//
//  Created by maliang on 2016/12/1.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXChildBaseController : UIViewController
{
    //当前第一条起始标识
    NSString *startId;
    //是否最新
    NSString *isLater;
    //获取条数
    NSString * count;
    //当前最后一条标识
    NSString * endId;
    //是否加载更多
    NSString * isMore;
    //当前一条标识
    NSString * topId;
}

@end
