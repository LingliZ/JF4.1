//
//  MySelectQuestionsView.m
//  MyExamProject
//
//  Created by WangLinfang on 16/7/6.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import "MySelectQuestionsView.h"

@implementation MySelectQuestionsView
{
    NSMutableArray*arr_scores;//选项分值
    NSMutableArray*arr_selectedScores;//选中选项的分值
    NSMutableArray*arr_selectedNums;//选中选项的编号
}
-(void)awakeFromNib
{
    self.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100);
}
-(void)addItemViewWithQuestionTitle:(NSString*)questionTitle andQuestionItems:(NSArray*)questionItems
{
    self.label_content.text=questionTitle;
    CGFloat h=[self.label_content getSpaceLabelHeight:self.label_content.text withWidh:[UIScreen mainScreen].bounds.size.width-30]+1;
    NSLayoutConstraint*labelHigh=[NSLayoutConstraint constraintWithItem:self.label_content attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:h];
    [self addConstraint:labelHigh];
    
    
    float y=18+h+20;//子视图的纵坐标（选择项）
    for(int i=0;i<questionItems.count;i++)
    {
        
        MySelectQuestionSelectItem*item=[[[NSBundle mainBundle]loadNibNamed:@"MySelectQuestionSelectItem" owner:self options:nil]lastObject];
        item.tag=i;
        [item setHighWithContent:[questionItems objectAtIndex:i]];//调整选项高度
        item.delegate=self;
        item.type=self.type;
        item.frame=CGRectMake(0, y,[UIScreen mainScreen].bounds.size.width, item.viewHight);
        [self addSubview:item];
        y=y+item.viewHight;
        
    }
    self.viewHight=y+5;
    
    arr_scores=[[NSMutableArray alloc]init];
    arr_selectedScores=[[NSMutableArray alloc]init];
    for(NSDictionary*dic in self.arr_itemsAndScores)
    {
        [arr_scores addObject:dic[@"score"]];
    }
}
#pragma mark--MySelectQuestionSelectItemDelegate
-(void)selectWithTag:(NSInteger)tag
{
    if(self.type.intValue==1)
    {
        //单选
        [self updateStatusOfSelectBtnWithTag:tag];
    }
    if(self.type.intValue==2)
    {
        //多选
        [self setHighestScoresArrWithTag:tag];
        NSInteger highestScore=[self getHightestScoreWithTagArray:arr_selectedScores];
        tag=[self getIndexForHeighestScoreWithScore:highestScore];
    }
    if([[GXUserdefult objectForKey:AddCountFor]isEqualToString:ForShanxi])
    {
        [self setHighestScoresArrWithTag:tag];
        NSString*combination=[self getCombinationWithNumsArr:arr_selectedNums];
        NSString* highestScore=[NSString stringWithFormat:@"%ld",[self getHightestScoreWithTagArray:arr_selectedScores]];
        [self.delegate selectShanxiQuestionsWithTag:self.tag andHighestScore:highestScore andItemsNums:combination];
    }
    else
    {
        [self.delegate selectQuestionsWithTag:self.tag forItemsWithTag:tag];
    }
}

-(void)updateStatusOfSelectBtnWithTag:(NSInteger)tag
{
    for(MySelectQuestionSelectItem*view in self.subviews)
    {
        if([view isKindOfClass:[MySelectQuestionSelectItem class]])
        {
            view.btn_select.selected=NO;
            if(view.tag==tag)
            {
                view.btn_select.selected=YES;
            }
        }
    }
    
}
#pragma mark--设置选中选项对应的分数、编号组成的数组(多选)
-(void)setHighestScoresArrWithTag:(NSInteger)tag
{
    arr_selectedScores=[[NSMutableArray alloc]init];
    arr_selectedNums=[[NSMutableArray alloc]init];
    for(MySelectQuestionSelectItem*view in self.subviews)
    {
        if([view isKindOfClass:[MySelectQuestionSelectItem class]])
        {
            NSDictionary*dic=self.arr_itemsAndScores[view.tag];
            if(view.btn_select.selected)
            {
                [arr_selectedScores addObject:dic[@"score"]];
                [arr_selectedNums addObject:dic[@"num"]];
            }
        }
    }
}
#pragma mark--获取最高的分数(多选时)
-(NSInteger)getHightestScoreWithTagArray:(NSArray*)tagsArr
{
    NSInteger maxTag=-100000;
    for(int i=0;i<tagsArr.count;i++)
    {
        if([tagsArr[i] integerValue]>=maxTag)
        {
            maxTag=[tagsArr[i] integerValue];
        }
    }
    return maxTag;
}
#pragma mark--获取最高分数的角标(多选时)
-(NSInteger)getIndexForHeighestScoreWithScore:(NSInteger)score
{
    for(NSInteger i =0;i<arr_selectedScores.count;i++)
    {
        if([arr_selectedScores[i] integerValue]==score)
        {
            return i;
        }
    }
    return 0;
}
#pragma mark--获取所选的选项对应的编号组成的字符串
-(NSString*)getCombinationWithNumsArr:(NSMutableArray*)arr
{
    NSMutableString*strCombination=[[NSMutableString alloc]init];
    for(NSString *str in arr)
    {
        [strCombination appendString:[NSString stringWithFormat:@"%@,",str]];
    }
    if(strCombination.length)
    {
        strCombination=(NSMutableString*)[strCombination substringWithRange:NSMakeRange(0, strCombination.length-1)];
    }
    return strCombination;
}
-(void)setAllItemsForUnselected
{
    for(MySelectQuestionSelectItem*view in self.subviews)
    {
        if([view isKindOfClass:[MySelectQuestionSelectItem class]])
        {
            view.btn_select.selected=NO;
        }
    }
}
@end
