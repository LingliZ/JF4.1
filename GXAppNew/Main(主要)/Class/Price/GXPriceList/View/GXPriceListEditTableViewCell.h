//
//  GXPriceListEditTableViewCell.h
//  GXAppNew
//
//  Created by shenqilong on 16/12/18.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GXPriceListScrollView;
@protocol GXPriceListEditTableViewCellDelegate <NSObject>

-(void)tapRootScr:(id)sender;//点击scroll

-(void)tapTopButton:(id)sender;// 点击置顶

-(void)tapDeleButton:(id)sender;// 删除调用

@end
@interface GXPriceListEditTableViewCell : UITableViewCell

- (void) setChecked:(BOOL)checked;

@property(nonatomic,assign)id<GXPriceListEditTableViewCellDelegate>delegate;


@property (weak, nonatomic) IBOutlet UILabel *codename;
@property (weak, nonatomic) IBOutlet UILabel *exname;
- (IBAction)topButtonClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *topButton;

@property (strong, nonatomic) UIButton *deleButton;
@property (strong, nonatomic) GXPriceListScrollView *rootScr;




@end
