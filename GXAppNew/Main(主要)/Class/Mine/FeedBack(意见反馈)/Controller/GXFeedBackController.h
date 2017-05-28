//
//  GXFeedBackController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/21.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"

@interface GXFeedBackController : GXMineBaseViewController<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *TV_content;//提交内容
@property (weak, nonatomic) IBOutlet UILabel *label_numbersOfContent;//字数统计
@property (weak, nonatomic) IBOutlet UILabel *label_placeholder;
@property (weak, nonatomic) IBOutlet UIButton *btn_commite;//提交按钮
@end
