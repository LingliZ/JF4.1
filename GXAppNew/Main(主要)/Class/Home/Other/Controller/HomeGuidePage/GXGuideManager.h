//
//  GXGuideManager.h
//  GXAppNew
//
//  Created by 王振 on 2017/3/13.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GXGuideManager : NSObject

@property (nonatomic,strong)UIViewController *rootVC;

+(instancetype)shareManager;

-(void)setFirstTimeStar;


@end
