//
//  PriceMarketModel.h
//  GXApp
//
//  Created by yangfutang on 16/5/20.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceMarketModel : NSObject


/**
 *  买价
 */
@property (nonatomic,copy) NSString *buy;


/**
 *  现货名称代码
 */
@property (nonatomic,copy) NSString *code;


/**
 *  交易场所代码
 */
@property (nonatomic,copy) NSString *excode;

/**
 *  交易场所名称
 */
@property (nonatomic,copy) NSString *exname;


/**
 *  来自
 */
@property (nonatomic,copy) NSString *from;

/**
 *  最高
 */
@property (nonatomic,copy) NSString *high;


/**
 *  最新价格
 */
@property (nonatomic,copy) NSString *last;
/**
 *  昨收
 */
@property (nonatomic,copy) NSString *lastclose;
/**
 *  最低
 */
@property (nonatomic,copy) NSString *low;


/**
 *  现货名称
 */
@property (nonatomic,copy) NSString *name;

/**
 *  开盘
 */
@property (nonatomic,copy) NSString *open;


/**
 *  报价时间
 */
@property (nonatomic,copy) NSString *quoteTime;


/**
 *  卖价
 */
@property (nonatomic,copy) NSString *sell;


/**
 *  状态
 */
@property (nonatomic,copy) NSString *status;



/**
 *  地点
 */
@property (nonatomic,copy) NSString *shortName;


/**
 交易规则
 */
@property (nonatomic, copy) NSString *tradeDetail;



/**
 持仓量
 */
@property (nonatomic, copy) NSString *holdqty;

/**
 成交量
 */
@property (nonatomic, copy) NSString *volume;



/**
 是否是TD
 */
@property (nonatomic, assign)int isTD;





/**
 保留小数点个数
 */
@property (nonatomic, assign) NSInteger saveDecimalPlaces;


/**
 *  是否显示交易所标题
 */
//@property (nonatomic,assign) BOOL isHiddenPme;



/**
 *  涨幅
 */
@property (nonatomic,copy) NSString *increase;

/**
 *  涨幅百分比
 */
@property (nonatomic,copy) NSString *increasePercentage;

/**
 *  涨幅的背景颜色
 */
@property (nonatomic, strong) UIColor *increaseBackColor;

/**
 *  最新价格颜色
 */
@property (nonatomic, strong) UIColor *lastColor;

/**
 *  买价的颜色
 */
@property (nonatomic, strong) UIColor *buyColor;

/**
 *  卖价的颜色
 */
@property (nonatomic, strong) UIColor *sellColor;

/**
 *  最高的颜色
 */
@property (nonatomic,strong) UIColor *highColor;

/**
 *  最低的颜色
 */
@property (nonatomic,strong) UIColor *lowColor;

/**
 *  今开的颜色
 */
@property (nonatomic,strong) UIColor *openColor;

/**
 *  最新价的闪动颜色
 */
@property (nonatomic,strong) UIColor *lastBackgColor;




/**
 *  根据昨收的比较
 *
 *  @param value 参数
 *
 *  @return 不同的颜色
 */
- (UIColor *)compareWithLastClose:(NSString *)value;


@end
