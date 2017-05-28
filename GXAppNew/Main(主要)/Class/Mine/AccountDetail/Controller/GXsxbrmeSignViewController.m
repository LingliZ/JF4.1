//
//  GXsxbrmeSignViewController.m
//  GXAppNew
//
//  Created by shenqilong on 17/2/9.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXsxbrmeSignViewController.h"
#import "GXAccountDetailModel.h"
#import "GXsxbrmeSignHeadView.h"
#import "GXsxbrmeSignTableViewCell.h"
#import "GXsxbrmeSignSelectBankView.h"
#import "GXMineBankModel.h"
#import <YYText/YYText.h>
#import "GXPickerView.h"
#import "GXsxbrmeSignSuccessViewController.h"
#import "GXHelpItemDetailController.h"

#define jsonDataKey_customerNo @"customerNo"
#define jsonDataKey_province @"provinceName"
#define jsonDataKey_city @"cityName"
#define jsonDataKey_bankPhone @"phoneNo"
#define jsonDataKey_PhoneYZM @"verifyCode"


#define jsonDataKey_bankName @"bankName"
#define jsonDataKey_bankNum @"bankAccNo"
#define jsonDataKey_bankValue @"bankCode"
#define jsonDataKey_bankBranch @"bankBranch"
#define jsonDataKey_bankBranchNum @"bankBranchNum"

#define jsonDataKey_signType @"signType"
#define jsonDataKey_payType @"payType"
#define jsonDataKey_payTypeValue @"payTypeValue"

#define jsonDataKey_provinceCode @"provinceCode"
#define jsonDataKey_cityCode @"cityCode"



@interface GXsxbrmeSignViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    GXAccountDetailModel *accModel;
    
    UITableView *listmenu;
    
    
    BOOL isOpen;
    
    NSArray *dataAr;
    
    GXsxbrmeSignSelectBankView *selectBankV;

    UIView *signView;
    
    GXPickerView *pickV;
    
    NSArray *provinceAr;
    NSArray *cityAr;
    NSArray *zhihangAr;
    
    UIButton *shengfenButton;
    UIButton *shiquButton;
    UIButton *zhihangButton;
    UITextField *tf_phone;
    UITextField *tf_bankNum;
    UITextField *tf_phoneYZM;
    UIButton *yzmButton;

    UIButton *signButton;
    
    NSMutableDictionary *jsonDic;
    
}
@end

@implementation GXsxbrmeSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor whiteColor];
    
    self.title=@"签约";
    
}

-(void)setAccountDetailModel:(GXAccountDetailModel *)accountModel
{
    accModel=accountModel;
    
    
    listmenu=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight-64) style:UITableViewStylePlain];
    listmenu.dataSource=self;
    listmenu.delegate=self;
    listmenu.separatorStyle = UITableViewCellSeparatorStyleNone;
    listmenu.backgroundColor=RGBACOLOR(241, 242, 247, 1);
    [self.view addSubview:listmenu];
    

    
    //签约数据json
    jsonDic=[[NSMutableDictionary alloc]init];
    
    
    
    
    //头
    GXsxbrmeSignHeadView *headerView = [GXsxbrmeSignHeadView parallaxHeaderViewWithCGSize:CGSizeMake(listmenu.frame.size.width, 85)accountModel:accountModel];
    [listmenu setTableHeaderView:headerView];
    [listmenu reloadData];

   
    
    
    [self.view showLoadingWithTitle:@"加载中"];
    [GXHttpTool POST:@"/bank-list" parameters:@{@"type":@"sxbrme"} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            if([responseObject[@"value"] count]>=2)
            {
                dataAr= responseObject[@"value"];
                
                
                isOpen=YES;
                
                //建立签约视图
                [self setqianyueView:0];
                
                
                //建立选择银行视图
                selectBankV=[[GXsxbrmeSignSelectBankView alloc]init];
                selectBankV.listab=listmenu;
                selectBankV.delegate=(id)self;
                [selectBankV setBankData:dataAr];
            }
        }
        
        
        [self.view removeTipView];
        
    }failure:^(NSError *error) {if(error.code!=-999){
            
            [self.view removeTipView];
        }
    }];
    
}

