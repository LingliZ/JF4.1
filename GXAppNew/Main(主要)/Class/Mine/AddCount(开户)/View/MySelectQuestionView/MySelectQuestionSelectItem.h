//
//  MySelectQuestionSelectItem.h
//  MyExamProject
//
//  Created by WangLinfang on 16/7/6.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+Extension.h"
@protocol MySelectQuestionSelectItemDelegate <NSObject>

-(void)selectWithTag:(NSInteger)tag;

@end
@interface MySelectQuestionSelectItem : UIView

@property (weak, nonatomic) IBOutlet UIImageView *img_selectStatus;
@property (weak, nonatomic) IBOutlet UILabel *label_questionContent;
@property (weak, nonatomic) IBOutlet UIButton *btn_select;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;

@property(nonatomic,strong)NSString*type;//题目类型（单选/多选）
@property(nonatomic)CGFloat viewHight;
@property(nonatomic,weak)id<MySelectQuestionSelectItemDelegate>delegate;

-(void)setHighWithContent:(NSString*)content;
@end
