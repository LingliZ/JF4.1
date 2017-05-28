//
//  DealLoginViewController.h
//  oser
//
//  Created by SHUPAI on 14-8-11.
//
//

#import <UIKit/UIKit.h>

@class DealLoginViewController;

@protocol DealBackDelegate<NSObject>

- (void)buttonBack:(DealLoginViewController *)dealLoginViewController;
- (void)exchangePicture;

@end


@interface DealLoginViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,assign)id<DealBackDelegate>delegate;

- (void)registerListeningDeviceOriention;

@end
