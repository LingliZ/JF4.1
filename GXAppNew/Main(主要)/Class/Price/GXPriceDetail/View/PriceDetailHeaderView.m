//
//  PriceDetailHeaderView.m
//  GXAppNew
//
//  Created by futang yang on 2016/12/6.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "PriceDetailHeaderView.h"
#import "PriceMarketModel.h"




#define leftMargin 25
#define increseSize 11



@interface PriceDetailHeaderView ()

@property (nonatomic, strong) PriceMarketModel *model;

@property (nonatomic, weak) UILabel *lastLabel;
@property (nonatomic, weak) UILabel *increasePercentageLabel;
@property (nonatomic, weak) UILabel *increaseLabel;
@property (nonatomic, weak) UILabel *buyLabel;
@property (nonatomic, weak) UILabel *sellLabel;
@property (nonatomic, weak) UILabel *buyLabelValue;
@property (nonatomic, weak) UILabel *sellLabelValue;



@property (nonatomic, strong) NSMutableArray *bottomLabelArray;

@end




@implementation PriceDetailHeaderView


- (instancetype)initWithFrame:(CGRect)frame code:(PriceMarketModel *)model {
    if (self = [super initWithFrame:frame]) {
        _model = model;
        [self config];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self config];
    }
    return self;
}

- (NSMutableArray *)bottomLabelArray {
    if (!_bottomLabelArray) {
        _bottomLabelArray = [NSMutableArray array];
    }
    return _bottomLabelArray;
}


- (void)config {
    
     //最新价
    UILabel *lastLabel = [[UILabel alloc] init];
    self.lastLabel = lastLabel;
    lastLabel.textColor = PriceLightGray;
    lastLabel.textAlignment = NSTextAlignmentLeft;
    lastLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize30);
    [self addSubview:lastLabel];
    
    [lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WidthScale_IOS6(leftMargin));
        make.top.mas_equalTo(HeightScale_IOS6(2));
    }];
    
    
    // 涨幅度
    UILabel *increaseLabel = [[UILabel alloc] init];
    self.increaseLabel = increaseLabel;
    increaseLabel.textAlignment = NSTextAlignmentLeft;
    increaseLabel.textColor = [UIColor whiteColor];
    increaseLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    [self addSubview:increaseLabel];
    
    [increaseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WidthScale_IOS6(leftMargin));
        make.top.mas_equalTo(lastLabel.mas_bottom).offset(1);
    }];
    
    //涨幅率
    UILabel *increasePercentageLabel = [[UILabel alloc] init];
    self.increasePercentageLabel = increasePercentageLabel;
    increasePercentageLabel.textAlignment = NSTextAlignmentRight;
    increasePercentageLabel.textColor = [UIColor whiteColor];
    increasePercentageLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize11);
    [self addSubview:increasePercentageLabel];
    
    [increasePercentageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lastLabel.mas_bottom).offset(1);
        make.left.mas_equalTo(increaseLabel.mas_right).offset(10);
    }];
    
    
    // 买价
    UILabel *buyLabel = [[UILabel alloc] init];
    self.buyLabel = buyLabel;
    buyLabel.textAlignment = NSTextAlignmentLeft;
    buyLabel.textColor = PriceLightGray;
    buyLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    buyLabel.text = (self.model.isTD) ? @"成交量:" : @"买价:";
    [self addSubview:buyLabel];
    
    [buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(HeightScale_IOS6(10));
        make.left.mas_equalTo(WidthScale_IOS6(194));
    }];

    // 买价数值
    UILabel *buyLabelValue = [[UILabel alloc] init];
    self.buyLabelValue = buyLabelValue;
    buyLabelValue.textAlignment = NSTextAlignmentLeft;
    buyLabelValue.textColor = [UIColor whiteColor];
    buyLabelValue.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    [self addSubview:buyLabelValue];
    
    [buyLabelValue mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(HeightScale_IOS6(10));
        make.left.mas_equalTo(buyLabel.mas_right).offset(3);
        make.centerY.mas_equalTo(buyLabel.mas_centerY);
    }];
    
    
    // 卖价
    UILabel *sellLabel = [[UILabel alloc] init];
    self.sellLabel = sellLabel;
    sellLabel.textAlignment = NSTextAlignmentLeft;
    sellLabel.textColor = PriceLightGray;
    sellLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize12);
    sellLabel.text = (self.model.isTD) ? @"持仓量:" : @"卖价:";
    [self addSubview:sellLabel];
    
    [sellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(HeightScale_IOS6(36));
        make.left.mas_equalTo(WidthScale_IOS6(194));
    }];
    
    // 卖数值
    UILabel *sellLabelValue = [[UILabel alloc] init];
    self.sellLabelValue = sellLabelValue;
    sellLabelValue.textAlignment = NSTextAlignmentLeft;
    sellLabelValue.textColor = [UIColor whiteColor];
    sellLabelValue.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    [self addSubview:sellLabelValue];
    
    [sellLabelValue mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.mas_equalTo(HeightScale_IOS6(36));
        make.centerY.mas_equalTo(sellLabel.mas_centerY);
        make.left.mas_equalTo(sellLabel.mas_right).offset(3);
    }];
    
    
    
    NSArray *ar1;
    if (self.model.isTD) {
        ar1 = @[@"今开",@"昨结",@"最高",@"最低"];
    } else {
        ar1 = @[@"开盘",@"昨收",@"最高",@"最低"];
    }
    
    // 开高低收
    
    NSArray *ar2 = @[@"--", @"--", @"--", @"--"];
    
    CGFloat x = 16;
    CGFloat y = HeightScale_IOS6(75);
    
    CGFloat width = (self.width - (16 * 2) )/ar1.count;
    CGFloat topLabelheight = HeightScale_IOS6(14);
    CGFloat bottomLableheight = HeightScale_IOS6(20);
    
    for (NSInteger i = 0; i < ar1.count; i++) {
        UILabel *topLabel = [[UILabel alloc] init];
        topLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize10);
        topLabel.textColor = PriceLightGray;
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.text = ar1[i];
        topLabel.frame = CGRectMake(x + i * width, y, width, topLabelheight);
        
        
        UILabel *bottomLable = [[UILabel alloc] init];
        bottomLable.font = GXFONT_PingFangSC_Regular(GXFitFontSize13);
        bottomLable.textColor = [UIColor whiteColor];
        bottomLable.textAlignment = NSTextAlignmentCenter;
        bottomLable.text = ar2[i];
        bottomLable.frame = CGRectMake(x + i * width, topLabel.y + topLabel.height + 3, width, bottomLableheight);
        
       
        
        [self addSubview:topLabel];
        [self addSubview:bottomLable];
        
         [self.bottomLabelArray addObject:bottomLable];
        
    }

}

