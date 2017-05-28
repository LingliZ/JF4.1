//
//  GXSugHeaderCell.m
//  GXAppNew
//
//  Created by zhudong on 2017/1/13.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXSugHeaderCell.h"
#import "GXLiveTimeTool.h"
#import "GXHeadReduceTool.h"

@interface GXSugHeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;
@property (weak, nonatomic) IBOutlet UIView *tipBGV;
@property (weak, nonatomic) IBOutlet UILabel *tipL;
@property (weak, nonatomic) IBOutlet UILabel *productL;
@property (weak, nonatomic) IBOutlet UILabel *priceL;
@property (weak, nonatomic) IBOutlet UILabel *operatL;
@property (weak, nonatomic) IBOutlet UILabel *detailTimeL;
@property (weak, nonatomic) IBOutlet UILabel *cPriceL;
@property (weak, nonatomic) IBOutlet UILabel *increaseL;
@property (weak, nonatomic) IBOutlet UILabel *tarPriceL;
@property (weak, nonatomic) IBOutlet UILabel *stopPriceL;

@property (weak, nonatomic) IBOutlet UILabel *jianL;
@property (weak, nonatomic) IBOutlet UILabel *fuL;
@property (weak, nonatomic) IBOutlet UILabel *muL;
@property (weak, nonatomic) IBOutlet UILabel *ziL;
@property (weak, nonatomic) IBOutlet UILabel *caoL;
@property (weak, nonatomic) IBOutlet UILabel *neiL;
@property (weak, nonatomic) IBOutlet UILabel *caoShiL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftMarginCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightMarginCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceContentHCons;

@end
@implementation GXSugHeaderCell

