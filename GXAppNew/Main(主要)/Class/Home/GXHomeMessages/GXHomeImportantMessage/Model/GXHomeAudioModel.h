//
//  GXHomeAudioModel.h
//  GXAppNew
//
//  Created by 王振 on 2016/12/1.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeImpMsgBaseModel.h"

@interface GXHomeAudioModel : GXHomeImpMsgBaseModel
// 图片
@property (nonatomic, strong) NSString *imgUrl;
// 音频链接url
@property (nonatomic, strong) NSString *url;
// 作者
@property (nonatomic, strong) NSString *author;
@property (nonatomic,copy) NSString *totalTimeStr;

@property (nonatomic, assign) CGFloat sourceWidth;

@end
