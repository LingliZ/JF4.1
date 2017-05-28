//
//  GXAccountDetailViewController.h
//  GXAppNew
//
//  Created by shenqilong on 16/12/22.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, accountEXtype) {
    qiluce,
    tjpme,
    sxbrme
};

@interface GXAccountDetailViewController : GXBaseViewController
@property(nonatomic,assign)accountEXtype exType;
@end
