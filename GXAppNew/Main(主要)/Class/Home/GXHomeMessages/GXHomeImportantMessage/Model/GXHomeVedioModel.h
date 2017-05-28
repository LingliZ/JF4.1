//
//  GXHomeVedioModel.h
//  GXAppNew
//
//  Created by 王振 on 2016/12/1.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeImpMsgBaseModel.h"

@interface GXHomeVedioModel : GXHomeImpMsgBaseModel
// 图片
@property (nonatomic, strong) NSString *imgUrl;
//作者
@property (nonatomic, strong) NSString *author;
//视频链接url
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) CGFloat sourceWidth;

@end
