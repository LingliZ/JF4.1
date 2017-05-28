//
//  GXMine_HomeCell.m
//  GXAppNew
//
//  Created by WangLinfang on 16/12/20.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXMine_HomeCell.h"

@implementation GXMine_HomeCell
{
    UISwitch *nightSwitch;
}
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
    self.btn_addAcount.layer.cornerRadius=5;
    self.btn_addAcount.layer.masksToBounds=YES;
    [self.btn_addAcount setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.btn_addAcount setBackgroundImage:ImageFromHex(@"FFFFFF") forState:UIControlStateDisabled];
    [self.btn_addAcount setTitle:@"系统维护" forState:UIControlStateDisabled];
    self.label_account.hidden=YES;
    
    self.label_title.dk_textColorPicker=DKColorPickerWithColors(RGBACOLOR(18, 29, 61, 1),RGBACOLOR(231, 231, 231, 1));
    self.label_account.dk_textColorPicker=DKColorPickerWithColors(RGBACOLOR(136, 142, 160, 1),RGBACOLOR(136, 142, 160, 1));
    
    self.dk_backgroundColorPicker=DKColorPickerWithColors([UIColor whiteColor],RGBACOLOR(45, 47, 59, 1));
    

}
-(void)setModel:(GXMineBaseModel *)model
{
    nightSwitch.hidden=YES;
    
    GXmine_HomeModel*homeModel=(GXmine_HomeModel*)model;
    if(self.indexPath.section==0)
    {
        self.img_next.hidden=YES;
        self.btn_addAcount.hidden=NO;
        if(self.indexPath.row==2)
        {
            self.btn_addAcount.enabled=NO;
        }
        if(homeModel.account.length)
        {
            if([homeModel.accountStatus isEqualToString:@"正常"]){
                self.btn_addAcount.hidden=YES;
                self.img_next.hidden=NO;
            }
            else
            {
                [self.btn_addAcount setTitle:@"继续开户" forState:UIControlStateNormal];
                self.label_account.hidden=YES;

            }
            
        }
        else
        {
            self.label_account.hidden=YES;
        }
    }
    if(self.indexPath.section==1)
    {
        self.btn_addAcount.hidden=YES;
        self.label_account.hidden=YES;
        self.img_next.hidden=NO;
        
        
        if(self.indexPath.row==2)
        {
            if(!nightSwitch)
            {
                nightSwitch=[[UISwitch alloc]init];
                nightSwitch.frame=CGRectMake(GXScreenWidth-10-nightSwitch.bounds.size.width,( WidthScale_IOS6(50)-nightSwitch.bounds.size.height)/2.0,nightSwitch.bounds.size.width , nightSwitch.bounds.size.height);
                [nightSwitch setOnTintColor:RGBACOLOR(84, 138, 237, 1)];
                [self addSubview:nightSwitch];
               
                [nightSwitch addTarget:self action:@selector(nightSwitch) forControlEvents:UIControlEventValueChanged];
            }
            self.img_next.hidden=YES;
            nightSwitch.hidden=NO;
            if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
                [nightSwitch setOn:YES];
            } else {
                [nightSwitch setOn:NO];
            }
        }
    }
    self.label_title.text=homeModel.name_title;
    self.label_account.text=homeModel.account;
    self.img_mark.dk_imagePicker=DKImagePickerWithImages([UIImage imageNamed:homeModel.name_markImg],[UIImage imageNamed:homeModel.name_markImg_night]) ;
}
- (IBAction)btnClick_Addcount:(UIButton *)sender {
    [self.delegate addCountBtnDidSelectedWithIndexPath:self.indexPath];
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
}

-(void)nightSwitch
{
    [MobClick event:@"night_mode_set"];
    if ([self.dk_manager.themeVersion isEqualToString:DKThemeVersionNight]) {
        [self.dk_manager dawnComing];
    } else {
        [self.dk_manager nightFalling];
    }
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}

@end
