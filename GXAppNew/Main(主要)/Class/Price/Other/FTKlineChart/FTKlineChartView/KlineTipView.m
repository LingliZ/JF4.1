//
//  KlineTipView.m
//  GXAppNew
//
//  Created by futang yang on 2016/12/30.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "KlineTipView.h"
#import "FTLineData.h"


@interface KlineTipView ()

@property (nonatomic, strong) NSMutableArray *labelArray;

@end


@implementation KlineTipView


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}


- (void)config {
    
    
    UILabel *label1 = [[UILabel alloc] init];
    [self addSubview:label1];
    self.label1 = label1;
    
    
    label1.font = GXFONT_PingFangSC_Regular(9);
    label1.textColor = PriceFontColor;
    
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.leading.mas_equalTo(self.mas_leading).offset(5);
    }];
    
    
    
    UILabel *label2 = [[UILabel alloc] init];
    self.label2 = label2;
    [self addSubview:label2];
    
    label2.font = GXFONT_PingFangSC_Regular(9);
    label2.textColor = PriceFontColor;
    
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.leading.mas_equalTo(self.label1.mas_trailing).offset(5);
    }];
    
    
    
    UILabel *label3 = [[UILabel alloc] init];
    self.label3 = label3;
    [self addSubview:label3];
    label3.font = GXFONT_PingFangSC_Regular(9);
    label3.textColor = PriceFontColor;
    
    
  
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.leading.mas_equalTo(self.label2.mas_trailing).offset(5);
    }];
    
 
    
    self.labelArray = @[label1,label2,label3].mutableCopy;
    
}

- (void)setTipTitleArray:(NSArray *)tipTitleArray {
    _tipTitleArray = tipTitleArray;
    
    for (NSInteger i = 0; i < tipTitleArray.count; i++) {
        FTLineData *item = tipTitleArray[i];
        UILabel *label = self.labelArray[i];
        label.text = [NSString stringWithFormat:@"%@ %.2f",item.title, item.value];
        label.textColor = item.color;
    }
}


//- (NSString *)dealwithValue:(float)value {
//    NSString *string = [NSString stringWithFormat:@"%f",value];
//    if (string && string.length != 0) {
//        NSArray *temp = [string componentsSeparatedByString:@"."];
//        NSString *last = temp.lastObject;
//        
//        if (last.length <= 4) {
//            return [NSString stringWithFormat:@"%f",value];
//        } else {
//            return [NSString stringWithFormat:@"%.4f",value];
//        }
//    }
//    return 0;
//}


- (NSMutableArray *)labelArray {
    if (!_labelArray) {
        _labelArray = [NSMutableArray array];
    }
    return _labelArray;
}




@end
