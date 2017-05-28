//
//  GXPriceListSelectExView.h
//  GXAppNew
//
//  Created by shenqilong on 16/12/15.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GXPriceListSelectExViewDelegate <NSObject>

-(void)selectBtnCLickIndex:(NSInteger)index;

-(void)EXViewClose:(BOOL)isClose;

@end
@interface GXPriceListSelectExView : UIView

@property (nonatomic,assign)id<GXPriceListSelectExViewDelegate>delegate;

- (instancetype)initWithEXAr:(NSArray *)exAr;
-(void)setSelectExViewShow;

@end
