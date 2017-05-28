//
//  GXPickerView.m
//  GXAppNew
//
//  Created by shenqilong on 17/2/11.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXPickerView.h"
#define ZHToobarHeight 40

@interface GXPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
{
    UIView *backView;
    
    UIToolbar *toolbar;
    
    NSArray *plistArray;
    
    UIPickerView *pickView;
    
    int selectIndex;
}



@end
@implementation GXPickerView
@synthesize delegate;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initPickviewWithArray:(NSArray *)array
{
    self=[super init];
    if (self) {
        plistArray=array;
        
        [self setToolbarStyle];

        
        pickView=[[UIPickerView alloc] init];
        pickView.backgroundColor=RGBACOLOR(243, 243, 243, 1);
        pickView.delegate=self;
        pickView.dataSource=self;
        pickView.frame=CGRectMake(0, ZHToobarHeight, GXScreenWidth, pickView.frame.size.height);
        [self addSubview:pickView];
        
        [self setFrameWith];
    }
    return self;
}

-(void)setToolbarStyle{
    
    
    toolbar=[[UIToolbar alloc] init];
    toolbar.backgroundColor=[UIColor whiteColor];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(10, 0, 50, ZHToobarHeight);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize15);
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[cancelBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [cancelBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    UIBarButtonItem *centerSpace=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UILabel *chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake((GXScreenWidth - 100), 0, 100, ZHToobarHeight)];
    chooseLabel.text = @"";
    chooseLabel.textAlignment = NSTextAlignmentCenter;
    UIBarButtonItem *centerSpace1 = [[UIBarButtonItem alloc]initWithCustomView:chooseLabel];
    //UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneClick)];
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    doneBtn.frame = CGRectMake(GXScreenWidth - 60, 0, 50, ZHToobarHeight);
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = GXFONT_PingFangSC_Regular(GXFitFontSize15);
    [doneBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[cancelBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [doneBtn addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    toolbar.items=@[leftItem,centerSpace,centerSpace1,centerSpace ,rightItem];
    
    
    toolbar.frame=CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width , ZHToobarHeight);
    toolbar.barTintColor = [UIColor whiteColor];
    [self addSubview:toolbar];

}

-(void)setFrameWith{
    CGFloat toolViewX = 0;
    CGFloat toolViewH = pickView.frame.size.height+ZHToobarHeight;
    CGFloat toolViewY ;
    toolViewY= [UIScreen mainScreen].bounds.size.height-toolViewH;

    CGFloat toolViewW = [UIScreen mainScreen].bounds.size.width;
    self.frame = CGRectMake(toolViewX, toolViewY, toolViewW, toolViewH);
}

#pragma mark piackView 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return plistArray.count;
}

#pragma mark UIPickerViewdelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
   
    return plistArray[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    selectIndex=(int)row;
}


-(void)show{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    backView = [[UIView alloc]initWithFrame:screenRect];
    
    //self.backView.backgroundColor=[UIColor colorWithRed:103.0/255.0 green:104.0/255.0 blue:106.0/255.0 alpha:.5];
    backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    [GXKeyWindow addSubview:backView];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
}
-(void)remove{
    
    [self removeFromSuperview];
    [backView removeFromSuperview];
}
-(void)doneClick
{
    if ([delegate respondsToSelector:@selector(GXPickerViewDonBtnHaveClick:resultIndex:resultString:)]) {
        
        if([plistArray count]==0)
        {
            [delegate GXPickerViewDonBtnHaveClick:self resultIndex:selectIndex resultString:@""];
        }
        else
        [delegate GXPickerViewDonBtnHaveClick:self resultIndex:selectIndex resultString:plistArray[selectIndex]];
    }
    [self removeFromSuperview];
    [backView removeFromSuperview];
}

@end
