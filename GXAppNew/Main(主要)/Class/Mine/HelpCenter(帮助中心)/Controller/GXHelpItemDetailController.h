//
//  GXHelpItemDetailController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/18.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"

@interface GXHelpItemDetailController : GXMineBaseViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView_content;
@property(nonatomic,strong)NSString*urlStr;
@end