-(void)setqianyueView:(int)type
{
    if(signView)
    {
        [signView removeFromSuperview];
        signView=nil;
    }
    
    signView=[[UIView alloc]init];
    signView.backgroundColor=[UIColor clearColor];
    
    
    int h=0;
    
    if(type==0)
    {
        h=0;
    }
    else
    {
        UIView *bankNumBackV=[[UIView alloc]init];
        bankNumBackV.backgroundColor=[UIColor whiteColor];
        [signView addSubview:bankNumBackV];
        
        if(type==1)
        {
            bankNumBackV.frame=CGRectMake(0, 0, GXScreenWidth, 45*2);
        }else if(type==2)
        {
            bankNumBackV.frame=CGRectMake(0, 0, GXScreenWidth, 45*3);
        }else {
            bankNumBackV.frame=CGRectMake(0, 0, GXScreenWidth, 45);
        }
        
        
        
        UILabel *tit=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 100, 45)];
        tit.font=GXFONT_PingFangSC_Regular(15);
        tit.textColor=RGBACOLOR(0, 0, 0, 1);
        tit.text=@"银行卡号";
        [bankNumBackV addSubview:tit];

        
        tf_bankNum=[[UITextField alloc]initWithFrame:CGRectMake(90, 0, GXScreenWidth-90-15, 45)];
        tf_bankNum.delegate=(id)self;
        
        NSAttributedString *str=[[NSAttributedString alloc]initWithString:@"请输入储蓄卡号" attributes:@{NSFontAttributeName : GXFONT_PingFangSC_Regular(14), NSForegroundColorAttributeName:RGBACOLOR(161, 166, 187, 1)}];
        tf_bankNum.attributedPlaceholder=str;
        
        tf_bankNum.font=GXFONT_PingFangSC_Regular(14);
        tf_bankNum.textAlignment=NSTextAlignmentLeft;
        tf_bankNum.textColor=[UIColor blackColor];
        tf_bankNum.clearButtonMode = UITextFieldViewModeAlways;
        [tf_bankNum setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [tf_bankNum setBorderStyle:UITextBorderStyleNone];
        [tf_bankNum setKeyboardType:UIKeyboardTypeNumberPad];
        [tf_bankNum setReturnKeyType:UIReturnKeyDone];
        [bankNumBackV addSubview:tf_bankNum];
        
        
        if(type==1 || type==2) {
            UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(15, 44, GXScreenWidth, 0.5)];
            line1.backgroundColor=RGBACOLOR(200, 199, 204, 1);
            [bankNumBackV addSubview:line1];
            
            
            h=45;
            
            
            shengfenButton=[[UIButton alloc]initWithFrame:CGRectMake(15, h, (GXScreenWidth-45)*2/3.0, 45)];
            [shengfenButton setTitle:@"(开户行所在地)省份" forState:UIControlStateNormal];
            [shengfenButton setTitleColor:RGBACOLOR(161, 166, 187, 1) forState:UIControlStateNormal];
            shengfenButton.titleLabel.font=GXFONT_PingFangSC_Regular(15);
            [shengfenButton addTarget:self action:@selector(shengfenButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [shengfenButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [bankNumBackV addSubview:shengfenButton];
            
            UIImageView *arrowimgshengfen=[[UIImageView alloc]initWithFrame:CGRectMake(shengfenButton.frame.origin.x+shengfenButton.frame.size.width-15-15, h+15, 15, 15)];
            arrowimgshengfen.image=[UIImage imageNamed:@"mine_down_little"];
            [bankNumBackV addSubview:arrowimgshengfen];
            
            
            
            UIImageView *lineLittle=[[UIImageView alloc]initWithFrame:CGRectMake(shengfenButton.frame.origin.x+shengfenButton.frame.size.width,h+ 10, 0.5, 25)];
            lineLittle.backgroundColor=RGBACOLOR(234, 234, 234, 1);
            [bankNumBackV addSubview:lineLittle];
            
            
            shiquButton=[[UIButton alloc]initWithFrame:CGRectMake(shengfenButton.frame.origin.x+shengfenButton.frame.size.width +15, h, (GXScreenWidth-45)/3.0, 45)];
            [shiquButton setTitle:@"市区" forState:UIControlStateNormal];
            [shiquButton setTitleColor:RGBACOLOR(161, 166, 187, 1) forState:UIControlStateNormal];
            shiquButton.titleLabel.font=GXFONT_PingFangSC_Regular(15);
            [shiquButton addTarget:self action:@selector(shiquButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [shiquButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            [bankNumBackV addSubview:shiquButton];
            
            
            UIImageView *arrowimgshiqu=[[UIImageView alloc]initWithFrame:CGRectMake(shiquButton.frame.origin.x+shiquButton.frame.size.width-15, h+15, 15, 15)];
            arrowimgshiqu.image=[UIImage imageNamed:@"mine_down_little"];
            [bankNumBackV addSubview:arrowimgshiqu];
            
            if(type==1)
            {
                UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(0,h+ 44, GXScreenWidth, 0.5)];
                line2.backgroundColor=RGBACOLOR(200, 199, 204, 1);
                [bankNumBackV addSubview:line2];
                
                
                h=45*2 +20;
                
            }else
            {
                UIImageView *line2=[[UIImageView alloc]initWithFrame:CGRectMake(15,h+ 44, GXScreenWidth-30, 0.5)];
                line2.backgroundColor=RGBACOLOR(200, 199, 204, 1);
                [bankNumBackV addSubview:line2];
                
                
                zhihangButton=[[UIButton alloc]initWithFrame:CGRectMake(15, h+45, GXScreenWidth-30, 45)];
                [zhihangButton setTitle:@"选择开户银行支行" forState:UIControlStateNormal];
                [zhihangButton setTitleColor:RGBACOLOR(161, 166, 187, 1) forState:UIControlStateNormal];
                zhihangButton.titleLabel.font=GXFONT_PingFangSC_Regular(15);
                [zhihangButton addTarget:self action:@selector(zhihangButtonClick) forControlEvents:UIControlEventTouchUpInside];
                [zhihangButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
                [bankNumBackV addSubview:zhihangButton];
                
                
                UIImageView *line2_2=[[UIImageView alloc]initWithFrame:CGRectMake(0,zhihangButton.frame.origin.y+zhihangButton.frame.size.height-1, GXScreenWidth, 0.5)];
                line2_2.backgroundColor=RGBACOLOR(200, 199, 204, 1);
                [bankNumBackV addSubview:line2_2];
                
                
                h=45*3 +20;
            }
        }
        else {
            UIImageView *line1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 44, GXScreenWidth, 0.5)];
            line1.backgroundColor=RGBACOLOR(200, 199, 204, 1);
            [bankNumBackV addSubview:line1];
            
            h=45 + 20;
        }
        
        UIView *bankPhoneBackV=[[UIView alloc]init];
        bankPhoneBackV.backgroundColor=[UIColor whiteColor];
        [signView addSubview:bankPhoneBackV];
        
        
        
       
        UILabel *tit2=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 45)];
        tit2.font=GXFONT_PingFangSC_Regular(15);
        tit2.textColor=RGBACOLOR(0, 0, 0, 1);
        tit2.text=@"银行预留手机号";
        [bankPhoneBackV addSubview:tit2];
        
        
        tf_phone=[[UITextField alloc]initWithFrame:CGRectMake(135, 0, GXScreenWidth-135-15, 45)];
        tf_phone.delegate=(id)self;
        
        NSAttributedString *str2=[[NSAttributedString alloc]initWithString:@"请输入预留手机号" attributes:@{NSFontAttributeName : GXFONT_PingFangSC_Regular(14), NSForegroundColorAttributeName:RGBACOLOR(161, 166, 187, 1)}];
        tf_phone.attributedPlaceholder=str2;
        
        tf_phone.font=GXFONT_PingFangSC_Regular(14);
        tf_phone.textAlignment=NSTextAlignmentLeft;
        tf_phone.textColor=[UIColor blackColor];
        tf_phone.clearButtonMode = UITextFieldViewModeAlways;
        [tf_phone setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [tf_phone setBorderStyle:UITextBorderStyleNone];
        [tf_phone setKeyboardType:UIKeyboardTypeNumberPad];
        [tf_phone setReturnKeyType:UIReturnKeyDone];
        [bankPhoneBackV addSubview:tf_phone];
        
        
        
        if(type==1)
        {
            bankPhoneBackV.frame=CGRectMake(0, h, GXScreenWidth, 45);
        }else
        {
            bankPhoneBackV.frame=CGRectMake(0, h, GXScreenWidth, 45*2);

            
            UIImageView *line=[[UIImageView alloc]initWithFrame:CGRectMake(0,45-1, GXScreenWidth, 0.5)];
            line.backgroundColor=RGBACOLOR(200, 199, 204, 1);
            [bankPhoneBackV addSubview:line];
            
            
            
            tf_phoneYZM=[[UITextField alloc]initWithFrame:CGRectMake(15, 45, GXScreenWidth-15-100, 45)];
            tf_phoneYZM.delegate=(id)self;
            
            NSAttributedString *str2=[[NSAttributedString alloc]initWithString:@"请输入验证码" attributes:@{NSFontAttributeName : GXFONT_PingFangSC_Regular(14), NSForegroundColorAttributeName:RGBACOLOR(161, 166, 187, 1)}];
            tf_phoneYZM.attributedPlaceholder=str2;
            
            tf_phoneYZM.font=GXFONT_PingFangSC_Regular(14);
            tf_phoneYZM.textAlignment=NSTextAlignmentLeft;
            tf_phoneYZM.textColor=[UIColor blackColor];
            tf_phoneYZM.clearButtonMode = UITextFieldViewModeAlways;
            [tf_phoneYZM setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
            [tf_phoneYZM setBorderStyle:UITextBorderStyleNone];
            [tf_phoneYZM setKeyboardType:UIKeyboardTypeNumberPad];
            [tf_phoneYZM setReturnKeyType:UIReturnKeyDone];
            [bankPhoneBackV addSubview:tf_phoneYZM];
            
            
            
            UIImageView *lineLittle=[[UIImageView alloc]initWithFrame:CGRectMake(tf_phoneYZM.frame.origin.x+tf_phoneYZM.frame.size.width,45+10, 0.5, 25)];
            lineLittle.backgroundColor=RGBACOLOR(234, 234, 234, 1);
            [bankPhoneBackV addSubview:lineLittle];
            
            
            
            
            yzmButton=[[UIButton alloc]initWithFrame:CGRectMake(GXScreenWidth-100, 45, 100, 45)];
            [yzmButton setTitle:@"获取验证码" forState:UIControlStateNormal];
            [yzmButton setTitleColor:RGBACOLOR(97, 151, 240, 1) forState:UIControlStateNormal];
            yzmButton.titleLabel.font=GXFONT_PingFangSC_Regular(12);
            [yzmButton addTarget:self action:@selector(yzmButtonClick) forControlEvents:UIControlEventTouchUpInside];
            [bankPhoneBackV addSubview:yzmButton];
            
        
        }
        [self.view setBorderWithView:bankPhoneBackV top:YES left:NO bottom:YES right:NO borderColor:RGBACOLOR(200, 199, 204, 1) borderWidth:0.5];

        
        h=bankPhoneBackV.frame.origin.y+bankPhoneBackV.frame.size.height;
        
        
        YYLabel *titTip=[[YYLabel alloc]init];
        titTip.textAlignment=NSTextAlignmentLeft;
        titTip.lineBreakMode = NSLineBreakByWordWrapping;
        titTip.numberOfLines = 0;
        titTip.font=GXFONT_PingFangSC_Regular(10);
        [signView addSubview:titTip];

        if(!accModel.signRequirement)
        {
            accModel.signRequirement=@"";
        }
        NSMutableAttributedString *titTipstr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n更多请查看：入金操作指南",accModel.signRequirement]] ;

        
        CGSize size = CGSizeMake(GXScreenWidth-30, CGFLOAT_MAX);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:titTipstr];
        titTip.frame=CGRectMake(15,h+10, GXScreenWidth-30, layout.textBoundingSize.height);

        [titTipstr yy_setColor:RGBACOLOR(161, 166, 187, 1) range:NSMakeRange(0, titTipstr.length-6)];

        [titTipstr yy_setColor:RGBACOLOR(64, 130, 244, 1) range:NSMakeRange(titTipstr.length-6, 6)];
        [titTipstr yy_setTextHighlightRange:NSMakeRange(titTipstr.length-6, 6)
                                 color:nil
                       backgroundColor:nil
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 
                                 GXHelpItemDetailController *vvv=[[GXHelpItemDetailController alloc]init];
                                 if(type==1)
                                 {
                                     vvv.urlStr=@"http://m.91guoxin.com/index/detail/i/63671.html";
                                 }else
                                 {
                                     vvv.urlStr=@"http://m.91guoxin.com/index/detail/i/63666.html";
                                 }
                                 vvv.title=@"入金操作指南";
                                 [self.navigationController pushViewController:vvv animated:YES];
                                 
                             }];

        titTip.attributedText=titTipstr;

        h=titTip.frame.origin.y+titTip.frame.size.height;
    }
    
    
    //建立签约按钮
    signButton=[[UIButton alloc]initWithFrame:CGRectMake(77, h+ 20, GXScreenWidth-77*2, 46)];
    signButton.backgroundColor=RGBACOLOR(194, 194, 194, 1);
    [signButton setTitle:@"立即签约" forState:UIControlStateNormal];
    [signButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    signButton.titleLabel.font=GXFONT_PingFangSC_Regular(16);
    [signButton addTarget:self action:@selector(signButtonClick) forControlEvents:UIControlEventTouchUpInside];
    signButton.enabled=NO;
    signButton.layer.masksToBounds=YES;
    signButton.layer.cornerRadius=6;
    
    [signView addSubview:signButton];
    
    
    signView.frame=CGRectMake(0, 0, GXScreenWidth, signButton.frame.size.height+signButton.frame.origin.y);
}
#pragma mark -

-(void)shengfenButtonClick
{
    [self.view showLoadingWithTitle:@"加载中"];
    [GXHttpTool POST:@"/province-list" parameters:@{@"type":@"sxbrme"} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            provinceAr=responseObject[@"value"];
            
            NSMutableArray *titar=[[NSMutableArray alloc]init];
            for (int i=0; i<[provinceAr count]; i++) {
                [titar addObject:[provinceAr[i] objectForKey:@"provinceName"]];
            }
            
            if(pickV)
            {
                [pickV remove];
                pickV=nil;
            }
            pickV =[[GXPickerView alloc] initPickviewWithArray:titar];
            pickV.delegate = (id)self;
            pickV.tag=1000;
            [pickV show];
        }
        
        
        [self.view removeTipView];
        
    }failure:^(NSError *error) {if(error.code!=-999){
        
        [self.view removeTipView];
    }
    }];
    
    [self.view endEditing:YES];

}