- (void)setPriceDetailHeaderView:(PriceMarketModel *)model {
    
    
    if (model.isTD) {
        
        self.lastLabel.text = model.last;
        self.increasePercentageLabel.text = model.increasePercentage;
        self.increaseLabel.text = model.increase;
        
        self.buyLabelValue.text = model.volume;
        self.sellLabelValue.text = model.holdqty;
        
        // 颜色
        self.lastLabel.textColor = model.lastColor;
        self.increasePercentageLabel.textColor = model.increaseBackColor;
        self.increaseLabel.textColor = model.increaseBackColor;
        self.buyLabelValue.textColor = [UIColor whiteColor];
        self.sellLabelValue.textColor = [UIColor whiteColor];
        
      
        
        

    } else {
        
         // 数值
        self.buyLabelValue.text = model.buy;
        self.sellLabelValue.text = model.sell;
        self.lastLabel.text = model.last;
        self.increasePercentageLabel.text = model.increasePercentage;
        self.increaseLabel.text = model.increase;
        
        
        // 颜色
        self.lastLabel.textColor = model.lastColor;
        self.increasePercentageLabel.textColor = model.increaseBackColor;
        self.increaseLabel.textColor = model.increaseBackColor;
        self.buyLabelValue.textColor = model.buyColor;
        self.sellLabelValue.textColor = model.sellColor;
    }
    
    
    // 底部
    NSArray *array = @[model.open, model.lastclose, model.high, model.low];
    
    if (array.count == self.bottomLabelArray.count) {
        
        for (NSInteger i = 0; i < array.count; i++) {
            UILabel *label = self.bottomLabelArray[i];
            label.text = array[i];
        }
    }
    

   
    
    
}


@end
