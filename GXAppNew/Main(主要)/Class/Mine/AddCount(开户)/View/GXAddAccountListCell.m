//
//  GXAddAccountListCell.m
//  GXAppNew
//
//  Created by WangLinfang on 17/1/20.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXAddAccountListCell.h"

@implementation GXAddAccountListCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.backgroundColor=[UIColor colorWithHexString:@"E6E9F5"];
    [UIView setBorForView:self.view_bottom withWidth:0 andColor:nil andCorner:5];
    [UIView setBorForView:self.btn_next withWidth:0 andColor:nil andCorner:5];
    [self.btn_next setBtn_nextControlStateDisabled];
    self.backgroundColor=[UIColor colorWithHexString:@"E6E9F5"];
}
-(void)setModel:(GXMineBaseModel *)model
{
    GXAddAccountListModel*listModel=(GXAddAccountListModel*)model;
    self.label_name.text=listModel.title;
    self.label_content.text=listModel.subtitle;
    NSString*urlStr=[NSString stringWithFormat:@"http://%@",listModel.iconUrl];
    [self.img_logo sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    self.label_des.text=[NSString stringWithFormat:@"%@\n%@\n%@",listModel.banks,listModel.produces,listModel.requirement];
    if(!listModel.account.length)
    {
        [self.btn_next setTitle:@"立即开户" forState:UIControlStateNormal];
    }
    else
    {
        if([listModel.accountStatus isEqualToString:@"正常"])
        {
             [self.btn_next setTitle:@"查看账户详情" forState:UIControlStateNormal];
        }
        else
        {
            [self.btn_next setTitle:@"实盘账户已开立，待激活" forState:UIControlStateNormal];
        }
    }
}
#pragma mark--取消高亮
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
}
- (IBAction)btnClick_next:(UIButton *)sender {
    [self.delegate addAccountCellBtnDidTouchedWith:self.indexPath];
}


@end
