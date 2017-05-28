//
//  PriceCanlendarBaseCell.m
//  GXAppNew
//
//  Created by futang yang on 2016/12/7.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "PriceCanlendarBaseCell.h"
#import "PriceCanlendarBaseModel.h"

@implementation PriceCanlendarBaseCell


+ (instancetype)cellWithTable:(UITableView *)tablew Model:(PriceCanlendarBaseModel *)model  indexPath:(NSIndexPath *)indexpath  {
    
    NSString *indentifer = NSStringFromClass([model class]);
    PriceCanlendarBaseCell *cell = [tablew dequeueReusableCellWithIdentifier:indentifer];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setModel:model];
    return cell;
}

- (void)setModel:(PriceCanlendarBaseModel *)model {
    
}



@end
