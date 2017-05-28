//
//  GXAlertTestController.h
//  GXAppNew
//
//  Created by 王振 on 2017/1/22.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WZBlock)();
@interface GXAlertTestController : UIViewController

/** 设置alertView背景色 */
@property (nonatomic, copy) UIColor *alertBackgroundColor;
/** 设置确定按钮背景色 */
@property (nonatomic, copy) UIColor *btnConfirmBackgroundColor;
/** 设置取消按钮背景色 */
@property (nonatomic, copy) UIColor *btnCancelBackgroundColor;
/** 设置message字体颜色 */
@property (nonatomic, copy) UIColor *messageColor;

+(instancetype)shareManager;
-(void)alertViewWithMessage:(NSString *)messageStr WithTitle:(NSString *)titleStr WithBlock:(WZBlock)block;

@end
