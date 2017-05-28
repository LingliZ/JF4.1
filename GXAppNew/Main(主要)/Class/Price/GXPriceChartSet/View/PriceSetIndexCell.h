//
//  PriceSetIndexCell.h
//  ChartDemo
//
//  Created by futang yang on 2016/12/22.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PriceSetIndexModel.h"

@class PriceSetIndexCell;
@protocol PriceSetIndexCellDelegate <NSObject>

@optional
- (void)inputChangeCell:(PriceSetIndexCell *)cell  textfield:(UITextField *)textfield  indexPath:(NSIndexPath *)indexPath;
- (void)inputEndChangeCell:(PriceSetIndexCell *)cell  textfield:(UITextField *)textfield  indexPath:(NSIndexPath *)indexPath;
- (void)SetIndexCellBeginInput:(UITextField *)textfield;

@end


@interface PriceSetIndexCell : UITableViewCell

+ (PriceSetIndexCell *)cellWithTableView:(UITableView *)tableview indexPath:(NSIndexPath *)path;

- (void)setModel:(PriceSetIndexModel *)model index:(NSIndexPath *)path;

@property (nonatomic, strong) PriceSetIndexModel *model;

@property (nonatomic, assign) id <PriceSetIndexCellDelegate> delegate;




@end
