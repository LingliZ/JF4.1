//
//  GXHomeImpHeaderView.h
//  GXAppNew
//
//  Created by 王振 on 2017/1/23.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GXHomeImpHeaderView : UITableViewHeaderFooterView
+ (instancetype)headerViewWihtTableView:(UITableView *)tableView;
@property (nonatomic,strong)NSString *title;
@end