-(void)shiquButtonClick
{
    if(![jsonDic objectForKey:jsonDataKey_provinceCode])
    {
        return;
    }
    
    [self.view showLoadingWithTitle:@"加载中"];
    [GXHttpTool POST:@"/city-list" parameters:@{@"type":@"sxbrme",@"province":[jsonDic objectForKey:jsonDataKey_provinceCode]} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            cityAr=responseObject[@"value"];
            
            NSMutableArray *titar=[[NSMutableArray alloc]init];
            for (int i=0; i<[cityAr count]; i++) {
                [titar addObject:[cityAr[i] objectForKey:@"cityName"]];
            }
            
            if(pickV)
            {
                [pickV remove];
                pickV=nil;
            }
            pickV =[[GXPickerView alloc] initPickviewWithArray:titar];
            pickV.delegate = (id)self;
            pickV.tag=1001;
            [pickV show];
        }
        
        
        [self.view removeTipView];
        
    }failure:^(NSError *error) {if(error.code!=-999){
        
        [self.view removeTipView];
    }
    }];
    
    [self.view endEditing:YES];

}

-(void)zhihangButtonClick
{
    if(![jsonDic objectForKey:jsonDataKey_cityCode])
    {
        return;
    }
    
    [self.view showLoadingWithTitle:@"加载中"];
    [GXHttpTool POST:@"/get-bank-branch" parameters:@{@"type":@"sxbrme",@"bankCode":[jsonDic objectForKey:jsonDataKey_bankValue],@"cityCode":[jsonDic objectForKey:jsonDataKey_cityCode],@"bankType":[jsonDic objectForKey:jsonDataKey_signType]} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            zhihangAr=responseObject[@"value"];
            
            NSMutableArray *titar=[[NSMutableArray alloc]init];
            for (int i=0; i<[zhihangAr count]; i++) {
                [titar addObject:[zhihangAr[i] objectForKey:@"branchName"]];
            }
            
            if(pickV)
            {
                [pickV remove];
                pickV=nil;
            }
            pickV =[[GXPickerView alloc] initPickviewWithArray:titar];
            pickV.delegate = (id)self;
            pickV.tag=1002;
            [pickV show];
        }
        
        
        [self.view removeTipView];
        
    }failure:^(NSError *error) {if(error.code!=-999){
        
        [self.view removeTipView];
    }
    }];
    
    [self.view endEditing:YES];

}

