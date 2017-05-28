//
//  GXCourseView.h
//  GXAppNew
//
//  Created by zhudong on 2016/12/2.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXCourseView : UIView
@property (nonatomic,copy) void (^courseDelegate)(GXCourseView *view);
@end
