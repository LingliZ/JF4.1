//
//  GXLiveBtn.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXLiveBtn.h"

#define BtnImageRatio 0.1

@implementation GXLiveBtn

- (instancetype)initWithFrame:(CGRect)frame title: (NSString *)title{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.frame = CGRectMake(0, 0, frame.size.width * BtnImageRatio, frame.size.height);
        self.titleLabel.frame = CGRectMake(frame.size.width * BtnImageRatio, 0, frame.size.width * (1 - BtnImageRatio), frame.size.height);
        self.titleLabel.textColor = [UIColor whiteColor];
    }
    return self;
}

@end
