//
//  GXHomeUserStatisticsCell.h
//  GXAppNew
//
//  Created by 王振 on 2016/11/29.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXHomeUserStatisticsModel.h"
@interface GXHomeUserStatisticsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *homeBtn1;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn2;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn3;
@property (weak, nonatomic) IBOutlet UIButton *homeBtn4;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;

@property (nonatomic,copy)void(^homeBtnBlock)(NSInteger);


@end
