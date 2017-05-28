//
//  GXSuggestionCell.h
//  GXAppNew
//
//  Created by zhudong on 2016/12/1.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXSuggestionModel.h"

@interface GXSuggestionCell : UITableViewCell
//@property (nonatomic,copy) void(^arrowBtnDelegate)(GXSuggestionCell *cell);
@property (nonatomic,strong) GXSuggestionModel *suggestionModel;
@property (nonatomic, strong) UIButton *iconBtn;
@end
