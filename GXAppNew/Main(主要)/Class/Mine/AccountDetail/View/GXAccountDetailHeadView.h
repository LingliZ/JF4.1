//
//  GXAccountDetailHeadView.h
//  GXAppNew
//
//  Created by shenqilong on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GXAccountDetailModel;
@protocol GXAccountDetailHeadViewDelegate <NSObject>

-(void)clickBottomButton:(int)index;

@end

@interface GXAccountDetailHeadView : UIView

@property (nonatomic,weak) GXAccountDetailModel *accountModel;

+ (id)parallaxHeaderViewWithCGSize:(CGSize)headerSize accountModel:(GXAccountDetailModel *)model;

- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset;

@property(nonatomic,assign)id<GXAccountDetailHeadViewDelegate>delegate;

@end
