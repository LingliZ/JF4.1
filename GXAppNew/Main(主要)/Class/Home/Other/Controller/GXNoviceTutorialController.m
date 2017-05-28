//
//  GXNoviceTutorialController.m
//  Newbie guide tutorial
//
//  Created by 王振 on 2017/2/6.
//  Copyright © 2017年 wangzhen. All rights reserved.
//

#import "GXNoviceTutorialController.h"
#import "NoviceButton.h"


#define GXSCREENSIZE [UIScreen mainScreen].bounds.size
#define DEFAULTCORNERRADIUS (5.0f)


@interface GXNoviceTutorialController ()
@property (weak, nonatomic) IBOutlet NoviceButton *checkBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnH;

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIImageView *getImgView;
@property (nonatomic, strong) NSMutableArray *btnFramesArr;
@property (nonatomic, strong) NSMutableArray *imgFramesArr;
@property (nonatomic, strong) NSMutableArray *imagesArr;
@property (nonatomic, strong) NSMutableArray *stylesArr;
@end


@implementation GXNoviceTutorialController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (!self.btnFramesArr) {
        self.btnFramesArr = [self.btnFrames mutableCopy];
    }
    if (!self.imgFramesArr) {
        self.imgFramesArr = [self.imgFrames mutableCopy];
    }
    if (!self.imagesArr) {
        self.imagesArr = [self.images mutableCopy];
    }
    if (!self.stylesArr) {
        self.stylesArr = [self.styles mutableCopy];
    }
    [self resetBtnFrame];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelNewGuide) name:@"HomeCancelNewGuide" object:nil];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor clearColor];
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
    }
    return self;
}
- (IBAction)didClickBtnAction:(UIButton *)sender {
    [self resetBtnFrame];
}
- (void)resetBtnFrame{
    
    if (self.btnFramesArr.count>0 && self.imagesArr.count >0 && self.imgFramesArr.count > 0) {
        CGRect btnRect = CGRectFromString(self.btnFramesArr.firstObject);
        self.btnX.constant = btnRect.origin.x;
        self.btnY.constant = btnRect.origin.y;
        if (btnRect.size.width>0) {
            self.btnW.constant = WidthScale_IOS6(btnRect.size.width);
        }else{
            self.btnW.constant = 0;
        }
        if (btnRect.size.height>0) {
            self.btnH.constant = btnRect.size.height;
        }
        
   
        [self.view layoutIfNeeded];
        [self.btnFramesArr removeObjectAtIndex:0];
        
        CGRect imgRect = CGRectFromString(self.imgFramesArr.firstObject);
        NSString *styleStr = self.stylesArr.firstObject;
        
        self.checkBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
        
        if ([styleStr isEqualToString:@"GuideViewCleanModeCycleRect"]) {
            UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, GXScreenWidth, GXScreenHeight)];
            [path appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.checkBtn.width/2, self.checkBtn.height/2) radius:self.checkBtn.width/2 startAngle:0 endAngle:2*M_PI clockwise:NO]];
             CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.path = path.CGPath;
            self.checkBtn.layer.hidden = NO;
            [self.checkBtn.layer setMask:shapeLayer];
        }
        else if ([styleStr isEqualToString:@"GuideViewCleanModeRoundRect"]) {
            self.checkBtn.layer.hidden = YES;
        }
    
        
        self.imgView.image = [UIImage imageNamed:self.imagesArr.firstObject];
        self.getImgView.image = [UIImage imageNamed:@"newbie_guide_pic13"];
        CGFloat imgH = [self imageScaleHeightWith:self.imagesArr.firstObject];
        imgRect.size.height = imgH;
        [self resetSubViewsFrameWithImgFrame:imgRect];
        [self.imagesArr removeObjectAtIndex:0];
        [self.imgFramesArr removeObjectAtIndex:0];
        [self.stylesArr removeObjectAtIndex:0];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)resetSubViewsFrameWithImgFrame:(CGRect)frame{
    CGFloat imgX = frame.origin.x;
    CGFloat imgY = frame.origin.y;
    CGFloat imgW = GXScreenWidth;
    CGFloat imgH = frame.size.height;
    self.imgView.frame = CGRectMake(imgX, imgY, imgW, imgH);
    //剩余高度
    CGFloat moreH = GXScreenHeight - imgY - imgH;
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.getImgView];
    if (moreH >= 90) {
        [self.getImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.imgView.mas_bottom).offset(30);
            make.width.equalTo(@110);
            make.height.equalTo(@60);
        }];
    }else{
        [self.getImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.imgView.mas_top).offset(-90);
            make.width.equalTo(@110);
            make.height.equalTo(@60);
        }];
    }
    [self.view layoutIfNeeded];
}
-(void)cancelNewGuide{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc]init];
        _imgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetBtnFrame)];
        [_imgView addGestureRecognizer:tap];
    }
    return _imgView;
}
-(UIImageView *)getImgView{
    if (!_getImgView) {
        _getImgView = [[UIImageView alloc]init];
        _getImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resetBtnFrame)];
        [_getImgView addGestureRecognizer:tap];
    }
    return _getImgView;
}
- (CGFloat)imageScaleHeightWith:(NSString *)imageName{
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    return height / width *[[UIScreen mainScreen] bounds].size.width;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
