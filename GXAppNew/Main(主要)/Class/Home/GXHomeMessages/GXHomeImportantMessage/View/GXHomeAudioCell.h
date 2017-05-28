//
//  GXHomeAudioCell.h
//  GXAppNew
//
//  Created by 王振 on 2016/12/11.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXHomeAudioModel.h"

@interface GXHomeAudioCell : UITableViewCell
@property (strong, nonatomic) UISlider *audioSlider;
@property (strong, nonatomic) UIButton *audioPlayBtn;
@property (strong, nonatomic) UILabel *audioCurrentTimeLabel;
@property (strong, nonatomic) UILabel *audioTotalTimeLabel;
@property (nonatomic,strong)GXHomeAudioModel *model;
@end
