//
//  SvStatusBarTipsWindow.h
//  oser
//
//  Created by 沈启龙 on 14-1-25.
//



#import <UIKit/UIKit.h>

@interface SvStatusBarTipsWindow : UIWindow

/*
 * @brief get the singleton tips window
 */
//+ (SvStatusBarTipsWindow*)shareTipsWindow;

/*
 * @brief show tips message on statusBar
 */
- (void)showTips:(NSString*)tips;

/*
 * @brief show tips message on statusBar
 */
- (void)showTips:(NSString*)tips hideAfterDelay:(NSInteger)seconds;

/*
 * @brief show tips icon and message on statusBar
 */
- (void)showTipsWithImage:(UIImage*)tipsIcon message:(NSString*)message;

/*
 * @brief show tips icon and message on statusBar
 */
- (void)showTipsWithImage:(UIImage*)tipsIcon message:(NSString*)message hideAfterDelay:(NSInteger)seconds;


/*
 * @brief hide tips window
 */
- (void)hideTips;

@end

