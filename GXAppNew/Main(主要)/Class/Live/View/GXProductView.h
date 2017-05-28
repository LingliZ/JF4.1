//
//  GXProductView.h
//  GXAppNew
//
//  Created by zhudong on 2017/1/12.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TopViewLeftOffset 50

@interface GXProductView : UIView
@property (nonatomic,copy) void (^productDelegate)(GXProductView *productView);
@end
