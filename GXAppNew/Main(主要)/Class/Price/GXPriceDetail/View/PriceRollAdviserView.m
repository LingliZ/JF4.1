//
//  adverView.m
//  WinTreasure
//
//  Created by yangfutang on 16/12/6.
//  Copyright © 2016年 i-mybest. All rights reserved.
//

#import "PriceRollAdviserView.h"
#import <YYText/YYText.h>



#define ViewWidth  self.bounds.size.width
#define ViewHeight  self.bounds.size.height
#define kNoticeImageViewWidth 20.0

@interface PriceRollAdviserView ()

@property (nonatomic ,strong) UIImageView *headImageView;
// 轮流显示的label
@property (nonatomic, strong) YYLabel *oneLabel;
@property (nonatomic, strong) YYLabel *twoLabel;
@property (nonatomic, strong) UIButton *showAdvBtn;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation PriceRollAdviserView {
    NSUInteger index;
    CGFloat margin;
    BOOL isBegin;
}

// 自己写的初始化方法
- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titles {
    self = [super initWithFrame:frame];
    if (self) {
        
        margin = 0;
        self.clipsToBounds = YES;
        self.adTitles = titles;
        self.headImg = nil;
        self.labelFont = [UIFont systemFontOfSize:12];
        self.color = [UIColor grayColor];
        self.time = 2.f;
        self.textAlignment = NSTextAlignmentLeft;
        self.isHaveTouchEvent = YES;
        self.edgeInsets = UIEdgeInsetsZero;
        index = 0;
        
        if (!_headImageView) {
            _headImageView = [UIImageView new];
        }
        
        if (!_oneLabel) {
            _oneLabel = [YYLabel new];
            
            if (self.adTitles.count > 0) {
                _oneLabel.text = [NSString stringWithFormat:@"%@",self.adTitles[index]];
            }
            
            _oneLabel.font = self.labelFont;
            _oneLabel.textAlignment = self.textAlignment;
            _oneLabel.textColor = self.color;
            [self addSubview:_oneLabel];
        }
        
        if (!_twoLabel) {
            _twoLabel = [YYLabel new];
            _twoLabel.font = self.labelFont;
            _twoLabel.textAlignment = self.textAlignment;
            _twoLabel.textColor = self.color;
            [self addSubview:_twoLabel];
        }
        
        if (!_showAdvBtn) {
            _showAdvBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self addSubview:_showAdvBtn];
            [_showAdvBtn setTitle:@"点击" forState:UIControlStateNormal];
            [_showAdvBtn setTitleColor:GXWhiteColor forState:UIControlStateNormal];
            _showAdvBtn.titleLabel.font = GXFONT_PingFangSC_Regular(11);
            
            _showAdvBtn.backgroundColor = [UIColor redColor];
            
            [_showAdvBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(WidthScale_IOS6(-20));
                make.centerY.mas_equalTo(self.mas_centerY);
                make.width.mas_equalTo(WidthScale_IOS6(50));
                make.height.mas_equalTo(HeightScale_IOS6(self.bounds.size.height));
            }];
            
            [_showAdvBtn addTarget:self action:@selector(showAdvBtnClick) forControlEvents:UIControlEventTouchUpInside];

        }
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}


- (void)config {

    
    if (!_headImageView) {
        _headImageView = [UIImageView new];
        _headImageView.userInteractionEnabled = YES;
    }
    
    if (!_oneLabel) {
        _oneLabel = [YYLabel new];
        
        if (self.adTitles.count > 0) {
            _oneLabel.text = [NSString stringWithFormat:@"%@",self.adTitles[index]];
        }
        
        _oneLabel.font = self.labelFont;
        _oneLabel.textAlignment = self.textAlignment;
        _oneLabel.textColor = self.color;
        [self addSubview:_oneLabel];
    }
    
    if (!_twoLabel) {
        _twoLabel = [YYLabel new];
        _twoLabel.font = self.labelFont;
        _twoLabel.textAlignment = self.textAlignment;
        _twoLabel.textColor = self.color;
        [self addSubview:_twoLabel];
    }
    
    UIButton *showAdvBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:showAdvBtn];
    [showAdvBtn setTitle:@"点击" forState:UIControlStateNormal];
    [showAdvBtn setTitleColor:GXWhiteColor forState:UIControlStateNormal];
    showAdvBtn.titleLabel.font = GXFONT_PingFangSC_Regular(11);
    
    showAdvBtn.backgroundColor = [UIColor redColor];
    
    [showAdvBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(WidthScale_IOS6(-20));
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(WidthScale_IOS6(50));
        make.height.mas_equalTo(HeightScale_IOS6(self.bounds.size.height));
    }];
    
    [showAdvBtn addTarget:self action:@selector(showAdvBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
//    UIButton *showAdvBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self addSubview:showAdvBtn];
//    [showAdvBtn setTitle:@"点击" forState:UIControlStateNormal];
//    [showAdvBtn setTitleColor:GXWhiteColor forState:UIControlStateNormal];
//    showAdvBtn.titleLabel.font = GXFONTPingFangSC_Regular(11);
//    
//    showAdvBtn.backgroundColor = [UIColor redColor];
//    
//    [showAdvBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(WidthScale_IOS6(-20));
//        make.centerY.mas_equalTo(self.mas_centerY);
//        make.width.mas_equalTo(WidthScale_IOS6(50));
//        make.height.mas_equalTo(HeightScale_IOS6(self.bounds.size.height));
//    }];
//    
//    [showAdvBtn addTarget:self action:@selector(showAdvBtnClick) forControlEvents:UIControlEventTouchUpInside];
}





- (void)setAdviserTitles:(NSArray *)titles {

    margin = 0;
    self.clipsToBounds = YES;
    self.adTitles = titles;
    self.headImg = nil;
    self.labelFont = [UIFont systemFontOfSize:12];
    self.color = [UIColor grayColor];
    self.time = 2.f;
    self.textAlignment = NSTextAlignmentLeft;
    self.isHaveTouchEvent = YES;
    self.edgeInsets = UIEdgeInsetsZero;
    index = 0;
 
}


- (void)showAdvBtnClick {
    
    
    
    if (self.showAdClick) {
        self.showAdClick();
    }
}


- (NSTimer *)timer {
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:self.time target:self selector:@selector(timeRepeat) userInfo:self repeats:YES];
    }
    return _timer;
}

