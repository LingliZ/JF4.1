//
//  GXMine_HeadView_Login.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/19.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMine_HeadView_Login.h"

@implementation GXMine_HeadView_Login

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [super awakeFromNib];
    [self createUI];
}
-(void)createUI
{
    [UIView setBorForView:self.img_head withWidth:0 andColor:nil andCorner:self.img_head.frame.size.width/2.0];
    UIImageView*img_edite=[[UIImageView alloc]init];
    img_edite.image=[UIImage imageNamed:@"mine_editUserInfo"];
    [self addSubview:img_edite];
    [img_edite mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@22);
        make.width.mas_equalTo(@22);
        make.centerX.mas_equalTo(@33);
        make.bottom.mas_equalTo(@(-58));
    }];
}
-(void)setModel:(GXMineBaseModel *)model
{
    GXUserInfoModel*infoModel=(GXUserInfoModel*)model;
    if(infoModel.nickname.length)
    {
        self.label_title.text=infoModel.nickname;
    }
    else
    {
        self.label_title.text=@"未设置昵称";
    }
    [self.img_head sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseImageUrl,infoModel.avatar]] placeholderImage:[UIImage imageNamed:@"mine_head_placeholder"]];
}
- (IBAction)btnClick_seeCustomInfo:(UIButton *)sender {
    self.seeCustomInfo();
}
@end