-(void)yzmButtonClick
{
    [self.view endEditing:YES];
    
    if(!jsonDic[jsonDataKey_bankNum] || [jsonDic[jsonDataKey_bankNum] isEqualToString:@""]) {
        [self.view showErrorNetMsg:@"请输入银行卡号"];
        return;
    }
    if(!jsonDic[jsonDataKey_bankPhone] || [jsonDic[jsonDataKey_bankPhone] isEqualToString:@""]) {
        [self.view showErrorNetMsg:@"请输入预留手机号"];
        return;
    }
    
    [jsonDic removeObjectForKey:jsonDataKey_PhoneYZM];
    [jsonDic setObject:accModel.account forKey:jsonDataKey_customerNo];

    [self.view showLoadingWithTitle:@"加载中"];
    [GXHttpTool POST:@"/send-verify-code" parameters:@{@"type":@"sxbrme",@"signBankInfo":[jsonDic mj_JSONString]} success:^(id responseObject) {
        
        [self.view removeTipView];
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            [self.view showSuccessWithTitle:@"发送成功"];
        }else
        {
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
        
    }failure:^(NSError *error) {if(error.code!=-999){
        
        [self.view removeTipView];
        [self.view showErrorNetMsg:nil];
    }
    }];
    
    [self.view endEditing:YES];
}
#pragma mark -
-(void)GXPickerViewDonBtnHaveClick:(GXPickerView *)pickView resultIndex:(int)sIndex resultString:(NSString *)resultString
{
    DLog(@"%@,%d",resultString,sIndex);
    if(pickView.tag==1000)
    {
        [shengfenButton setTitle:resultString forState:UIControlStateNormal];
        [shengfenButton setTitleColor:RGBACOLOR(0,0, 0, 1) forState:UIControlStateNormal];
        [jsonDic setObject:provinceAr[sIndex][@"provinceName"] forKey:jsonDataKey_province];
        [jsonDic setObject:provinceAr[sIndex][@"provinceCode"] forKey:jsonDataKey_provinceCode];

        
        
        
        [shiquButton setTitle:@"市区" forState:UIControlStateNormal];
        [shiquButton setTitleColor:RGBACOLOR(161, 166, 187, 1) forState:UIControlStateNormal];
        [jsonDic removeObjectForKey:jsonDataKey_city];
        [jsonDic removeObjectForKey:jsonDataKey_cityCode];

        
        
        [zhihangButton setTitle:@"选择开户银行支行" forState:UIControlStateNormal];
        [zhihangButton setTitleColor:RGBACOLOR(161, 166, 187, 1) forState:UIControlStateNormal];
        [jsonDic removeObjectForKey:jsonDataKey_bankBranch];
        [jsonDic removeObjectForKey:jsonDataKey_bankBranchNum];

        
    }else if(pickView.tag==1001)
    {
        if([cityAr count]>0)
        {
            [shiquButton setTitle:resultString forState:UIControlStateNormal];
            [shiquButton setTitleColor:RGBACOLOR(0,0, 0, 1) forState:UIControlStateNormal];
            [jsonDic setObject:cityAr[sIndex][@"cityName"] forKey:jsonDataKey_city];
            [jsonDic setObject:cityAr[sIndex][@"cityCode"] forKey:jsonDataKey_cityCode];

            
            [zhihangButton setTitle:@"选择开户银行支行" forState:UIControlStateNormal];
            [zhihangButton setTitleColor:RGBACOLOR(161, 166, 187, 1) forState:UIControlStateNormal];
            [jsonDic removeObjectForKey:jsonDataKey_bankBranch];
            [jsonDic removeObjectForKey:jsonDataKey_bankBranchNum];

        }
        
    }
    else
    {
        if([zhihangAr count]>0)
        {
            [zhihangButton setTitle:resultString forState:UIControlStateNormal];
            [zhihangButton setTitleColor:RGBACOLOR(0,0, 0, 1) forState:UIControlStateNormal];
            [jsonDic setObject:zhihangAr[sIndex][@"branchName"] forKey:jsonDataKey_bankBranch];
            [jsonDic setObject:zhihangAr[sIndex][@"branchNum"] forKey:jsonDataKey_bankBranchNum];

        }
    }
    
    DLog(@"%@",jsonDic);
    [self signButtonState];

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    DLog(@"%@",textField.text);
    if(tf_phone==textField)
    {
        [jsonDic setObject:textField.text forKey:jsonDataKey_bankPhone];
        
    }else if(tf_bankNum==textField)
    {
        [jsonDic setObject:textField.text forKey:jsonDataKey_bankNum];
    }
    else if(tf_phoneYZM==textField)
    {
        [jsonDic setObject:textField.text forKey:jsonDataKey_PhoneYZM];
    }
    DLog(@"%@",jsonDic);
    [self signButtonState];

}

