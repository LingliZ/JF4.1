//
//  JXSegment.m
//  JXChannelSegment
//
//  Created by JackXu on 16/9/16.
//  Copyright © 2016年 BFMobile. All rights reserved.
//

#import "JXSegment.h"

#define setBtnWidth 75

@interface JXSegment(){
    NSArray *widthArray;
    NSInteger _allButtonW;
    UIView *_divideView;
    UIView *_divideLineView;
    UIButton *_selectButton;
    NSMutableArray *_allTitlesW;
    UIButton *_setBtn;
}

@end

@implementation JXSegment

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _scrollView.clipsToBounds = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];

        _divideView  = [[UIView alloc] init];
        _divideView.backgroundColor = [UIColor redColor];
        [_scrollView addSubview:_divideView];
    }
    
    return self;
}

-(UIFont *)textFont{
    return _textFont?:[UIFont systemFontOfSize:16];
}

- (void)updateChannels:(NSArray*)array isVertical:(BOOL)isVertical {
    
    NSMutableArray *widthMutableArray = [NSMutableArray array];
    NSMutableArray *titlesWidthArray = [NSMutableArray array];
    
    NSInteger totalW = 0;
    
    for (int i = 0; i < array.count; i++) {
        
        NSString *string = [array objectAtIndex:i];
        CGFloat titleW = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.textFont} context:nil].size.width;
        CGFloat buttonW;
        if (isVertical) {
            buttonW = self.bounds.size.width/6.5;
        } else {
            buttonW = self.bounds.size.width/array.count;
        }
        
        [widthMutableArray addObject:@(buttonW)];
        [titlesWidthArray addObject:@(titleW)];
        
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(totalW, 0, buttonW, self.bounds.size.height)];
        button.tag = 1000 + i;
        [button.titleLabel setFont:self.textFont];
        
        if (self.titleNormalColor) {
            [button setTitleColor:self.titleNormalColor forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    
        if (self.titleSelectColor) {
            [button setTitleColor:self.titleSelectColor forState:UIControlStateSelected];
        } else {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        }
        
        [button setTitle:string forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickSegmentButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.scrollView addSubview:button];
        
        totalW += buttonW;
        
        if (i == 0) {
            [button setSelected:YES];
            _divideView.frame = CGRectMake(0, _scrollView.bounds.size.height - 2, buttonW, 2);
            _selectedIndex = 0;
        }
        
    }
    
 
    _setBtn.titleLabel.font = GXFONT_PingFangSC_Regular(12);
    [_setBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_setBtn addTarget:self action:@selector(setbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _allButtonW = totalW;
    _scrollView.contentSize = CGSizeMake(totalW + 10,0);
    widthArray = [widthMutableArray copy];
    _allTitlesW = titlesWidthArray;
}


- (void)setbtnClick:(UIButton *)sender {
    DLog(@"点击了 设置按钮");
    if (self.btnClikcBlock) {
        self.btnClikcBlock(sender);
    }
}

- (void)clickSegmentButton:(UIButton*)selectedButton{
    
    UIButton *oldSelectButton = (UIButton *)[_scrollView viewWithTag:(1000 + _selectedIndex)];
    [oldSelectButton setSelected:NO];
    
    [selectedButton setSelected:YES];
    _selectedIndex = selectedButton.tag - 1000;
    
    
    NSInteger totalW = 0;
    for (int i = 0; i < _selectedIndex; i++) {
        totalW += [[widthArray objectAtIndex:i] integerValue];
    }
    
    //处理边界
    CGFloat selectW = [[widthArray objectAtIndex:_selectedIndex] integerValue];
    CGFloat titleW = [[_allTitlesW objectAtIndex:_selectedIndex] integerValue];
    
    CGFloat offset = totalW + (selectW - self.bounds.size.width) * 0.5;
    offset = MIN(_allButtonW - self.bounds.size.width, MAX(0, offset));

    [_scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    if ([_delegate respondsToSelector:@selector(JXSegment:didSelectIndex:)]) {
        [_delegate JXSegment:self didSelectIndex:_selectedIndex];
    }
    
    
    //滑块
    [UIView animateWithDuration:0.1 animations:^{
        _divideView.frame = CGRectMake(totalW + (selectW - titleW)/2, _divideView.frame.origin.y, titleW, _divideView.frame.size.height);
    }];
    
}

- (void)setDivideSelectColor:(UIColor *)divideSelectColor {
    _divideSelectColor = divideSelectColor;
    _divideView.backgroundColor = divideSelectColor;
}

//
//- (void)setTitleSelectColor:(UIColor *)titleSelectColor {
//    _titleSelectColor = titleSelectColor;
//    
//    for (UIView *item in _scrollView.subviews) {
//        
//        if ([item isKindOfClass:[UIButton class]]) {
//            [(UIButton *)item setTitleColor:self.titleSelectColor forState:UIControlStateSelected];
//        }
//    }
//    
//}

- (void)didChengeToIndex:(NSInteger)index{
    UIButton *selectedButton = [_scrollView viewWithTag:(1000 + index)];
    [self clickSegmentButton:selectedButton];
    
}

@end
