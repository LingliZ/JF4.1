//
//  GXAccountDetailHeadView.m
//  GXAppNew
//
//  Created by shenqilong on 16/12/23.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXAccountDetailHeadView.h"
#import "GXAccountDetailModel.h"
#import "AccountDetailConst.h"
@implementation GXAccountDetailHeadView
{
    UIScrollView *imageScrollView;
    UIImageView *imageView;

    UILabel *lb_tit;
    UILabel *lb_acc;
    UILabel *lb_accStatus;
    UIButton *button;
    
}

#define buttonText_lijiqianyue @"立即签约"
#define buttonText_lijirujin @"立即入金"
#define buttonText_yanzhengyinhangka @"验证银行卡"
#define buttonText_tijiaoziliao @"提交资料"
#define buttonText_shenhezhong @"审核中"

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#define kDefaultHeaderFrame CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)

static CGFloat kParallaxDeltaFactor = 0.5f;

@synthesize delegate;

+ (id)parallaxHeaderViewWithCGSize:(CGSize)headerSize accountModel:(GXAccountDetailModel *)model
{
    GXAccountDetailHeadView *headerView = [[GXAccountDetailHeadView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    
    headerView.accountModel=model;

    [headerView initialSetup];
    
    return headerView;
}


- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset
{
    DLog(@"%f",offset.y);
    CGRect frame = imageScrollView.frame;
    
    if (offset.y > 0)
    {
        frame.origin.y = MAX(offset.y *kParallaxDeltaFactor, 0);
        imageScrollView.frame = frame;
        
        self.clipsToBounds = YES;
    }
    else
    {
        CGRect rect = kDefaultHeaderFrame;
     
        CGFloat delta = fabs(MIN(0.0f, offset.y));
        rect.origin.y -= delta;
        rect.size.height += delta;
        
        imageScrollView.frame = rect;
        self.clipsToBounds = NO;
        
                
        CGPoint p=imageScrollView.center;
        p.y +=delta;
        lb_tit.center=CGPointMake(p.x, p.y-10);
        
        [self setFrame_button_lb_acc];
        [self setFrame_lb_accStatus];
        [self setFrame_button];
    }
}

#pragma mark - Private

- (void)initialSetup
{
    GXAccountDetailModel *aModel=self.accountModel;
    
    if(!imageScrollView)
    {
        imageScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:imageScrollView];
        
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageScrollView addSubview:imageView];
    }
    imageView.image=[UIImage imageNamed:GXAccountDetailHeadView_backgImgName];
    
    
    if(!lb_tit)
    {
        lb_tit=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 20)];
        lb_tit.font=GXFONT_PingFangSC_Regular(18);
        lb_tit.textAlignment=NSTextAlignmentCenter;
        lb_tit.textColor=GXAccountDetailHeadView_color_textTit;
        [imageScrollView addSubview:lb_tit];
        
        lb_tit.center=CGPointMake(imageScrollView.center.x, imageScrollView.center.y-10) ;
    }
    lb_tit.text=self.accountModel.title;
    
    
    
    if(!lb_acc)
    {
        lb_acc=[[UILabel alloc]init];
        lb_acc.font=GXFONT_PingFangSC_Regular(16);
        lb_acc.textAlignment=NSTextAlignmentCenter;
        lb_acc.textColor=GXAccountDetailHeadView_color_textAcc;
        [imageScrollView addSubview:lb_acc];
    }
    lb_acc.text=[NSString stringWithFormat:@"实盘账户：%@",aModel.account];
    [lb_acc sizeToFit];
    [self setFrame_button_lb_acc];
    
    
    if(!lb_accStatus)
    {
        lb_accStatus=[[UILabel alloc]init];
        lb_accStatus.font=GXFONT_PingFangSC_Regular(11);
        lb_accStatus.textAlignment=NSTextAlignmentCenter;
        lb_accStatus.textColor=GXAccountDetailHeadView_color_textTit;
        lb_accStatus.layer.masksToBounds=YES;
        lb_accStatus.layer.cornerRadius=4;
        lb_accStatus.layer.borderWidth=1;
        lb_accStatus.layer.borderColor=GXAccountDetailHeadView_color_textTit.CGColor;
        [imageScrollView addSubview:lb_accStatus];
    }
    lb_accStatus.text=aModel.accountStatus;
    [self setFrame_lb_accStatus];
    
    
    if(!button)
    {
        button=[[UIButton alloc]init];
        button.layer.masksToBounds=YES;
        button.layer.cornerRadius=14;
        button.titleLabel.font=GXFONT_PingFangSC_Regular(14);
        [button setTitleColor:GXAccountDetailHeadView_color_buttonText forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [imageScrollView addSubview:button];
    }
    [self setFrame_button];
    
    
    
    
    button.hidden=NO;
    button.enabled=YES;
    button.backgroundColor=GXAccountDetailHeadView_color_buttonBackg;
    button.clipsToBounds=NO;
    if([aModel.accountStatus isEqualToString:@"已开户"])
    {
        if([aModel.bankCardStatus intValue]==1 || [aModel.type isEqualToString:@"sxbrme"])
        {
            [button setTitle:buttonText_lijiqianyue forState:UIControlStateNormal];
        }else
        {
            [button setTitle:buttonText_yanzhengyinhangka forState:UIControlStateNormal];
        }
    }
    else if ([aModel.accountStatus isEqualToString:@"已签约"])
    {
        if([aModel.bankCardStatus intValue]==1 || [aModel.type isEqualToString:@"sxbrme"])
        {
            if([aModel.type isEqualToString:@"sxbrme"])
            {
                [button setTitle:buttonText_shenhezhong forState:UIControlStateNormal];
                button.enabled=NO;

            }else
            {
                [button setTitle:buttonText_lijirujin forState:UIControlStateNormal];

            }
            
        }else
        {
            [button setTitle:buttonText_yanzhengyinhangka forState:UIControlStateNormal];
        }
    }
    else if ([aModel.accountStatus isEqualToString:@"已入金"])
    {
        if([aModel.type isEqualToString:@"qiluce"])
        {
            [button setTitle:buttonText_tijiaoziliao forState:UIControlStateNormal];
            button.enabled=NO;
            button.clipsToBounds=YES;
        }else
        {
            [button setTitle:buttonText_shenhezhong forState:UIControlStateNormal];
            button.enabled=NO;
        }
        
    }else
    {
        button.hidden=YES;
    }
    
}

-(void)setFrame_button_lb_acc
{
    lb_acc.frame=CGRectMake((CGRectGetWidth(self.frame) - lb_acc.bounds.size.width-10-46)/2.0, lb_tit.frame.origin.y+lb_tit.frame.size.height+10, lb_acc.bounds.size.width, 16);
}
-(void)setFrame_lb_accStatus
{
    lb_accStatus.frame= CGRectMake( lb_acc.frame.origin.x+lb_acc.frame.size.width+10,lb_acc.frame.origin.y, 46, 16);
}
-(void)setFrame_button
{
    button.frame= CGRectMake((GXScreenWidth-118)/2.0, lb_accStatus.frame.origin.y+lb_accStatus.frame.size.height+25, 118, 28);
}

-(void)buttonClick
{
    int index=0;
    if([button.titleLabel.text isEqualToString:buttonText_lijirujin]||[button.titleLabel.text isEqualToString:buttonText_lijiqianyue])
    {
        index=1;//去入金签约的中间页
    }
    
    if([button.titleLabel.text isEqualToString:buttonText_yanzhengyinhangka])
    {
        index=2;//去验证银行卡
    }
    
    if(index > 0)
    [delegate clickBottomButton:index];
}


@end
