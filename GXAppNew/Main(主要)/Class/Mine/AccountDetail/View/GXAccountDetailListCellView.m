//
//  GXAccountDetailListCellView.m
//  GXAppNew
//
//  Created by shenqilong on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXAccountDetailListCellView.h"
#import "GXAccountDetailModel.h"
#import "AccountDetailConst.h"
#import <YYText/YYText.h>
#import "GXAccountDetailWebViewController.h"

@implementation GXAccountDetailListCellView
{
    GXAccountDetailModel *accModel;
    
    
    
}

#define tag_lb_number (161223)
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initModel:(GXAccountDetailModel *)model
{
    if (self = [super init]) {
        
        accModel=model;

        [self setModelUI:model];
        
    }
    return self;
}
-(void)setModelUI:(GXAccountDetailModel *)aModel
{
    
    self.backgroundColor=GXAccountDetailListCellView_color_backg;
    
    
    NSArray *titleAr;
    if([aModel.type isEqualToString:@"qiluce"])
    {
        titleAr=@[@"开立实盘账户",@"银行签约和入金",@"提交补充资料",@"审核",@"账户激活"];
        
    }else if([aModel.type isEqualToString:@"tjpme"])
    {
        titleAr=@[@"开立实盘账户",@"银行卡验证",@"银行签约和入金",@"审核",@"账户激活"];
    }else
    {
        titleAr=@[@"开立实盘账户",@"银行签约和入金",@"审核",@"账户激活"];
    }
    
    int y=25;
    
    UIImageView *lineimg=[[UIImageView alloc]initWithFrame:CGRectMake(15+13, 25, 0.5, 0)];
    lineimg.backgroundColor=GXAccountDetailListCellView_color_linebackg;
    [self addSubview:lineimg];
    
    
    for (int i=0; i<[titleAr count]; i++) {
        
        UILabel *lb_num=[[UILabel alloc]initWithFrame:CGRectMake(15, y, 26, 26)];
        lb_num.font=GXFONT_PingFangSC_Regular(18);
        lb_num.textAlignment=NSTextAlignmentCenter;
        lb_num.textColor=GXAccountDetailListCellView_color_numberText;
        lb_num.text=[NSString stringWithFormat:@"%d",i+1];
        lb_num.backgroundColor=GXAccountDetailListCellView_color_numberBackg;
        lb_num.layer.masksToBounds=YES;
        lb_num.layer.cornerRadius=13;
        lb_num.tag=tag_lb_number+i;
        [self addSubview:lb_num];
        
        
        UILabel *lb_tit=[[UILabel alloc]initWithFrame:CGRectMake(lb_num.frame.origin.x+lb_num.frame.size.width + 10, lb_num.frame.origin.y, 200, lb_num.frame.size.height)];
        lb_tit.font=GXFONT_PingFangSC_Medium(16);
        lb_tit.textAlignment=NSTextAlignmentLeft;
        lb_tit.textColor=GXAccountDetailListCellView_color_titleText;
        lb_tit.text=titleAr[i];
        [self addSubview:lb_tit];
        
        
        YYLabel *lb_detail=[[YYLabel alloc]init];
        lb_detail.textAlignment=NSTextAlignmentLeft;
        lb_detail.lineBreakMode = NSLineBreakByWordWrapping;
        lb_detail.numberOfLines = 0;
        [self addSubview:lb_detail];
        
        NSMutableAttributedString *lb_detailStr;
        if([aModel.type isEqualToString:@"qiluce"])
        {
            lb_detailStr=[self detailString_qilu:i];
        }else if([aModel.type isEqualToString:@"tjpme"])
        {
            lb_detailStr=[self detailString_tjpme:i];
        }else
        {
            lb_detailStr=[self detailString_sxbrme:i];
        }
        
        
        lb_detail.attributedText=lb_detailStr;
        
        
        CGSize size = CGSizeMake(GXScreenWidth-lb_tit.frame.origin.x-50, CGFLOAT_MAX);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:lb_detailStr];
        lb_detail.frame=CGRectMake(lb_tit.frame.origin.x, lb_tit.frame.origin.y+lb_tit.frame.size.height+3, layout.textBoundingSize.width, layout.textBoundingSize.height);
        
        
        y=lb_detail.frame.origin.y+lb_detail.frame.size.height+40;
    }
    
    CGRect f=lineimg.frame;
    f.size.height=y-f.origin.y-20;
    lineimg.frame=f;
    
    
