//
//  GXCourseCell.m
//  GXAppNew
//
//  Created by zhudong on 2016/12/2.
//  Copyright © 2016年 futang yang. All rights reserved.
//

#import "GXCourseCell.h"

@interface GXCourseCell ()

@property(nonatomic, strong) UILabel *timeLable;
@property(nonatomic, strong) UILabel *titleLable;
@property(nonatomic, strong) UILabel *nameLable;

@end

@implementation GXCourseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UILabel *timeL = [[UILabel alloc] init];
    UILabel *titleL = [[UILabel alloc] init];
    UILabel *nameL = [[UILabel alloc] init];
    
    [self setLabel:timeL];
    [self setLabel:titleL];
    [self setLabel:nameL];
    
    [self.contentView addSubview:timeL];
    [self.contentView addSubview:titleL];
    [self.contentView addSubview:nameL];
    
    self.timeLable = timeL;
    self.titleLable = titleL;
    self.nameLable = nameL;
    
    [timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(1.5 * GXMargin);
    }];
    
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.centerX.equalTo(self.contentView);
    }];
    
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-1.5 * GXMargin);
    }];
}

- (void)setLabel:(UILabel *)label{
    label.font = GXFONT_PingFangSC_Regular(GXFitFontSize14);
    label.textColor = [UIColor whiteColor];
}

- (void)setCourseModel:(GXCoursesModel *)courseModel{
    _courseModel = courseModel;
    self.timeLable.text = [NSString stringWithFormat:@"%@-%@", courseModel.stime, courseModel.etime];
    self.titleLable.text = courseModel.name;
    if (courseModel.analystsArray.count > 1) {
        self.nameLable.text = [NSString stringWithFormat:@"%@ %@", courseModel.analystsArray.firstObject, courseModel.analystsArray[1]];
    }else{
        self.nameLable.text = [NSString stringWithFormat:@"%@ %@", courseModel.analysts, courseModel.host];
    }
}
@end
