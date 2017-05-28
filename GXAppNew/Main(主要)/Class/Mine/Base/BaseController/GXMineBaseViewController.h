//
//  GXMineBaseViewController.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/16.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXBaseViewController.h"
#import "ChatViewController.h"
@interface GXMineBaseViewController : GXBaseViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property(nonatomic,strong)UITextField*currentTF;
@property(nonatomic,strong)NSString*recieveSiteUrl;
@property(nonatomic)BOOL isForAddAccount;//用于是否添加在线客服
@property(nonatomic,strong)NSString*type;
-(void)editClick;
-(void)createUI;
@end
