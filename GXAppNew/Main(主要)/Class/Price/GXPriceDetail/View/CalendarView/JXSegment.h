//
//  JXSegment.h
//  JXChannelSegment
//
//  Created by JackXu on 16/9/16.
//  Copyright © 2016年 BFMobile. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JXSegment;


typedef void (^setBtnClick)(UIButton *btn);

@protocol JXSegmentDelegate <NSObject>

@optional
- (void)JXSegment:(JXSegment*)segment didSelectIndex:(NSInteger)index;
@end


@interface JXSegment : UIControl

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIFont *textFont;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,weak) id<JXSegmentDelegate> delegate;
@property (nonatomic, strong) UIColor *divideSelectColor;
@property (nonatomic, strong) UIColor *titleSelectColor;
@property (nonatomic, strong) UIColor *titleNormalColor;
@property (nonatomic, copy) setBtnClick btnClikcBlock;
@property (nonatomic, assign) BOOL isVertical;



- (void)updateChannels:(NSArray*)array isVertical:(BOOL)isVertical;
- (void)didChengeToIndex:(NSInteger)index;

@end
