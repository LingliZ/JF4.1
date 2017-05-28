//
//  StarRateView.h
//  GXAppNew
//
//  Created by futang yang on 2016/12/8.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarRateView : UIView


@property (nonatomic, assign) BOOL hasAnimation;//是否允许动画，默认为NO
@property (nonatomic, assign) BOOL allowIncompleteStar;//评分时是否允许不是整星，默认为NO
@property (nonatomic, assign) NSInteger current;

- (instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars;

@end
