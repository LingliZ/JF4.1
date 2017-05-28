//
//  GXBaseCellWithYYLabel.h
//  GXApp
//
//  Created by zhudong on 16/8/17.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <YYText/YYText.h>

//#import "YYText.h"
#define GXBaseCellWithYYLabelDidClick @"GXBaseCellWithYYLabelDidClick"

@interface GXBaseCellWithyyLabel : UITableViewCell
@property (nonatomic,strong) YYLabel *contentLabel;

@end
