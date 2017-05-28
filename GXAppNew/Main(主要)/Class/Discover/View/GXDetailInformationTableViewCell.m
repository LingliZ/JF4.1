//
//  GXDetailInformationTableViewCell.m
//  GXAppNew
//
//  Created by shenqilong on 17/1/4.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXDetailInformationTableViewCell.h"

@implementation GXDetailInformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.title.font=GXFONT_PingFangSC_Regular(15);
    self.detail.font=GXFONT_PingFangSC_Regular(13);
    
    self.title.textColor=RGBACOLOR(18, 29, 61, 1);
    self.detail.textColor=RGBACOLOR(161, 166, 187, 1);
    
    self.detail.numberOfLines=0;
    self.detail.lineBreakMode=NSLineBreakByWordWrapping;
}

-(void)setModel:(GXInformationModel *)model{
    if (_model != model) {
        _model = model;
        
        self.title.text=_model.title;
        self.detail.text=_model.metadesc;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
