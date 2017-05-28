//
//  SwitchIndexView.h
//  GXAppNew
//
//  Created by futang yang on 2017/1/10.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwitchIndexView;

typedef void (^setBtnClick)(UIButton *btn);

@protocol SwitchIndexViewDelegate <NSObject>

@optional
- (void)SwitchIndexView:(SwitchIndexView *)indexView didSelectIndex:(NSInteger)index;
- (void)SwitchIndexView:(SwitchIndexView *)indexView didSelectTopIndex:(NSInteger)index;
@end


@interface SwitchIndexView : UIControl


@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic, assign) NSInteger selectTopIndex;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *titleSelectColor;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, weak) id <SwitchIndexViewDelegate>delegate;

- (void)updateTopChannels:(NSArray*)array;
- (void)updateBottomChannels:(NSArray*)array;
- (void)didChengeToIndex:(NSInteger)index;
- (void)didChengeToTopIndex:(NSInteger)index;

@end
