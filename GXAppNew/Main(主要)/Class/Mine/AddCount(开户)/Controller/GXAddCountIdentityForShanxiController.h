//
//  GXAddCountIdentityForShanxiController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/1/24.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXMineBaseViewController.h"
#import "GXSignAgreementController.h"
#import "GXPickerImageController.h"
@interface GXAddCountIdentityForShanxiController : GXMineBaseViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate>


@property (weak, nonatomic) IBOutlet GXMineBaseTextField *TF_userName;
@property (weak, nonatomic) IBOutlet GXMineBaseTextField *TF_IDCardNum;

@property (weak, nonatomic) IBOutlet UIImageView *img_front;
@property (weak, nonatomic) IBOutlet UIImageView *img_behind;

@property (weak, nonatomic) IBOutlet UIButton *btn_uploadFront;

@property (weak, nonatomic) IBOutlet UIButton *btn_uploadBehind;

@property (weak, nonatomic) IBOutlet UIButton *btn_next;



@end
