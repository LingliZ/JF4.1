//
//  MySelectQuestionSelectItem.m
//  MyExamProject
//
//  Created by WangLinfang on 16/7/6.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "MySelectQuestionSelectItem.h"

@implementation MySelectQuestionSelectItem

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [self.btn_select setBackgroundImage:[UIImage imageNamed:@"mine_questionItem_normal"] forState:UIControlStateNormal];
    [self.btn_select setBackgroundImage:[UIImage imageNamed:@"mine_questionItem_selected"] forState:UIControlStateSelected];
   
}

-(void)setHighWithContent:(NSString *)content
{
    self.label_questionContent.text=content;
    CGFloat h=[self.label_questionContent getSpaceLabelHeight:self.label_questionContent.text withWidh:[UIScreen mainScreen].bounds.size.width-60];
    self.labelHeight=[NSLayoutConstraint constraintWithItem:self.label_questionContent attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:h];
    [self addConstraint:self.labelHeight];
    self.viewHight=h+20;
}
- (IBAction)btnClick:(UIButton *)sender {
    self.btn_select.selected=!self.btn_select.selected;
    [self.delegate selectWithTag:self.tag];
}

@end
