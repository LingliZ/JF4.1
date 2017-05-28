//
//  UITableView+GXSelfTableView.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/2.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "UITableView+GXSetFooter.h"
#define BackgroundColor GXRGBColor(59, 62, 76)

@implementation UITableView (GXSetFooter)
- (void)setFooter{
    self.backgroundColor = BackgroundColor;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *footerV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
    self.backgroundColor = BackgroundColor;
    self.tableFooterView = footerV;
}
@end
