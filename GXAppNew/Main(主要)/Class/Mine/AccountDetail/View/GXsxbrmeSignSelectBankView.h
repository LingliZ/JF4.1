//
//  GXsxbrmeSignSelectBankView.h
//  GXAppNew
//
//  Created by shenqilong on 17/2/10.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXMineBankModel.h"
@protocol GXsxbrmeSignSelectBankViewDelegate <NSObject>

-(void)GXsxbrmeSignSelectBankViewDelegate_clickModel:(GXMineBankModel *)model;

@end

@interface GXsxbrmeSignSelectBankView : UIView
-(void)setBankData:(NSArray *)ar;
@property(nonatomic,weak)UITableView *listab;

@property(nonatomic,assign)id<GXsxbrmeSignSelectBankViewDelegate>delegate;
@end
