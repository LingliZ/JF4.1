//
//  GXMineInvestTypesView.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/27.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseView.h"
#import "GXMineInvestTypeModel.h"
@protocol GXMineInvestTypesViewDelegate <NSObject>

-(void)selectInvestTypeWithValue:(BOOL)value andTag:(NSInteger)tag;

@end
@interface GXMineInvestTypesView : GXMineBaseView
-(void)setModelsWithModelsArray:(NSMutableArray*)modelArray;
@property(nonatomic,weak)id<GXMineInvestTypesViewDelegate>deleagte;
@end
