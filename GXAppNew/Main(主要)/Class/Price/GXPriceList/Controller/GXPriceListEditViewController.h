//
//  GXPriceListEditViewController.h
//  GXAppNew
//
//  Created by shenqilong on 16/12/18.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol GXPriceListEditViewControllerDelegate <NSObject>

-(void)editCodeDone;

@end
@interface GXPriceListEditViewController : GXBaseViewController
@property(nonatomic,assign)id<GXPriceListEditViewControllerDelegate>delegate;

@end
