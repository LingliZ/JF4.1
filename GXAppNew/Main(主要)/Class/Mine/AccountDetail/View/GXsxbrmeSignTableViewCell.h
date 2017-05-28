//
//  GXsxbrmeSignTableViewCell.h
//  GXAppNew
//
//  Created by shenqilong on 17/2/10.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXsxbrmeSignTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *bankName;
@property (weak, nonatomic) IBOutlet UILabel *bankNameText;

@property (weak, nonatomic) IBOutlet UIImageView *bankNameArrow;

@property(nonatomic,strong)UIImageView *bankImgSelect;

- (void)changeArrowWithUp:(BOOL)up;
@end
