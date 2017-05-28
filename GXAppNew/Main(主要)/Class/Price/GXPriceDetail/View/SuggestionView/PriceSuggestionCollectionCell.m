//
//  PriceSuggestionCollectionCell.m
//  GXAppNew
//
//  Created by futang yang on 2017/1/5.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "PriceSuggestionCollectionCell.h"
#import "GXLiveTimeTool.h"


@implementation PriceSuggestionCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = WidthScale_IOS6(10);
    self.bgView.layer.masksToBounds = YES;
    if (IS_IPHONE_5_OR_LESS) {
        self.directL.font = GXFONT_PingFangSC_Medium(GXFitFontSize12);
        self.varietyL.font = GXFONT_PingFangSC_Medium(GXFitFontSize16);
        self.priceL.font = GXFONT_PingFangSC_Medium(GXFitFontSize16);
        self.operateL.font = GXFONT_PingFangSC_Medium(GXFitFontSize14);
        self.oTimeL.font = GXFONT_PingFangSC_Medium(GXFitFontSize11);
    }
}


- (void)setSuggestModel:(GXSuggestionModel *)suggestModel
{
    _suggestModel = suggestModel;
    [self.headV sd_setImageWithURL:[NSURL URLWithString:suggestModel.userPhoto] placeholderImage:[UIImage imageNamed:UserDefineHeadImage]];
    self.headV.layer.cornerRadius = self.headV.size.width / 2;
    self.headV.layer.masksToBounds = YES;
    self.nameL.text = suggestModel.userName;
    //持仓时间
    self.timeL.text = [NSString stringWithFormat:@"持牌:%@",suggestModel.timeStr];
    //操作方向（多、空）
    self.directL.text = suggestModel.directionStr;
    self.directL.backgroundColor = suggestModel.directionColor;
    //品种
    self.varietyL.text = suggestModel.varieties;
    //操作点位
    
    GXOperationItemModel *firstItem = suggestModel.operationItems.firstObject;
    
    
    if (suggestModel.operationItems.count > 1) {
        __block GXOperationItemModel *cPItem;
        [suggestModel.operationItems enumerateObjectsUsingBlock:^(GXOperationItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.leftStr isEqualToString:@"修改价位"]) {
                cPItem = obj;
                *stop = YES;
            }
        }];
        if (cPItem == nil) {
            cPItem = suggestModel.operationItems.lastObject;
        }
        self.targetNum.text = [NSString stringWithFormat:@"%@", cPItem.targetPrice];
        self.stopNum.text = [NSString stringWithFormat:@"%@", cPItem.stopPrice];
        
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithString:@"在 " attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
        NSMutableAttributedString *sellingPriceAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",(suggestModel.operationItems.firstObject).stopPrice] attributes:@{NSForegroundColorAttributeName : GXRGBColor(64, 130, 244)}];
        [mAttr appendAttributedString:sellingPriceAttr];
        self.priceL.attributedText = mAttr;
        
        if ([firstItem.leftStr isEqualToString:@"修改价位"]) {
            self.priceL.text = nil;
        }
    } else {
        
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithString:@"在 " attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        
        NSMutableAttributedString *sellingPriceAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",suggestModel.sellingPrice] attributes:@{NSForegroundColorAttributeName : GXRGBColor(64, 130, 244)}];
        
        [mAttr appendAttributedString:sellingPriceAttr];
        self.priceL.attributedText = mAttr;
        
        self.targetNum.text = [NSString stringWithFormat:@"%@", firstItem.targetPrice];
        self.stopNum.text = [NSString stringWithFormat:@"%@", firstItem.stopPrice];
    }
    
    //操作
    self.operateL.text = [NSString stringWithFormat:@"%@",((GXOperationItemModel *)suggestModel.operationItems.firstObject).leftStr];
    //操作时间
    self.oTimeL.text = [GXLiveTimeTool getTimeString:suggestModel.operationItems.firstObject.createdTime];
    //建仓
    if ([suggestModel.pattern isEqualToString:@"挂单"]) {
        __block NSDecimalNumber *createNum = suggestModel.sellingPrice;
        [suggestModel.operationItems enumerateObjectsUsingBlock:^(GXOperationItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.leftStr isEqualToString:@"摘牌"]) {
                createNum = obj.stopPrice;
            }
        }];
        self.createNum.text = [NSString stringWithFormat:@"%@",createNum];
    } else {
        self.createNum.text = [NSString stringWithFormat:@"%@",suggestModel.sellingPrice];
    }
    if ([self.createNum.text floatValue]==0) {
        self.createNum.text = @"--";
    }
    
    //浮盈
    if ([firstItem.types integerValue] == 2) {
        
        
        NSArray *aaa=suggestModel.operationItems;
        GXOperationItemModel *moaaa=[aaa firstObject];
        
        if ([firstItem.directionStr isEqualToString:@"多"]) {
            float fuYing = (([moaaa.stopPrice floatValue] - [suggestModel.sellingPrice floatValue]) / [suggestModel.sellingPrice floatValue]) * 100;
            if (fuYing > 0) {
                self.fuYingNum.text = [NSString stringWithFormat:@"+%.2f%%",fuYing];
            } else {
                self.fuYingNum.text = [NSString stringWithFormat:@"%.2f%%",fuYing];
            }
            if ([suggestModel.sellingPrice floatValue] == 0) {
                self.fuYingNum.text = @"--";
            }
            self.fuYingNum.textColor = [self dealWithYuyingNum:self.fuYingNum.text];
        } else {
            float fuYing = (([suggestModel.sellingPrice floatValue] - [moaaa.stopPrice floatValue]) / [suggestModel.sellingPrice floatValue]) * 100;
            if (fuYing > 0) {
                self.fuYingNum.text = [NSString stringWithFormat:@"+%.2f%%",fuYing];
            } else {
                self.fuYingNum.text = [NSString stringWithFormat:@"%.2f%%",fuYing];
            }
            if ([suggestModel.sellingPrice floatValue] == 0) {
                self.fuYingNum.text = @"--";
            }
            self.fuYingNum.textColor = [self dealWithYuyingNum:self.fuYingNum.text];
        }
    } else if ([firstItem.types integerValue] == 3) {
        self.fuYingNum.text = @"--";
    }
    else {
        self.fuYingNum.text = suggestModel.fuying;
        self.fuYingNum.textColor = suggestModel.fuYingColor;
    }
}


- (UIColor *)dealWithYuyingNum:(NSString *)string
{
    UIColor *zeroFyColor = [UIColor blackColor];
    if ([string floatValue] > 0) {
        return GXRGBColor(216, 62, 33);
    } else if ([string floatValue] < 0){
        return GXRGBColor(0, 168, 74);
    } else {
        return zeroFyColor;
    }
}


@end
