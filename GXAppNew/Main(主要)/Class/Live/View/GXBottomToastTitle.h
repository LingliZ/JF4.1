//
//  GXBottomToastTitle.h
//  GXAppNew
//
//  Created by maliang on 2017/3/29.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GXBottomToastTitleDelegate <NSObject>

- (void)gotoLoginOrOpenAcount;

@end

@interface GXBottomToastTitle : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *openBtn;

@property(nonatomic, weak) id<GXBottomToastTitleDelegate>delegate;

@end
