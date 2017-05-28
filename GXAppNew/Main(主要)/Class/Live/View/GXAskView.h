//
//  GXAskView.h
//  GXAppNew
//
//  Created by zhudong on 2016/12/8.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXTextView.h"

@interface GXAskView : UIView
@property (nonatomic, strong) GXTextView *textField;
@property (nonatomic,copy) void (^sendBtnClickDelegate)(NSString *contentStr);
- (void)setTextFieldColor: (UIColor *)color;
@end
