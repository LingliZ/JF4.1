//
//  GXAccountDetailTradeView.h
//  GXAppNew
//
//  Created by shenqilong on 16/12/26.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GXAccountDetailTradeViewDelegate <NSObject>

-(void)GXAccountDetailTradeView_goTradeBtnClick;

@end

@class GXAccountDetailModel;
@interface GXAccountDetailTradeView : UIView

@property(nonatomic,weak)UITableView *tableview;

-(void)setModelUI:(GXAccountDetailModel *)aModel;

-(void) setTimerInvali;

@property(nonatomic,assign)id<GXAccountDetailTradeViewDelegate>delegate;
@end
