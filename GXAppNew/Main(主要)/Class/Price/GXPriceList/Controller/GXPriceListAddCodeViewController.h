//
//  GXPriceListAddCodeViewController.h
//  GXAppNew
//
//  Created by shenqilong on 16/12/15.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol addCodeViewControllerDelegate <NSObject>

-(void)addCodeDone;

@end

@interface GXPriceListAddCodeViewController : GXBaseViewController
@property(nonatomic,assign)id<addCodeViewControllerDelegate>delegate;
@end
