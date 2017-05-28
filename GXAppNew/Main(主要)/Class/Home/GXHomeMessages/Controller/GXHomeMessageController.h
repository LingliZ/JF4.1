//
//  GXHomeMessageController.h
//  GXAppNew
//
//  Created by 王振 on 2016/11/29.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXHomeMessageController : UIViewController
@property (nonatomic,strong)NSString *type;

- (void)createLabel:(NSString *)yourTitleStr;
- (void)createTableViewFromVC:(NSString *)yourTag;

@end
