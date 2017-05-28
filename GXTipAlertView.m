//
//  GXTipAlertView.m
//  GXAppNew
//
//  Created by zhudong on 2017/3/6.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXTipAlertView.h"

#define TipTopBGColor GXRGBColor(247, 247, 247)

@interface GXTipAlertView ()
{
    CGFloat h;
}
@property (nonatomic, strong) UIView *centerV;
@end

@implementation GXTipAlertView

- (instancetype)initWithTitle:(NSString *)title desView:(UIView *)desView btns:titles sureBtnColor: (UIColor *)color{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = GXColor(0, 0, 0, 0.68);
        UIView *centerV = [[UIView alloc] init];
        self.centerV = centerV;
        if (title.length > 0) {
//            h += WidthLandScale_IOS6(40);
            h += 40;
            UILabel *label = [[UILabel alloc] init];
            label.font = GXFONT_PingFangSC_Medium(16);
            label.textAlignment = NSTextAlignmentCenter;
            label.text = title;
            UIView *topV = [[UIView alloc] init];
            topV.backgroundColor = TipTopBGColor;
            [topV addSubview:label];
            
            [self.centerV addSubview:topV];
            [self.centerV addSubview:topV];
            [topV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.left.equalTo(@0);
//                make.height.equalTo(@(WidthLandScale_IOS6(40)));
                make.height.equalTo(@(40));
            }];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(@0);
            }];
            if (desView) {
                h += desView.frame.size.height;
                [self.centerV addSubview:desView];
                [desView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.equalTo(@0);
                    make.height.equalTo(@(desView.frame.size.height));
                    make.top.equalTo(topV.mas_bottom);
                }];
            }
        }
        [self addBtns:titles sureBtnColor:color];
    }
    return self;
}

- (void)addBtns:(NSArray *)titles sureBtnColor:(UIColor *)color{
    CGFloat btnW = TipAlertWidth / titles.count;
    for (int i = 0; i < titles.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = TipTopBGColor;
        btn.titleLabel.font = GXFONT_PingFangSC_Medium(16);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:GXRGBColor(63, 130, 244) forState:UIControlStateNormal];
        [self.centerV addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.centerV).offset(i * btnW);
            make.bottom.equalTo(@0);
//            make.height.equalTo(@(WidthLandScale_IOS6(45)));
            make.height.equalTo(@(45));
            make.width.equalTo(@(btnW));
        }];
        btn.tag = i;
        if ((i == titles.count - 1) && color) {
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.backgroundColor = color;
        }
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
//    h += WidthLandScale_IOS6(45);
    h += 45;
    CGFloat x = (GXScreenWidth - TipAlertWidth) * 0.5;
    CGFloat y = (GXScreenHeight - h) * 0.5;
    self.centerV.frame = CGRectMake(x, y, TipAlertWidth, h);
    self.centerV.layer.cornerRadius = 5;
    self.centerV.layer.masksToBounds = true;
    [self addSubview:self.centerV];
}

- (void)btnClick: (UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(btnClick:)]) {
        [self.delegate btnClick:self];
    }
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGPoint newP = [self convertPoint:point toView:self.centerV];
    if ( [self.centerV pointInside:newP withEvent:event]) {
        return self.centerV;
    }else{
        [self removeFromSuperview];
        return [super hitTest:point withEvent:event];
    }
}

@end
