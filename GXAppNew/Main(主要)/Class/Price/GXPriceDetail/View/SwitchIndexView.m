//
//  SwitchIndexView.m
//  GXAppNew
//
//  Created by futang yang on 2017/1/10.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "SwitchIndexView.h"

@interface SwitchIndexView ()


@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIScrollView *scrollView;

@end


@implementation SwitchIndexView {
    
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height *0.25)];
        [self addSubview:_topView];
        _topView.backgroundColor = [UIColor clearColor];
        [_topView setBorderWithView:_topView top:NO left:NO bottom:YES right:NO borderColor:GXRGBColor(45, 45, 52) borderWidth:0.5];
        
        
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.height * 0.25, self.width, self.height * 0.75)];
        _scrollView.clipsToBounds = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        _selectedIndex = 0;
        _selectTopIndex = 0;
        
    }
    return self;
}

- (UIFont *)textFont{
    return _textFont?:[UIFont systemFontOfSize:16];
}

- (void)updateTopChannels:(NSArray*)array {
    for (NSInteger i = 0; i < array.count; i++) {
        
        NSString *string = [array objectAtIndex:i];
        CGFloat buttonHeight = _topView.height/array.count;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, i * buttonHeight, _topView.width, _topView.height/array.count)];
        btn.tag = 100 + i;
        [btn.titleLabel setFont:GXFONT_PingFangSC_Regular(11)];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        if (self.titleNormalColor) {
            [btn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        if (self.titleSelectColor) {
            [btn setTitleColor:self.titleSelectColor forState:UIControlStateSelected];
        } else {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        }
        
        [btn setTitle:string forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickSegmentTopButton:) forControlEvents:UIControlEventTouchUpInside];
        [_topView addSubview:btn];
        
    }

    
}
- (void)updateBottomChannels:(NSArray*)array {
    NSInteger totalH = 0;
    
    for (NSInteger i = 0; i < array.count; i++) {
        
        NSString *string = [array objectAtIndex:i];
        CGFloat buttonHeight = self.scrollView.height/array.count;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, i * buttonHeight, self.scrollView.width, self.scrollView.height/array.count)];
        btn.tag = 100 + i;
        [btn.titleLabel setFont:GXFONT_PingFangSC_Regular(11)];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        if (self.titleNormalColor) {
            [btn setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        } else {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        
        if (self.titleSelectColor) {
            [btn setTitleColor:self.titleSelectColor forState:UIControlStateSelected];
        } else {
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        }
        
        [btn setTitle:string forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickSegmentButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        
        totalH += buttonHeight;
        if (i == 0) {
            [btn setSelected:YES];
            _selectedIndex = 0;
        }
    }
    
    _scrollView.contentSize = CGSizeMake(0, totalH + 10);
}

- (void)clickSegmentTopButton:(UIButton *)selectedButton {
    
    UIButton *oldSelecButton = (UIButton *)[_topView viewWithTag:(100 + _selectTopIndex)];
    oldSelecButton.selected = NO;
    selectedButton.selected = YES;
    
    _selectTopIndex = selectedButton.tag - 100;
    
    if ([self.delegate respondsToSelector:@selector(SwitchIndexView:didSelectTopIndex:)]) {
        [self.delegate SwitchIndexView:self didSelectTopIndex:_selectTopIndex];
    }
}

- (void)didChengeToTopIndex:(NSInteger)index{
    UIButton *selectedButton = [_topView viewWithTag:(100 + index)];
    [self clickSegmentTopButton:selectedButton];
}


- (void)clickSegmentButton:(UIButton *)selectedButton{
    
    UIButton *oldSelecButton = (UIButton *)[_scrollView viewWithTag:(100 + _selectedIndex)];
    oldSelecButton.selected = NO;
    selectedButton.selected = YES;
    
    _selectedIndex = selectedButton.tag - 100;
    
    if ([self.delegate respondsToSelector:@selector(SwitchIndexView:didSelectIndex:)]) {
        [self.delegate SwitchIndexView:self didSelectIndex:_selectedIndex];
    }
}

- (void)didChengeToIndex:(NSInteger)index{
    UIButton *selectedButton = [_scrollView viewWithTag:(100 + index)];
    [self clickSegmentButton:selectedButton];
}


@end
