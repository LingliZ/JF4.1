//
//  GXPriceAlarmCell.m
//  GXApp
//
//  Created by 王淼 on 16/8/12.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXPriceAlarmCell.h"
@implementation GXPriceAlarmCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //描述
        codeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        codeLabel.frame = CGRectMake(WidthScale_IOS6(15), HeightScale_IOS6(15), WidthScale_IOS6(345), HeightScale_IOS6(20));
        codeLabel.textColor = [UIColor colorWithWhite:0.502 alpha:1.000];
        codeLabel.textAlignment = NSTextAlignmentLeft;
        codeLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:codeLabel];
        //时间
        timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        timeLabel.frame = CGRectMake(GXScreenWidth-WidthScale_IOS6(125), codeLabel.frame.origin.y + codeLabel.frame.size.height + HeightScale_IOS6(5), WidthScale_IOS6(125), HeightScale_IOS6(20));
        timeLabel.textColor = [UIColor colorWithWhite:0.702 alpha:1.000];
        timeLabel.font = [UIFont systemFontOfSize:12];
        timeLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:timeLabel];

        UIView *separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, timeLabel.frame.size.height+timeLabel.frame.origin.y, GXScreenWidth, HeightScale_IOS6(5))];
        separatorView.backgroundColor = GXRGBColor(245.0,246.0,247.0);
        [self.contentView addSubview:separatorView];
    }
    return self;
}
-(void)setAlartModel:(GXPriceAlertModel *)alartModel {
    if (_alartModel != alartModel) {
        _alartModel = alartModel;
        //赋值
        codeLabel.text = alartModel.content;
        timeLabel.text = alartModel.time;
    }
}

@end
