//
//  GXPriceListSelectExView.m
//  GXAppNew
//
//  Created by shenqilong on 16/12/15.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXPriceListSelectExView.h"
#import "PricePlatformModel.h"

#define tag_selectBtn 161215
@implementation GXPriceListSelectExView
{
    UIButton *selectBackgView;//黑色背景
    UIView *selectBtnView;//选择周期视图
    

}
@synthesize delegate;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithEXAr:(NSArray *)exAr {
    
    if (self = [super initWithFrame:CGRectMake(0, 64, GXScreenWidth, GXScreenHeight-64)]) {
        
        self.backgroundColor=[UIColor clearColor];
        self.hidden=YES;
        self.clipsToBounds=YES;
        
        selectBackgView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        selectBackgView.backgroundColor=[UIColor blackColor];
        selectBackgView.alpha=0;
        [selectBackgView addTarget:self action:@selector(closeV) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:selectBackgView];
        
        
        selectBtnView=[[UIView alloc]init];
        selectBtnView.backgroundColor=priceList_color_SelectExchangeViewBackg;
        [self addSubview:selectBtnView];
        
        float w=(GXScreenWidth-30)/3.0;
        float h=45;
        for (int i=0; i<[exAr count]+1; i++) {
            int x=i%3;
            int y=i/3;
            
            UIButton *seleBtn=[[UIButton alloc]initWithFrame:CGRectMake(15+x*w, y*h, w, h)];
            [seleBtn setTitleColor:priceList_color_SelectExchangeViewText forState:UIControlStateNormal];
            seleBtn.titleLabel.font=GXFONT_PingFangSC_Regular(16);
//            [seleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            seleBtn.tag=tag_selectBtn+i;
            [seleBtn addTarget:self action:@selector(selectBtnCLick:) forControlEvents:UIControlEventTouchUpInside];
            [selectBtnView addSubview:seleBtn];
            
            if(i==0)
            {
                [seleBtn setTitle:@"自选" forState:UIControlStateNormal];
                [seleBtn setTitleColor:priceAddCodeList_color_cellTitleTextSelect forState:UIControlStateNormal];
                
            }else
            {
                PricePlatformModel *model=exAr[i-1];
                [seleBtn setTitle:model.exname forState:UIControlStateNormal];
            }
            
            if(x==0 && y>0)
            {
                UIImageView *lineimg=[[UIImageView alloc]initWithFrame:CGRectMake(0, y*h, GXScreenWidth, 1)];
                lineimg.backgroundColor=priceList_color_SelectExchangeViewBackgLine;
                [selectBtnView addSubview:lineimg];
            }
            
            selectBtnView.frame=CGRectMake(0, -y*h-h, GXScreenWidth, y*h+h);
        }
                
    }
    return self;
}

-(void)setSelectExViewShow
{
    if(self.hidden)
    {
        self.hidden=NO;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect f=selectBtnView.frame;
            f.origin.y=0;
            selectBtnView.frame=f;
            
            selectBackgView.alpha=0.5;
        }];
        
        [delegate EXViewClose:NO];
        
    }else
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            CGRect f=selectBtnView.frame;
            f.origin.y=-f.size.height;
            selectBtnView.frame=f;
            
            selectBackgView.alpha=0;
            
        }completion:^(BOOL isf){
            
            self.hidden=YES;
        }];
        
        [delegate EXViewClose:YES];
    }
}

-(void)closeV
{
    [self setSelectExViewShow];
}

-(void)selectBtnCLick:(id)sender
{
    UIButton *bb=sender;
    [delegate selectBtnCLickIndex:bb.tag-tag_selectBtn];
    
    [self closeV];
    
    
    for (int i=0; i<100; i++) {
        UIButton *oldbtn=[self viewWithTag:tag_selectBtn+i];
        if(!oldbtn)
        {
            break;
        }
        [oldbtn setTitleColor:priceList_color_SelectExchangeViewText forState:UIControlStateNormal];
    }
    [bb setTitleColor:priceAddCodeList_color_cellTitleTextSelect forState:UIControlStateNormal];
}

@end
