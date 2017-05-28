//
//  GXHomeCountDownCell.h
//  GXAppNew
//
//  Created by 王振 on 2016/11/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXHomeCountDownModel.h"
@interface GXHomeCountDownCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewTopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *juliTopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dayTopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *day1TopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hourTopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hour1TopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minuteTopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *minute1TopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondsTopLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seconds1TopLine;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *countDownImgView;
@property (nonatomic,strong)GXHomeCountDownModel *model;



@end
