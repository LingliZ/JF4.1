//
//  CanlendarHearView.m
//  GXAppNew
//
//  Created by futang yang on 2016/12/8.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "CanlendarHearView.h"

@implementation CanlendarHearView


- (instancetype)initWithTitle:(NSString *)title frame:(CGRect)frame {
  
    if (self = [super initWithFrame:frame]) {
        
        UILabel *label = [[UILabel alloc] init];
        label.font = GXFONT_PingFangSC_Regular(14);
        label.textColor = GXWhiteColor;
        label.text = title;
        [self addSubview:label];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(WidthScale_IOS6(15));
            make.centerY.mas_equalTo(self.mas_centerY);
        }];

        
    }

    return self;
}



- (void)config {
    
    UILabel *label = [[UILabel alloc] init];
    label.font = GXFONT_PingFangSC_Regular(14);
    label.textColor = GXWhiteColor;
    label.text = @"本周财经日历";
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
   
        make.left.mas_equalTo(WidthScale_IOS6(15));
        make.centerY.mas_equalTo(self.mas_centerY);
        
    }];
    
}

@end
