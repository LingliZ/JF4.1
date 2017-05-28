//
//  GXsxbrmeSignSelectBankView.m
//  GXAppNew
//
//  Created by shenqilong on 17/2/10.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXsxbrmeSignSelectBankView.h"

@implementation GXsxbrmeSignSelectBankView
{
    NSArray *dataAr1;
    NSArray *dataAr2;
    
    UIButton *seleBtn1;
    UIButton *seleBtn2;
    UIImageView *seleBtnImg;
    
    UIView *bankNameView;
}
#define cellHeight 45
#define tag_imgV 12412
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize delegate;
-(void)setBankData:(NSArray *)ar
{
    if([ar count]<2)
    {
        return;
    }
    
    self.backgroundColor=[UIColor whiteColor];

    dataAr1=[GXMineBankModel mj_objectArrayWithKeyValuesArray:ar[0]];
    dataAr2=[GXMineBankModel mj_objectArrayWithKeyValuesArray:ar[1]];


    
    
    seleBtn1=[[UIButton alloc]initWithFrame:CGRectMake(GXScreenWidth/2.0, 0, GXScreenWidth/2.0, cellHeight)];
    [seleBtn1 setTitle:@"中国银联" forState:UIControlStateNormal];
    [seleBtn1 setTitleColor:RGBACOLOR(0, 122, 255, 1) forState:UIControlStateNormal];
    seleBtn1.titleLabel.font=GXFONT_PingFangSC_Regular(13);
//    [seleBtn1 addTarget:self action:@selector(seleBtn1) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:seleBtn1];
    
    seleBtn2=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth/2.0, cellHeight)];
    [seleBtn2 setTitle:@"浙商银行" forState:UIControlStateNormal];
    [seleBtn2 setTitleColor:RGBACOLOR(0, 0,0, 1) forState:UIControlStateNormal];
    seleBtn2.titleLabel.font=GXFONT_PingFangSC_Regular(13);
//    [seleBtn2 addTarget:self action:@selector(seleBtn2) forControlEvents:UIControlEventTouchUpInside];
    seleBtn2.selected=YES;
    [self addSubview:seleBtn2];
    
    
    //暂时设置
    [seleBtn1 setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5]  forState:UIControlStateNormal];
    [seleBtn2 setTitleColor:RGBACOLOR(0, 122, 255, 1) forState:UIControlStateNormal];


    
    seleBtnImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 2)];
    seleBtnImg.backgroundColor=RGBACOLOR(0, 122, 255, 1);
    [self addSubview:seleBtnImg];
    seleBtnImg.center=CGPointMake(GXScreenWidth/4.0, cellHeight-1);
    
    
    
    
    [self setLineImg:0 y:cellHeight];
    

    
    
    [self setimgview:dataAr2];
}

-(void)setLineImg:(int)x y:(int)y
{
    UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(x, y, GXScreenWidth-x, 0.5)];
    line.backgroundColor=RGBACOLOR(200, 199, 204, 1);
    [self addSubview:line];
}

-(void)seleBtn1
{
    seleBtn1.selected=YES;
    [seleBtn1 setTitleColor:RGBACOLOR(0, 122, 255, 1) forState:UIControlStateNormal];

    seleBtn2.selected=NO;
    [seleBtn2 setTitleColor:RGBACOLOR(0, 0, 0, 1) forState:UIControlStateNormal];

    [UIView animateWithDuration:0.2 animations:^{
        seleBtnImg.center=CGPointMake(GXScreenWidth/4.0, cellHeight-1);
    }];

    
    
    [self setimgview:dataAr1];
}

-(void)seleBtn2
{
    seleBtn2.selected=YES;
    [seleBtn2 setTitleColor:RGBACOLOR(0, 122, 255, 1) forState:UIControlStateNormal];
    
    seleBtn1.selected=NO;
    [seleBtn1 setTitleColor:RGBACOLOR(0, 0, 0, 1) forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.2 animations:^{
        seleBtnImg.center=CGPointMake(GXScreenWidth*3/4.0, cellHeight-1);
    }];
    
    
    
    [self setimgview:dataAr2];
}

-(void)setimgview:(NSArray *)ar
{
    if(bankNameView)
    {
        [bankNameView removeFromSuperview];
        bankNameView=nil;
    }
    float  height=ceilf([ar count]/2.0)*cellHeight;
    
    bankNameView=[[UIView alloc]initWithFrame:CGRectMake(0, cellHeight, GXScreenWidth, height)];
    [self addSubview:bankNameView];
    
    
    for (int i=0; i<[ar count]; i++) {
        
        int x=i%2;
        int y=i/2;
        
        GXMineBankModel *model=ar[i];
        
        UIImageView *imgv=[[UIImageView alloc]initWithFrame:CGRectMake(15 + x*GXScreenWidth/2.0, 7.5+ y*cellHeight, GXScreenWidth/2.0-30, 30)];
        [imgv sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@""] options:0];
        imgv.contentMode=1;
        imgv.tag=tag_imgV+i;
        [bankNameView addSubview:imgv];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImgView:)];
        imgv.userInteractionEnabled=YES;
        [imgv addGestureRecognizer:tap];
        
        if(x==0)
        {
            UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(GXScreenWidth/2.0, y*cellHeight + 10, 0.5, 25)];
            line.backgroundColor=RGBACOLOR(234, 234, 234, 1);
            [bankNameView addSubview:line];
            
            
            UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(15,cellHeight+ y*cellHeight, GXScreenWidth-15, 0.5)];
            line2.backgroundColor=RGBACOLOR(200, 199, 204, 1);
            [bankNameView addSubview:line2];
        }
        
    }
    
    self.frame=CGRectMake(0, 0, GXScreenWidth, bankNameView.frame.size.height+cellHeight);
    [self.listab reloadData];
}

-(void)tapImgView:(UITapGestureRecognizer *)tap
{
    UIImageView* view=(UIImageView*)tap.view;
    DLog(@"%ld",view.tag-tag_imgV);
    
    
    if(seleBtn1.selected)
    {
        if(view.tag-tag_imgV < [dataAr1 count])
            [delegate GXsxbrmeSignSelectBankViewDelegate_clickModel:dataAr1[view.tag-tag_imgV]];
    }else if (seleBtn2.selected)
    {
        if(view.tag-tag_imgV < [dataAr2 count])
            [delegate GXsxbrmeSignSelectBankViewDelegate_clickModel:dataAr2[view.tag-tag_imgV]];
    }
    
    
    
}

@end
