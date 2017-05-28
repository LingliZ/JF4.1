//
//  GXAirView.m
//  GXApp
//
//  Created by 王振 on 16/8/19.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXAirView.h"
#import "SDWebImage/SDImageCache.h"

@implementation GXAirView

- (id)initWithAirViewImageStr:(NSString *)imageStr{
    self = [super init];
    if (self) {
        self.imgUrl = imageStr;
        self.frame = CGRectMake(0, 0, GXScreenWidth, GXScreenHeight);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.userInteractionEnabled = YES;
        [self loadAdView];
    }
    return self;
}
-(void)show{
    [UIView animateWithDuration:0.3 animations:^{
        self.airView.frame = CGRectMake((GXScreenWidth - WidthScale_IOS6(290)) / 2, (GXScreenHeight - HeightScale_IOS6(380) -HeightScale_IOS6(50)) / 2, WidthScale_IOS6(290), HeightScale_IOS6(380));
        [self addSubview:_airView];
    }];
}
-(void)loadAdView{
    [self.airView addSubview:self.imgView];
    [self.airView addSubview:self.cancelBtn];
}
-(UIView *)airView{
    if (_airView == nil) {
        _airView = [[UIView alloc]initWithFrame:CGRectMake((GXScreenWidth - WidthScale_IOS6(290)) / 2, (GXScreenHeight - HeightScale_IOS6(380) - HeightScale_IOS6(45)) / 2, WidthScale_IOS6(290), HeightScale_IOS6(380) + HeightScale_IOS6(45))];
        _airView.userInteractionEnabled = YES;
        UITapGestureRecognizer *getInTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickGetInADAction:)];
        [_airView addGestureRecognizer:getInTap];
    }
    return _airView;
}
-(void)didClickGetInADAction:(UITapGestureRecognizer *)tap{
    if ((UIView *)tap.view) {
        if ([self.delegate respondsToSelector:@selector(didClickGetInToAdViewAction)]) {
            [self.delegate didClickGetInToAdViewAction];
            [self tapCancelAction];
        }
    }
}
-(UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(CGRectGetWidth(_airView.frame) - 45, 0, 45, 45);
        _cancelBtn.layer.cornerRadius = 4;
        //_cancelBtn.clipsToBounds = YES;
        [_cancelBtn setImage:[UIImage imageNamed:@"air_close_btn_pic"] forState:UIControlStateNormal];
        [_cancelBtn setBackgroundColor:[UIColor clearColor]];
        [_cancelBtn addTarget:self action:@selector(tapCancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_airView addSubview:_cancelBtn];
    }
    return _cancelBtn;
}
-(void)tapCancelAction{
    if ([self.delegate respondsToSelector:@selector(didClickCancelAirViewAction:)]) {
        [self.delegate didClickCancelAirViewAction: self];
    }
}
-(UIImageView *)imgView{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc]init];
        _imgView.userInteractionEnabled = YES;
        _imgView.frame = CGRectMake(0, 45, CGRectGetWidth(_airView.frame), CGRectGetHeight(_airView.frame) - 50);
        _imgView.layer.cornerRadius = 10;
        _imgView.layer.masksToBounds = YES;
        [_imgView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage imageNamed:@"airview_ad_pic"] options:SDWebImageTransformAnimatedImage];
    }
    return _imgView;
}

@end