#pragma mark - tavleView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == listmenu)
    {
        [(GXsxbrmeSignHeadView *)listmenu.tableHeaderView layoutHeaderViewForScrollViewOffset:scrollView.contentOffset];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(isOpen)
    {
        return 2;
    }
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if([dataAr count]==0)
    {
        return 0;
    }
    
    if(section==0)
    {
        if(isOpen)
        {
            return 2;
        }
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==0&&isOpen&&indexPath.row!=0)
    {
        static NSString *CellIdentifier = @"bankCellTitle";
        
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        
        [cell.contentView addSubview:selectBankV];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
        
    }else if(indexPath.section==0 && indexPath.row==0)
    {
        static NSString *CellIdentifier = @"signTitle";
        
        GXsxbrmeSignTableViewCell *cell=(GXsxbrmeSignTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GXsxbrmeSignTableViewCell" owner:self options:nil] objectAtIndex:0];
        }
        
        [cell changeArrowWithUp:isOpen];
        
        if(cell.bankImgSelect.image)
        cell.bankNameText.text=@"";
        else
         cell.bankNameText.text=@"请选择银行进行签约";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"bankCellSignView";
        
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        
        [cell.contentView addSubview:signView];
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isOpen)
    {
        if(indexPath.section==0&&indexPath.row==1)
        return selectBankV.frame.size.height;
    }
    
    
    if(indexPath.section==1)
    {
        return signView.frame.size.height;
    }
    
    
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section==0&&indexPath.row==0)
    {
        if (isOpen)
        {
            DLog(@"open时候禁止关闭");
        }else
        {
            isOpen=YES;
            [self didSelectCellRowFirstDo:YES nextDo:NO  indexPath:indexPath];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setqianyueView:0];
                [listmenu reloadData];
            });
        }
    }else
    {
        GXLog(@"%ld",indexPath.row);
    }
    
    
    [self.view endEditing:YES];
}

- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert indexPath:(NSIndexPath *)indexPath
{
    
    GXsxbrmeSignTableViewCell *cell = (GXsxbrmeSignTableViewCell *)[listmenu cellForRowAtIndexPath:indexPath];
    [cell changeArrowWithUp:firstDoInsert];
   
    
    [listmenu beginUpdates];
    
    NSInteger section = indexPath.section;
    
    
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i < 1 + 1; i++) {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    
    if (firstDoInsert)
    {   [listmenu insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [listmenu deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationFade];
    }
    
    rowToInsert=nil;
    
    
    
    [listmenu endUpdates];
}


-(void)GXsxbrmeSignSelectBankViewDelegate_clickModel:(GXMineBankModel *)model
{
    DLog(@"%@",model);
    
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    GXsxbrmeSignTableViewCell *cell = (GXsxbrmeSignTableViewCell *)[listmenu cellForRowAtIndexPath:indexPath];
    
    DLog(@"%@",cell);
    cell.bankNameText.text=model.name;

    
    
    [cell.bankImgSelect sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@""] options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        cell.bankNameText.text=@"";
    }];
    cell.bankImgSelect.contentMode=1;
    
    
    
    isOpen=NO;
    [self didSelectCellRowFirstDo:NO nextDo:NO  indexPath:indexPath];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([model.payTypeValue intValue]==600)
        {
            [self setqianyueView:1];
        }else
        {
//            [self setqianyueView:2];
            [self setqianyueView:3];

        }
        
        [listmenu reloadData];
    });
    
    
    
    //储存数据，清空之前的银行卡信息和手机号省市
    [jsonDic removeAllObjects];
    [jsonDic setObject:model.value forKey:jsonDataKey_bankValue];
    [jsonDic setObject:model.name forKey:jsonDataKey_bankName];
    [jsonDic setObject:model.payTypeValue forKey:jsonDataKey_signType];
    
    
    DLog(@"%@",jsonDic);
    [self signButtonState];
}


