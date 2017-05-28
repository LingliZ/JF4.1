//
//  GXHomeImpMsgBaseModel.m
//  GXAppNew
//
//  Created by 王振 on 2016/12/1.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXHomeImpMsgBaseModel.h"
#import "GXHomeTextModel.h"
#import "GXHomeAudioModel.h"
#import "GXHomeVedioModel.h"

@implementation GXHomeImpMsgBaseModel

+(instancetype)modelWithDictionary:(NSDictionary *)dictionary{
    
    if ([dictionary[@"type"] isEqualToString:@"info"]) {
        GXHomeTextModel *textModel = [GXHomeTextModel new];
        [textModel setValuesForKeysWithDictionary:dictionary];
        textModel.sourceWidth = [GXAdaptiveHeightTool labelWidthFromString:textModel.tagName FontSize:13];
        return textModel;
    }else if ([dictionary[@"type"] isEqualToString:@"audio"]){
        GXHomeAudioModel *audioModel = [GXHomeAudioModel new];
        [audioModel setValuesForKeysWithDictionary:dictionary];
        audioModel.sourceWidth = [GXAdaptiveHeightTool labelWidthFromString:audioModel.tagName FontSize:13];
        return audioModel;
    }else{
        GXHomeVedioModel *videoModel = [GXHomeVedioModel new];
        [videoModel setValuesForKeysWithDictionary:dictionary];
        videoModel.sourceWidth = [GXAdaptiveHeightTool labelWidthFromString:videoModel.tagName FontSize:13];
        return videoModel;
    }
}
-(void)setValue:(id)value forKey:(NSString *)key{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
