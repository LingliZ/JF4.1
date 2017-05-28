//
//  GXHomeVedioCell.h
//  GXAppNew
//
//  Created by 王振 on 2016/12/12.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXHomeVedioModel.h"

@interface GXHomeVedioCell : UITableViewCell
@property (strong, nonatomic)  UIButton *playBtn;
@property (strong, nonatomic)  UIView *vedioView;
@property (nonatomic,strong)GXHomeVedioModel *model;
@end