//- (void)setSuggestionModel:(GXSuggestionModel *)suggestionModel{
//    _suggestionModel = suggestionModel;
//    [self.iconV sd_setImageWithURL:[NSURL URLWithString:suggestionModel.userPhoto] placeholderImage:[UIImage imageNamed:@"head_PlaceHolder"]];
//    self.iconV.layer.cornerRadius = self.iconV.size.width / 2;
//    self.iconV.layer.masksToBounds = YES;
//    self.nameL.text = suggestionModel.userName;
//    //持仓时间
//    self.timeL.text = [NSString stringWithFormat:@"持牌:%@",suggestionModel.timeStr];
//    //操作方向（多、空）
//    self.tipL.text = suggestionModel.directionStr;
//    self.tipBGV.backgroundColor = suggestionModel.directionColor;
//    //品种
//    self.productL.text = suggestionModel.varieties;
//    //操作点位
////    self.priceL.text = [NSString stringWithFormat:@"%@",suggestionModel.stopPrice];
//    //操作点位
//    
//    GXOperationItemModel *firstItem = suggestionModel.operationItems.firstObject;
//    if (suggestionModel.operationItems.count > 1) {
//        __block GXOperationItemModel *cPItem;
//        [suggestionModel.operationItems enumerateObjectsUsingBlock:^(GXOperationItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            if ([obj.leftStr isEqualToString:@"修改价位"]) {
//                cPItem = obj;
//                *stop = YES;
//            }
//        }];
//        if (cPItem == nil) {
//            cPItem = suggestionModel.operationItems.lastObject;
//        }
//        self.tarPriceL.text = [NSString stringWithFormat:@"%@", cPItem.targetPrice];
//        self.stopPriceL.text = [NSString stringWithFormat:@"%@", cPItem.stopPrice];
//        self.priceL.text = [NSString stringWithFormat:@"在%@",firstItem.stopPrice];
//        if ([firstItem.leftStr isEqualToString:@"修改价位"]) {
//            self.priceL.text = nil;
//        }
//    } else {
//        self.priceL.text = [NSString stringWithFormat:@"在%@",suggestionModel.sellingPrice];
//        self.tarPriceL.text = [NSString stringWithFormat:@"%@", firstItem.targetPrice];
//        self.stopPriceL.text = [NSString stringWithFormat:@"%@", firstItem.stopPrice];
//    }
//
//    //操作
//    self.operatL.text = [NSString stringWithFormat:@"(%@)",((GXOperationItemModel *)suggestionModel.operationItems.firstObject).leftStr];
//    //操作时间
//    self.detailTimeL.text = [GXLiveTimeTool getTimeString:suggestionModel.operationItems.firstObject.createdTime];
//    //建仓
//    self.cPriceL.text = [NSString stringWithFormat:@"%@",suggestionModel.sellingPrice];
//    //浮盈
//    if ([firstItem.types integerValue] == 2 || [firstItem.types integerValue] == 3) {
//        
//        
//        NSArray *aaa=suggestionModel.operationItems;
//        GXOperationItemModel *moaaa=[aaa firstObject];
//        
//        if ([firstItem.directionStr isEqualToString:@"多"]) {
//            float fuYing = (([moaaa.stopPrice floatValue] - [suggestionModel.sellingPrice floatValue]) / [suggestionModel.sellingPrice floatValue]) * 100;
//            if (fuYing > 0) {
//                self.increaseL.text = [NSString stringWithFormat:@"+%.2f%%",fuYing];
//            } else {
//                self.increaseL.text = [NSString stringWithFormat:@"%.2f%%",fuYing];
//            }
//            self.increaseL.textColor = [self dealWithYuyingNum:self.increaseL.text];
//        } else {
//            float fuYing = (([suggestionModel.sellingPrice floatValue] - [moaaa.stopPrice floatValue]) / [suggestionModel.sellingPrice floatValue]) * 100;
//            if (fuYing > 0) {
//                self.increaseL.text = [NSString stringWithFormat:@"+%.2f%%",fuYing];
//            } else {
//                self.increaseL.text = [NSString stringWithFormat:@"%.2f%%",fuYing];
//            }
//            self.increaseL.textColor = [self dealWithYuyingNum:self.increaseL.text];
//        }
//    } else {
//        self.increaseL.text = suggestionModel.fuying;
//        self.increaseL.textColor = suggestionModel.fuYingColor;
//    }
//}
- (void)setSuggestModel:(GXSuggestionModel *)suggestModel
{
    _suggestModel = suggestModel;
    [GXHeadReduceTool loadImageForImageView:self.iconV withUrlString:suggestModel.userPhoto placeHolderImageName:@"mine_head_placeholder"];
    self.iconV.layer.cornerRadius = self.iconV.size.width / 2;
    self.iconV.layer.masksToBounds = YES;
    self.nameL.text = suggestModel.userName;
    //持仓时间
    self.timeL.text = [NSString stringWithFormat:@"持牌:%@",suggestModel.timeStr];
    //操作方向（多、空）
    self.tipL.text = suggestModel.directionStr;
    self.tipBGV.backgroundColor = suggestModel.directionColor;
    //品种
    self.productL.text = suggestModel.varieties;
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
        self.tarPriceL.text = [NSString stringWithFormat:@"%@", cPItem.targetPrice];
        self.stopPriceL.text = [NSString stringWithFormat:@"%@", cPItem.stopPrice];
        
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithString:@"在 " attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        
        NSMutableAttributedString *sellingPriceAttr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",(suggestModel.operationItems.firstObject).stopPrice] attributes:@{NSForegroundColorAttributeName : GXRGBColor(64, 130, 244)}];
        [mAttr appendAttributedString:sellingPriceAttr];
        self.priceL.attributedText = mAttr;
        
        if ([firstItem.leftStr isEqualToString:@"修改价位"] || [firstItem.leftStr isEqualToString:@"撤单"]) {
            self.priceL.text = nil;
        }
    } else {
        NSMutableAttributedString *mAttr = [[NSMutableAttributedString alloc] initWithString:@"在 " attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        
        NSDecimalNumber *guaDanP;
        if ([suggestModel.pattern isEqualToString:@"挂单"]) {
            guaDanP = suggestModel.buyingPrice;
        } else {
            guaDanP = suggestModel.sellingPrice;
        }
        
        NSMutableAttributedString *sellingPriceL = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",guaDanP] attributes:@{NSForegroundColorAttributeName : GXRGBColor(64, 130, 244)}];
        
        [mAttr appendAttributedString:sellingPriceL];
        self.priceL.attributedText = mAttr;
        
        self.tarPriceL.text = [NSString stringWithFormat:@"%@", firstItem.targetPrice];
        self.stopPriceL.text = [NSString stringWithFormat:@"%@", firstItem.stopPrice];
    }
    
    //操作
    self.operatL.text = [NSString stringWithFormat:@"%@",((GXOperationItemModel *)suggestModel.operationItems.firstObject).leftStr];
    //操作时间
    self.detailTimeL.text = [GXLiveTimeTool getTimeString:suggestModel.operationItems.firstObject.createdTime];
    //建仓
//    self.cPriceL.text = [NSString stringWithFormat:@"%@",suggestModel.sellingPrice];
    
    if ([suggestModel.pattern isEqualToString:@"挂单"]) {
        __block NSDecimalNumber *createNum = suggestModel.sellingPrice;
        [suggestModel.operationItems enumerateObjectsUsingBlock:^(GXOperationItemModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.leftStr isEqualToString:@"摘牌"]) {
                createNum = obj.stopPrice;
            }
            self.cPriceL.text = [NSString stringWithFormat:@"%@",createNum];
        }];
    } else {
        self.cPriceL.text = [NSString stringWithFormat:@"%@",suggestModel.sellingPrice];
    }
    
    
    //浮盈
    if ([firstItem.types integerValue] == 2 || [firstItem.types integerValue] == 3) {

        NSArray *aaa=suggestModel.operationItems;
        GXOperationItemModel *moaaa=[aaa firstObject];
        
        if ([firstItem.directionStr isEqualToString:@"多"]) {
            float fuYing = (([moaaa.stopPrice floatValue] - [suggestModel.buyingPrice floatValue]) / [suggestModel.buyingPrice floatValue]) * 100;
            if (fuYing > 0) {
                self.increaseL.text = [NSString stringWithFormat:@"+%.2f%%",fuYing];
            } else {
                self.increaseL.text = [NSString stringWithFormat:@"%.2f%%",fuYing];
            }
            if ([suggestModel.buyingPrice floatValue] == 0) {
                self.increaseL.text = @"--";
            }
            self.increaseL.textColor = [self dealWithYuyingNum:self.increaseL.text];
        } else {
            float fuYing = (([suggestModel.buyingPrice floatValue] - [moaaa.stopPrice floatValue]) / [suggestModel.buyingPrice floatValue]) * 100;
            if (fuYing > 0) {
                self.increaseL.text = [NSString stringWithFormat:@"+%.2f%%",fuYing];
            } else {
                self.increaseL.text = [NSString stringWithFormat:@"%.2f%%",fuYing];
            }
            if ([suggestModel.buyingPrice floatValue] == 0) {
                self.increaseL.text = @"--";
            }
            self.increaseL.textColor = [self dealWithYuyingNum:self.increaseL.text];
        }
    } else {
        self.increaseL.text = suggestModel.fuying;
        self.increaseL.textColor = suggestModel.fuYingColor;
    }
    
    self.contentView.frame = CGRectMake(15, 0, GXScreenWidth - 30, self.contentView.height + HeightScale_IOS6(10));
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


- (void)awakeFromNib{
    [super awakeFromNib];
    self.nameL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.timeL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.tipL.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    self.productL.font = GXFONT_PingFangSC_Regular(GXFitFontSize16);
    self.priceL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.operatL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.detailTimeL.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    
    self.cPriceL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.increaseL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.tarPriceL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.stopPriceL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    
    self.jianL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.fuL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.muL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.ziL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.caoL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.neiL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    self.caoShiL.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    
    self.leftMarginCons.constant = WidthScale_IOS6(30);
    self.rightMarginCons.constant = WidthScale_IOS6(30);
    self.priceContentHCons.constant = WidthScale_IOS6(63);
}

@end
