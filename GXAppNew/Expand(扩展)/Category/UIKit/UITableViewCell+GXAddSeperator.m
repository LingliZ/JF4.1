//
//  UITableViewCell+GXAddSeperator.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/9.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "UITableViewCell+GXAddSeperator.h"
#import "Masonry.h"

@implementation UITableViewCell (GXAddSeperator)
- (void)addSepeartorWidth: (CGFloat) width color: (UIColor *)color top: (BOOL) isTop bottom: (BOOL)isBottom{
    if (isTop) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = color;
        
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.contentView);
            make.height.equalTo(@(width));
        }];
    }
    
    if (isBottom) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = color;
        
        [self.contentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.equalTo(@(width));
        }];
    }
}

- (void)addSepeartorX:(CGFloat)x width: (CGFloat) width color: (UIColor *)color top: (BOOL) isTop bottom: (BOOL)isBottom{
    if (isTop) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = color;
        
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(x);
            make.top.right.equalTo(self);
            make.height.equalTo(@(width));
        }];
    }
    
    if (isBottom) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = color;
        
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(x);
            make.bottom.right.equalTo(self);
            make.height.equalTo(@(width));
        }];
    }
}
@end
