//
//  PriceIndexTableHeader.m
//  GXAppNew
//
//  Created by futang yang on 2017/1/3.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "PriceIndexTableHeader.h"

@implementation PriceIndexTableHeader {
    UILabel *titleLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // rgb 233 235 243
        self.backgroundColor = GXRGBColor(233, 235, 243);
        
        [self config];
    }
    return self;
}


- (void)config {
    titleLabel = [[UILabel alloc] init];
    [self addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(16);
    }];
    
    // 161 166 187
    titleLabel.textColor = GXRGBColor(161, 166, 187);
    titleLabel.font = GXFONT_PingFangSC_Regular(14.6);
}


- (void)setTitle:(NSString *)title {
    _title = title;
    titleLabel.text = title;
}


@end
