//
//  GXPickerImageController.h
//  GXAppNew
//
//  Created by WangLinfang on 17/3/1.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#pragma mark--简介及使用说明
/*
 对相册读取和拍照完成了进一步封装，包括弹窗提醒等等
 使用
    GXPickerImageController*pickerVC=[[GXPickerImageController alloc]init];
    pickerVC.view.backgroundColor=[UIColor clearColor];//（一定要提前设置背景颜色为透明）
    pickerVC.resultImage=^(NSData*imageData){
        //对imageData进行操作
    };
    [self presentViewController:pickerVC animated:NO completion:nil];
  */

#import <UIKit/UIKit.h>

typedef void (^myBlocks)(NSData*imageData);
@interface GXPickerImageController : UIViewController<UIImagePickerControllerDelegate,UIActionSheetDelegate>
@property(nonatomic,copy)myBlocks resultImage;
@end




