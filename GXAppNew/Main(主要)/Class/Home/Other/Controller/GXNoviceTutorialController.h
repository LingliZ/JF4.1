//
//  GXNoviceTutorialController.h
//  Newbie guide tutorial
//
//  Created by 王振 on 2017/2/6.
//  Copyright © 2017年 wangzhen. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, GXGuideControllerCleanMode) {
    GuideViewCleanModeCycleRect, //圆形
    GuideViewCleanModeRoundRect,      //矩形
    GuideViewCleanModeOval     //椭圆
};
@interface GXNoviceTutorialController : UIViewController

@property (nonatomic, strong) NSArray *btnFrames;
@property (nonatomic, strong) NSArray *imgFrames;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *styles;

@end
