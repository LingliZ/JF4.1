//
//  GXMessageCell.h
//  GXAppNew
//
//  Created by 王振 on 2016/12/27.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXMessagesModel.h"
#import "RCLabel.h"

@interface GXMessageCell : UITableViewCell
@property (nonatomic,strong) GXMessagesModel *messageModel;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier messageModel:(GXMessagesModel *)messageModel;
@end