-(void)signButtonClick
{
    [jsonDic setObject:accModel.account forKey:jsonDataKey_customerNo];

    DLog(@"签约按钮");
    DLog(@"%@",jsonDic);
    
    [MobClick event:@"uc_sxydyl_sign_contract"];
    [self.view showLoadingWithTitle:@"正在提交"];
    [GXHttpTool POST:@"/sign-bank" parameters:@{@"type":@"sxbrme",@"signBankInfo":[jsonDic mj_JSONString]} success:^(id responseObject) {
        
        if ([(NSNumber *)responseObject[@"success"] integerValue] == 1)
        {
            
            [self.view removeTipView];
            
            
            GXsxbrmeSignSuccessViewController *succ=[[GXsxbrmeSignSuccessViewController alloc]init];
            succ.value=responseObject[@"value"];
            succ.vc=self;
            succ.vc2=self.vc;
            [self.navigationController pushViewController:succ animated:YES];
        }else
        {
            [self.view removeTipView];
            [self.view showFailWithTitle:responseObject[@"message"]];
        }
        
        
        
    }failure:^(NSError *error) {if(error.code!=-999){
        
        [self.view removeTipView];
        [self.view showFailWithTitle:@"提交失败"];
    }
    }];
    
}

-(BOOL)signButtonState
{
    signButton.enabled=NO;
    signButton.backgroundColor=RGBACOLOR(194, 194, 194, 1);

    
    if([jsonDic[jsonDataKey_signType] intValue]==16)//浙商
    {
        if(!jsonDic[jsonDataKey_PhoneYZM] || [jsonDic[jsonDataKey_PhoneYZM] isEqualToString:@""])
        {
            return NO;
        }
        
        if(jsonDic[jsonDataKey_bankValue] && jsonDic[jsonDataKey_bankPhone] && jsonDic[jsonDataKey_bankNum])
        {
            if(![jsonDic[jsonDataKey_bankNum] isEqualToString:@""] && ![jsonDic[jsonDataKey_bankPhone] isEqualToString:@""])
            {
                signButton.backgroundColor=RGBACOLOR(83, 142, 235, 1);
                signButton.enabled=YES;
            }
        }
    }
    else {
        if(jsonDic[jsonDataKey_bankValue] && jsonDic[jsonDataKey_province] && jsonDic[jsonDataKey_city] && jsonDic[jsonDataKey_bankPhone] && jsonDic[jsonDataKey_bankNum])
        {
            if(![jsonDic[jsonDataKey_bankNum] isEqualToString:@""] && ![jsonDic[jsonDataKey_bankPhone] isEqualToString:@""])
            {
                signButton.backgroundColor=RGBACOLOR(83, 142, 235, 1);
                signButton.enabled=YES;
            }
        }
    }
    return signButton.enabled;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
