//
//  GXPriceListScrollView.h
//  GXAppNew
//
//  Created by shenqilong on 16/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GXPriceListScrollViewDelegate <NSObject>

-(void)listScrollvTouchBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
-(void)listScrollvTouchCancel:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;
-(void)listScrollvTouchEnd:(id)view touch:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end
@interface GXPriceListScrollView : UIScrollView
@property (nonatomic,assign)id<GXPriceListScrollViewDelegate>delegateCustom;
@end
