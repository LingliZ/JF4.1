//
//  PriceSetIndexCell.m
//  ChartDemo
//
//  Created by futang yang on 2016/12/22.
//  Copyright © 2016年 taiya. All rights reserved.
//

#import "PriceSetIndexCell.h"

@interface PriceSetIndexCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *LeftTitleLable;
@property (weak, nonatomic) IBOutlet UITextField *inputTextfiled;
@property (weak, nonatomic) IBOutlet UILabel *rightTitleLable;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end


#define kMaxAmount 50

@implementation PriceSetIndexCell


+ (PriceSetIndexCell *)cellWithTableView:(UITableView *)tableview indexPath:(NSIndexPath *)path {

    static NSString *Identifier = @"Identifier";
    PriceSetIndexCell *cell = [tableview dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PriceSetIndexCell" owner:self options:nil] lastObject];
    }
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 调整UI
    // rgb 18 29 61
    self.LeftTitleLable.textColor = GXRGBColor(18, 29, 61);
    self.LeftTitleLable.font = GXFONT_PingFangSC_Regular(15);
    

    //rgb 221 223 229
    //[self.inputTextfiled setBorderStyle:UITextBorderStyleLine];
    self.inputTextfiled.layer.masksToBounds = YES;
    self.inputTextfiled.layer.borderWidth = 0.5;
    self.inputTextfiled.layer.borderColor = GXRGBColor(221, 223, 229).CGColor;
    self.inputTextfiled.textAlignment = NSTextAlignmentCenter;
    self.inputTextfiled.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName:GXFONT_PingFangSC_Medium(14),NSForegroundColorAttributeName:GXRGBColor(161, 166, 187)}];
    self.inputTextfiled.delegate = self;
    self.inputTextfiled.keyboardType = UIKeyboardTypeNumberPad;
    [self.inputTextfiled addTarget:self action:@selector(textfieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    //rgb 161 166 187
    self.rightTitleLable.textColor = GXRGBColor(161, 166, 187);
    self.rightTitleLable.font = GXFONT_PingFangSC_Regular(13);
}


- (void)setModel:(PriceSetIndexModel *)model index:(NSIndexPath *)path {
    _model = model;
    
    
    self.LeftTitleLable.text = model.leftTitle;
    self.inputTextfiled.text = [NSString stringWithFormat:@"%ld", model.period];
    self.rightTitleLable.text = model.rightTitle;
    self.indexPath = path;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(SetIndexCellBeginInput:)]) {
        [self.delegate SetIndexCellBeginInput:textField];
    }
}




- (void)textfieldTextDidChange:(UITextField *)sender {
    
//    if ([sender.text integerValue] <= self.model.startIndex) {
//        sender.text = [NSString stringWithFormat:@"%ld",self.model.startIndex];
//    } else if ([sender.text integerValue] >= self.model.endIndex) {
//        sender.text = [NSString stringWithFormat:@"%ld",self.model.endIndex];
//    }
    
    
    if ([sender.text integerValue] >= self.model.endIndex) {
        sender.text = [NSString stringWithFormat:@"%ld",self.model.endIndex];
    }
    
    
    if ([self.delegate respondsToSelector:@selector(inputChangeCell:textfield:indexPath:)]) {
        
        
        [self.delegate inputChangeCell:self textfield:sender indexPath:self.indexPath];
    }
}













@end