- (void)beginScroll {
    if (self.timer.isValid) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)closeScroll {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets{
    _edgeInsets = edgeInsets;
}


- (void)timeRepeat {
    if (self.adTitles.count <= 1) {
        [self.timer invalidate];
        self.timer = nil;
        return;
    }
    
    __block YYLabel *currentLabel;
    __block YYLabel *hidenLabel;
    __weak typeof(self) weakself = self;
    
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[YYLabel class]]) {
            YYLabel *label = obj;
            NSString *string = weakself.adTitles[index];
            if ([label.text isEqualToString:string]) {
                currentLabel = label;
            } else {
                hidenLabel = label;
            }
        }
    }];
    
    if (index != self.adTitles.count - 1) {
        index++;
    } else {
        index = 0;
    }
    
    hidenLabel.text = [NSString stringWithFormat:@"%@", self.adTitles[index]];
    
    [UIView animateWithDuration:0.5 animations:^{
        hidenLabel.frame = CGRectMake(margin, 0, ViewWidth, ViewHeight);
        currentLabel.frame = CGRectMake(margin, -ViewHeight, ViewWidth, ViewHeight);
    } completion:^(BOOL finished) {
        currentLabel.frame = CGRectMake(margin, ViewHeight, ViewWidth, ViewHeight);
    }];
    
    
}

- (void)setHeadImg:(UIImage *)headImg {
    _headImg = headImg;
    self.headImageView.image = _headImg;
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.oneLabel.textColor = _color;
    self.twoLabel.textColor = _color;
}


- (void)setLabelFont:(UIFont *)labelFont{
    _labelFont = labelFont;
    self.oneLabel.font = _labelFont;
    self.twoLabel.font = _labelFont;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment{
    _textAlignment = textAlignment;
    self.oneLabel.textAlignment = _textAlignment;
    self.twoLabel.textAlignment = _textAlignment;
}


- (void)setIsHaveTouchEvent:(BOOL)isHaveTouchEvent {
    if (isHaveTouchEvent) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickEvent:)];
        [self addGestureRecognizer:tapGes];
    } else {
        self.userInteractionEnabled = NO;
    }
}



- (void)clickEvent:(UITapGestureRecognizer *)tapGestureRecognizer {
    [self.adTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (index % 2 == 0 && [self.oneLabel.text isEqualToString:obj]) {
            if (self.clickAdBlock) {
                self.clickAdBlock(index);
            }
        } else if (index % 2 != 0 && [self.twoLabel.text isEqualToString:obj]) {
            if (self.clickAdBlock) {
                self.clickAdBlock(index);
            }
        }
        
    }];
}



- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.headImg) {
        [self addSubview:self.headImageView];
        
        self.headImageView.frame = CGRectMake(self.edgeInsets.left, self.edgeInsets.top, kNoticeImageViewWidth, kNoticeImageViewWidth);
        margin = CGRectGetMaxX(self.headImageView.frame) + 10;
    } else {
        if (self.headImageView) {
            [self.headImageView removeFromSuperview];
            self.headImageView = nil;
        }
        margin = 10;
    }
    
    self.oneLabel.frame = CGRectMake(margin, 0, ViewWidth, ViewHeight);
    self.twoLabel.frame = CGRectMake(margin, ViewHeight, ViewWidth, ViewHeight);
    
    
}






@end
