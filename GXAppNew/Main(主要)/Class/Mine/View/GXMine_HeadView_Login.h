//
//  GXMine_HeadView_Login.h
//  GXAppNew
//
//  Created by WangLinfang on 16/12/19.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseView.h"
#import "GXUserInfoModel.h"
typedef void(^myBlock)();
@interface GXMine_HeadView_Login : GXMineBaseView
@property (weak, nonatomic) IBOutlet UIImageView *img_head;
@property (weak, nonatomic) IBOutlet UILabel *label_title;
@property(nonatomic,copy)myBlock seeCustomInfo;
@end
