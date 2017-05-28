//
//  GXBaseCellWithYYLabel.m
//  GXApp
//
//  Created by zhudong on 16/8/17.
//  Copyright © 2016年 yangfutang. All rights reserved.
//

#import "GXBaseCellWithYYLabel.h"

@implementation GXBaseCellWithyyLabel
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupBaseUI];
    }
    return self;
}
- (void)setupBaseUI{
    self.contentLabel = [[YYLabel alloc] init];
    YYTextAction textAction = ^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
        NSString *subStr = [text.string substringWithRange:range];
        if([subStr containsString:@"http"]){
            NSURL *url = [NSURL URLWithString:subStr];
            if (url) {
                NSDictionary *userInfo = @{@"url" : url};
                [[NSNotificationCenter defaultCenter] postNotificationName:GXBaseCellWithYYLabelDidClick object:nil userInfo:userInfo];
            }
        }
    };
    self.contentLabel.highlightTapAction = textAction;
}
@end
