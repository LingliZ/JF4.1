//
//  GXHomeGettingStartCell.h
//  GXAppNew
//
//  Created by 王振 on 2016/12/29.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXHomeGettingStartCell : UITableViewCell
@property (nonatomic,copy)void(^didNewOneClickAction)(NSInteger);

@property (weak, nonatomic) IBOutlet UILabel *homeNewOneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *homeNewOneImgView;

@property (weak, nonatomic) IBOutlet UIButton *homeNewOneBtn1;
@property (weak, nonatomic) IBOutlet UIButton *homeNewOneBtn2;
@property (weak, nonatomic) IBOutlet UIButton *homeNewOneBtn3;


@property (weak, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIView *backGroundView;








@end
