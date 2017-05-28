//
//  GXTipAlertView.h
//  GXAppNew
//
//  Created by zhudong on 2017/3/6.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
//#define TipAlertWidth WidthScale_IOS6(260)
#define TipAlertWidth 260

@class GXTipAlertView;
@protocol GXTipAlertViewDelegate <NSObject>

- (void)btnClick: (GXTipAlertView *)tipAlertView;

@end
@interface GXTipAlertView : UIView

@property (nonatomic,weak) id<GXTipAlertViewDelegate> delegate;
- (instancetype)initWithTitle:(NSString *)title desView:(UIView *)desView btns:titles sureBtnColor: (UIColor *)color;

@end
