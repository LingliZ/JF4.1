//
//  GXConsultantReplyCell.h
//  GXApp
//
//  Created by zhudong on 16/7/28.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXConsultantReplyModel.h"
#import "GXBaseCellWithyyLabel.h"
#define PictureWidth ((GXScreenWidth - 4 * kMargin) - 2 * kMargin) / 3.0

@interface GXConsultantReplyCell : GXBaseCellWithyyLabel
@property (nonatomic,strong) GXConsultantReplyModel *consultantReplyModel;
@end
