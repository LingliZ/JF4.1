//
//  PriceSelectIndexController.h
//  GXAppNew
//
//  Created by futang yang on 2016/12/28.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXBaseViewController.h"


typedef void (^SelectIndexBlock)(KLineChartBottomType tpye);

@interface PriceSelectIndexController : GXBaseViewController

@property (nonatomic, copy) SelectIndexBlock selecBlock;



@end
