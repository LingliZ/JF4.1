//
//  GXQuestionCell.h
//  GXAppNew
//
//  Created by zhudong on 2016/11/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXQuestion.h"
#import <YYText/YYLabel.h>

@interface GXQuestionCell : UITableViewCell
@property (nonatomic, strong) YYLabel *nameLable;
@property (nonatomic,strong) GXQuestion *questionModel;
@end
