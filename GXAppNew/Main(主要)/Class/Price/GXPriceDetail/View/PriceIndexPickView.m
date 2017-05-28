//
//  PriceIndexPickView.m
//  GXAppNew
//
//  Created by futang yang on 2017/1/3.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "PriceIndexPickView.h"

@implementation PriceIndexPickView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}


- (void)config {
    
    UILabel *labele1 = [[UILabel alloc] init];
    self.labele1 = labele1;
    [self addSubview:self.labele1];
    
    labele1.textAlignment = NSTextAlignmentLeft;
    labele1.textColor = GXRGBColor(0, 0, 0);
    labele1.font = GXFONT_PingFangSC_Regular(24);
    

    [self.labele1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).mas_equalTo(50);
    }];
    
    
    UILabel *labele2 = [[UILabel alloc] init];
    self.labele2 = labele2;
    [self addSubview:self.labele2];
    
    labele2.textAlignment = NSTextAlignmentRight;
    labele2.textColor = GXRGBColor(0, 0, 0);
    labele2.font = GXFONT_PingFangSC_Regular(16);
    
    
    [self.labele2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    
    
    
    
    
}


@end