//    UILabel *lb_end=[[UILabel alloc]init];
//    lb_end.font=GXFONT_PingFangSC_Regular(12);
//    lb_end.textColor=GXAccountDetailListCellView_color_endText;
//    lb_end.backgroundColor=[UIColor clearColor];
//    lb_end.text=@"END";
//    [lb_end sizeToFit];
//    lb_end.frame=CGRectMake(f.origin.x-lb_end.bounds.size.width/2.0, f.origin.y+f.size.height+5, lb_end.bounds.size.width, 20);
//    [self addSubview:lb_end];
    
    
    
    self.frame=CGRectMake(0, 0, GXScreenWidth, f.origin.y+f.size.height+20);
}

-(NSMutableAttributedString *)detailString_qilu:(int)index
{
    NSMutableAttributedString *text;
    
    if(index==0)
    {
        text= [[NSMutableAttributedString alloc] initWithString:@"注册开户获得实盘账号"] ;
    }
    else if (index==1)
    {
        text= [[NSMutableAttributedString alloc] initWithString:@"查看银行签约和入金指南\n网上开户支持：招商银行、工商银行、中信银行、建设银行"] ;
    }
    else if(index==2)
    {
        text= [[NSMutableAttributedString alloc] initWithString:@"提交手持身份证照片或语音确认函进行账号激活"] ;
    }
    else if (index==3)
    {
        text= [[NSMutableAttributedString alloc] initWithString:@"官方人员对您的资料进行审核，审核结果将会在24小时内通过电话通知"] ;
    }
    else if (index==4)
    {
        text= [[NSMutableAttributedString alloc] initWithString:@"完成账户激活进行交易"] ;
    }
    text.yy_font = GXFONT_PingFangSC_Regular(14);
    text.yy_color = GXAccountDetailListCellView_color_detailText;
    text.yy_lineSpacing = 1;
    
    if(index==1)
    {
        [self setyyText:text type:@"qilu"];
    }
    
    
    return text;
}

-(NSMutableAttributedString *)detailString_tjpme:(int)index
{
    NSMutableAttributedString *text;
    
    if(index==0)
    {
        text= [[NSMutableAttributedString alloc] initWithString:@"注册开户获得实盘账号"] ;
    }
    else if (index==1)
    {
        text= [[NSMutableAttributedString alloc] initWithString:@"完成开户银行银行卡验证"] ;
    }
    else if(index==2)
    {
        text= [[NSMutableAttributedString alloc] initWithString:@"查看银行签约和入金指南\n网上开户支持：招商银行、工商银行、中信银行、建设银行"] ;
    }
    else if (index==3)
    {
        text= [[NSMutableAttributedString alloc] initWithString:@"官方人员对您的资料进行审核，审核结果将会在24小时内通过电话通知"] ;
    }
    else if (index==4)
    {
        text= [[NSMutableAttributedString alloc] initWithString:@"完成账户激活进行交易"] ;
    }
    text.yy_font = GXFONT_PingFangSC_Regular(14);
    text.yy_color = GXAccountDetailListCellView_color_detailText;
    text.yy_lineSpacing = 1;

    if(index==2)
    {
        [self setyyText:text type:@"tjpme"];
    }
    
    
    return text;
}

-(NSMutableAttributedString *)detailString_sxbrme:(int)index
{
    NSMutableAttributedString *text;
    
    if(index==0)
    {
        text= [[NSMutableAttributedString alloc] initWithString:@"注册开户获得实盘账号"] ;
    }
    else if (index==1)
    {
        text= [[NSMutableAttributedString alloc] initWithString:@"查看线上签约指南或线下签约指南"] ;
    }
    else if (index==2)
    {
        text= [[NSMutableAttributedString alloc] initWithString:@"官方人员对您的资料进行审核，审核结果将会在24小时内通过电话通知"] ;
    }
    else if (index==3)
    {
        text= [[NSMutableAttributedString alloc] initWithString:@"完成账户激活进行交易"] ;
    }
    text.yy_font = GXFONT_PingFangSC_Regular(14);
    text.yy_color = GXAccountDetailListCellView_color_detailText;
    text.yy_lineSpacing = 1;
    
    if(index==1)
    {
        [self setyyText:text type:@"sxbrme"];
    }
    
    
    return text;
}

