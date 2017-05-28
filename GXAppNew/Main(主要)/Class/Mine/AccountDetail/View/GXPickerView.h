//
//  GXPickerView.h
//  GXAppNew
//
//  Created by shenqilong on 17/2/11.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXPickerView;
@protocol GXPickerViewDelegate <NSObject>

@optional
-(void)GXPickerViewDonBtnHaveClick:(GXPickerView *)pickView resultIndex:(int)sIndex resultString:(NSString *)resultString;

@end
@interface GXPickerView : UIView

-(instancetype)initPickviewWithArray:(NSArray *)array;

@property(nonatomic,assign)id<GXPickerViewDelegate>delegate;


-(void)show;
-(void)remove;
@end
