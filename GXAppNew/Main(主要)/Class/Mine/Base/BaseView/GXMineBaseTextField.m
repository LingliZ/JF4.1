//
//  GXMineBaseTextField.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/21.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMineBaseTextField.h"

@implementation GXMineBaseTextField


-(void)awakeFromNib
{
    [super awakeFromNib];
    [[UITextField appearance]setTintColor:[UIColor blackColor]];//会设置所有的textfield的光标颜色
}
-(void)setPalceholderColor:(UIColor *)palceholderColor
{
    _placeholderColor=palceholderColor;
    [self setValue:palceholderColor forKeyPath:@"_placeholderLabel.textColor"];
}
@end
