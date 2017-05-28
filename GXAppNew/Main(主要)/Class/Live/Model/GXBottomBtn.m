//
//  GXBottomBtn.m
//  GXAppNew
//
//  Created by zhudong on 2016/11/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXBottomBtn.h"
#import "GXLiveCommonSize.h"
#define imgRatio 0.6

@implementation GXBottomBtn
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize9);
        
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 3, self.frame.size.width, self.frame.size.height * imgRatio);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, self.frame.size.height * imgRatio - 1, self.frame.size.width, self.frame.size.height *  (1 - imgRatio));
}
@end
