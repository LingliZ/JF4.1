//
//  GXsxbrmeSignHeadView.h
//  GXAppNew
//
//  Created by shenqilong on 17/2/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXAccountDetailModel;
@interface GXsxbrmeSignHeadView : UIView
+ (id)parallaxHeaderViewWithCGSize:(CGSize)headerSize accountModel:(GXAccountDetailModel *)model;
@property (nonatomic,weak) GXAccountDetailModel *accountModel;
- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset;

@end
