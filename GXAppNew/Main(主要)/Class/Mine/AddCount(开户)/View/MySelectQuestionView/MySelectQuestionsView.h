//
//  MySelectQuestionsView.h
//  MyExamProject
//
//  Created by WangLinfang on 16/7/6.
//  Copyright © 2016年 WangLinfang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySelectQuestionSelectItem.h"
#import "UILabel+Extension.h"

@protocol MyselectQuestionViewDelegate <NSObject>

-(void)selectQuestionsWithTag:(NSInteger)questionTag forItemsWithTag:(NSInteger)itemTag;
-(void)selectShanxiQuestionsWithTag:(NSInteger)questionTag andHighestScore:(NSString*)highestScore andItemsNums:(NSString*)itemNums;

@end
@interface MySelectQuestionsView : UIView<MySelectQuestionSelectItemDelegate>
@property(nonatomic,strong)NSMutableArray*arr_itemsAndScores;
@property(nonatomic,strong)NSString*type;
@property(nonatomic) int numberOfItems;
@property(nonatomic)int viewHight;
@property (weak, nonatomic) IBOutlet UILabel *label_content;
@property(nonatomic,weak)id<MyselectQuestionViewDelegate>delegate;
-(void)addItemViewWithQuestionTitle:(NSString*)questionTitle andQuestionItems:(NSArray*)questionItems;
-(void)setAllItemsForUnselected;
@end
