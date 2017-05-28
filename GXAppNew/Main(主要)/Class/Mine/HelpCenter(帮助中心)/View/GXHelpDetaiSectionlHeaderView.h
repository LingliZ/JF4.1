//
//  GXHelpDetaiSectionlHeaderView.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/17.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseView.h"
#import "GXHelpModel.h"

@protocol GXHelpDetailSectionHeaderViewDelegate <NSObject>
-(void)helpSectionHeaderViewDidClickWithSection:(NSInteger)section;
@end
@interface GXHelpDetaiSectionlHeaderView : GXMineBaseView
@property (weak, nonatomic) IBOutlet UILabel *label_content;
@property (weak, nonatomic) IBOutlet UIImageView *img_direction;
@property(nonatomic,strong)NSIndexPath*indexPath;
@property(nonatomic,assign)NSInteger section;
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,weak)id<GXHelpDetailSectionHeaderViewDelegate>delegate;
@end
