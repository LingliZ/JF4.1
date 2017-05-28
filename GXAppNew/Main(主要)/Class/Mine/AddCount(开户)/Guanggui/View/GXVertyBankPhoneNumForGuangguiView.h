//
//  GXVertyBankPhoneNumForGuangguiView.h
//  GXAppNew
//
//  Created by WangLinfang on 17/3/8.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseView.h"

@protocol GXVertyBankPhoneNumForGuangguiViewDelegate <NSObject>
-(void)vertyBankPhoneNumConfirm;
@end
@interface GXVertyBankPhoneNumForGuangguiView : GXMineBaseView
@property (weak, nonatomic) IBOutlet UIView *view_content;
@property (weak, nonatomic) IBOutlet UILabel *label_content;
@property (weak, nonatomic) IBOutlet UITextField *TF_vertyNum;
@property (weak, nonatomic) IBOutlet UIButton *btn_timeMark;//倒计时
@property (weak, nonatomic) IBOutlet UIButton *btn_sendAgain;
@property (weak, nonatomic) IBOutlet UIButton *btn_confirm;//确定

@property(nonatomic,weak)id<GXVertyBankPhoneNumForGuangguiViewDelegate>delegate;

@end
