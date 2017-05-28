//
//  GXHomeAddCollectionCell.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeAddCollectionCell.h"

@implementation GXHomeAddCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.leftX.constant = (WidthScale_IOS6(111) - 60)/2;
    self.rightX.constant = (WidthScale_IOS6(111) - 60)/2;
    ;
}

@end