-(void)updateStatus:(GXAccountDetailModel *)newAccountModel
{
    GXAccountDetailModel *aModel=newAccountModel;
    
    accModel=newAccountModel;
    
    if([aModel.type isEqualToString:@"qiluce"])
    {
        if([aModel.accountStatus isEqualToString:@"已开户"]||[aModel.accountStatus isEqualToString:@"已签约"])
        {
            [self setNumLbBackNODone:1];
            
        }else if ([aModel.accountStatus isEqualToString:@"已入金"])
        {
            [self setNumLbBackNODone:2];
        }
    }
    else if([aModel.type isEqualToString:@"tjpme"])
    {
        if([aModel.accountStatus isEqualToString:@"已开户"]||[aModel.accountStatus isEqualToString:@"已签约"])
        {
            if([aModel.bankCardStatus intValue]==1)
            {
                [self setNumLbBackNODone:2];
            }else
            {
                [self setNumLbBackNODone:1];
            }
        }else if ([aModel.accountStatus isEqualToString:@"已入金"])
        {
            [self setNumLbBackNODone:3];
        }
    }else
    {
        if([aModel.accountStatus isEqualToString:@"已开户"])
        {
            [self setNumLbBackNODone:1];
            
        }
        else if([aModel.accountStatus isEqualToString:@"已签约"])
        {
            [self setNumLbBackNODone:2];
            
        }
    }
}

-(void)setNumLbBackNODone:(int)index
{
    for (int i=index; i<100; i++) {
        
        UILabel *lb_num=[self viewWithTag:tag_lb_number+i];
        if(!lb_num)
        {
            break;
        }
        lb_num.backgroundColor=GXAccountDetailListCellView_color_numberBackg_NODone;
    }
}

-(void)setyyText:(NSMutableAttributedString *)text type:(NSString *)type
{
    if([type isEqualToString:@"sxbrme"])
    {
        [text yy_setColor:GXAccountDetailListCellView_color_detailTextHighlight range:NSMakeRange(2, 6)];
        [text yy_setColor:GXAccountDetailListCellView_color_detailTextHighlight range:NSMakeRange(9, 6)];
        
        [text yy_setTextHighlightRange:NSMakeRange(2, 6)
                                 color:nil
                       backgroundColor:nil
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 
                                 GXAccountDetailWebViewController*detailVC=[[GXAccountDetailWebViewController alloc]init];
                                 detailVC.articleID=accModel.onlineSignHelpId;
                                 detailVC.title=@"线上签约指南";
                                 [self.vc.navigationController pushViewController:detailVC animated:YES];
                                 
                                 
                             }];
        [text yy_setTextHighlightRange:NSMakeRange(9, 6)
                                 color:nil
                       backgroundColor:nil
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 
                                 GXAccountDetailWebViewController*detailVC=[[GXAccountDetailWebViewController alloc]init];
                                 detailVC.articleID=accModel.offlineSignHelpId;
                                 detailVC.title=@"线下签约指南";
                                 [self.vc.navigationController pushViewController:detailVC animated:YES];
                             }];
        
    }else
    {
        [text yy_setColor:GXAccountDetailListCellView_color_detailTextHighlight range:NSMakeRange(2, 4)];
        [text yy_setColor:GXAccountDetailListCellView_color_detailTextHighlight range:NSMakeRange(7, 4)];
        [text yy_setTextHighlightRange:NSMakeRange(2, 4)
                                 color:nil
                       backgroundColor:nil
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 if([accModel.type isEqualToString:AccountTypeQilu])
                                 {
                                     [MobClick event:@"uc_qlsp_sign_contract"];
                                 }
                                 if([accModel.type isEqualToString:AccountTypeTianjin])
                                 {
                                     [MobClick event:@"uc_jgs_sign_contract"];
                                 }

                                 GXAccountDetailWebViewController*detailVC=[[GXAccountDetailWebViewController alloc]init];
                                 detailVC.articleID=accModel.signHelpId;
                                 detailVC.title=@"银行签约指南";
                                 [self.vc.navigationController pushViewController:detailVC animated:YES];
                                 
                                 
                             }];
        [text yy_setTextHighlightRange:NSMakeRange(7, 4)
                                 color:nil
                       backgroundColor:nil
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 
                                 GXAccountDetailWebViewController*detailVC=[[GXAccountDetailWebViewController alloc]init];
                                 detailVC.articleID=accModel.depositHelpId;
                                 detailVC.title=@"银行入金指南";
                                 [self.vc.navigationController pushViewController:detailVC animated:YES];
                             }];
    }
}

@end
