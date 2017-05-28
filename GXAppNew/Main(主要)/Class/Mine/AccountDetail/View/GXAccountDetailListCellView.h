//
//  GXAccountDetailListCellView.h
//  GXAppNew
//
//  Created by shenqilong on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXAccountDetailModel;
@interface GXAccountDetailListCellView : UIView

-(instancetype)initModel:(GXAccountDetailModel *)model;

-(void)updateStatus:(GXAccountDetailModel *)newAccountModel;
@property(nonatomic,weak)UIViewController *vc;
@end
