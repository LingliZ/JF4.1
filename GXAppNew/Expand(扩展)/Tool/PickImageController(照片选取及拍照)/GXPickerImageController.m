//
//  GXPickerImageController.m
//  GXAppNew
//
//  Created by WangLinfang on 17/3/1.
//  Copyright © 2017年 futang yang. All rights reserved.
//

#import "GXPickerImageController.h"

@interface GXPickerImageController ()

@end

@implementation GXPickerImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStyle=UIModalPresentationCustom;
    [self startPickImage];
}
-(void)startPickImage
{
    UIActionSheet*actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册选择",@"拍照", nil];
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从手机相册获取", nil];
    }
    actionSheet.tag=100;
    [actionSheet showInView:self.view];
}
#pragma mark--UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        //相册
        [self setHeadImageWithSouceType:UIImagePickerControllerSourceTypePhotoLibrary];
        return;
    }
    if(buttonIndex==1)
    {
        //拍照
        [self setHeadImageWithSouceType:UIImagePickerControllerSourceTypeCamera];
        return;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)setHeadImageWithSouceType:(UIImagePickerControllerSourceType)souceType
{
    UIImagePickerController*imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.delegate=self;
    imagePicker.allowsEditing=YES;
    imagePicker.sourceType=souceType;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark--UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage*image=[info objectForKey:UIImagePickerControllerEditedImage];
    NSData*imageData=UIImageJPEGRepresentation(image,0.1);//压缩图片
    self.resultImage(imageData);
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}


@end
