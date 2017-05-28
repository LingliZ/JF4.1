//
//  GXMine_HeadView_noLogin.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/19.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseView.h"

@protocol GXMine_HeadView_noLoginDelegate <NSObject>

-(void)toLogin;

@end
typedef void(^myBlock)();
@interface GXMine_HeadView_noLogin : GXMineBaseView

@property (weak, nonatomic) IBOutlet UIButton *btn_login;
@property(nonatomic,weak)id<GXMine_HeadView_noLoginDelegate>delegate;
@property(nonatomic,copy)myBlock toLogin;
@end
