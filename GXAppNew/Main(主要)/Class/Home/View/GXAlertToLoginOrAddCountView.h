//
//  GXAlertToLoginOrAddCountView.h
//  GXApp
//
//  Created by WangLinfang on 16/12/14.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GXAlertToLoginOrAddCountDelegate <NSObject>

-(void)gotoLoginOrAddCount;

@end
@interface GXAlertToLoginOrAddCountView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property(weak,nonatomic)id<GXAlertToLoginOrAddCountDelegate>delegate;
@end
