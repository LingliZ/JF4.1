//
//  PriceRollAdviserView.h
//  GXAppNew
//
//  Created by futang yang on 2016/12/7.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^showClick)();

@interface PriceRollAdviserView : UIView

@property (nonatomic, strong) NSArray *adTitles;
@property (nonatomic, strong) UIImage *headImg;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;
@property (nonatomic, strong) UIFont *labelFont;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) NSTimeInterval time;
@property (nonatomic, assign) BOOL isHaveTouchEvent;

@property (nonatomic, copy) void (^clickAdBlock)(NSInteger index);
@property (nonatomic, assign) NSTextAlignment textAlignment;

@property (nonatomic, copy) showClick showAdClick;

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray *)titles;

- (void)setAdviserTitles:(NSArray *)titles;

- (void)beginScroll;
- (void)closeScroll;


@end
