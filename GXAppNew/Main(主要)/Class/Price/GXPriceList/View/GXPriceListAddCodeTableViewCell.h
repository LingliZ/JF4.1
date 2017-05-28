//
//  GXPriceListAddCodeTableViewCell.h
//  GXAppNew
//
//  Created by shenqilong on 16/12/16.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GXTextSpaceLabel.h"

@protocol GXPriceListAddCodeTableViewCellDelegate <NSObject>

-(void)btnAddClick:(id)sender;

@end
@interface GXPriceListAddCodeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *lineImg;
@property (weak, nonatomic) IBOutlet UIButton *titBtn;




@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIButton *btn_add;
- (IBAction)btn_addClick:(id)sender;
@property (weak, nonatomic) IBOutlet GXTextSpaceLabel *lb_last;




- (void)changeArrowWithUp:(BOOL)up;

@property(nonatomic,assign)id<GXPriceListAddCodeTableViewCellDelegate>delegate;

@end
