//
//  GXHelpModel.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/10.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseModel.h"

@interface GXHelpModel : GXMineBaseModel
@property(nonatomic,strong)NSString*content;
@property(nonatomic,strong)NSString*title;
@property(nonatomic,strong)NSNumber*type;
@property(nonatomic,strong)NSString*url;
@property(nonatomic,strong)NSString*certificatePic;
@property(nonatomic,assign)CGFloat hight;
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,strong)NSNumber* exchangeType;
@end
