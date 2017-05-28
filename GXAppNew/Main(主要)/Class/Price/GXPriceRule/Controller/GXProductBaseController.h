//
//  GXProductBaseController.h
//  GXApp
//
//  Created by GXJF on 16/7/15.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXProductBaseController : UIViewController
@property (nonatomic,strong)NSMutableArray *postUrlArray;
@property (nonatomic,assign)NSInteger type;
@property (weak, nonatomic) IBOutlet UIWebView *GXProductWebView;

@end
