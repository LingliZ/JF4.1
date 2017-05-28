//
//  SAMenuButton.m
//  NavigationMenu
//
//  Created by Ivan Sapozhnik on 2/19/13.
//  Copyright (c) 2013 Ivan Sapozhnik. All rights reserved.
//

#import "SIMenuButton.h"
#import "SIMenuConfiguration.h"

@implementation SIMenuButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
       [self setSpotlightCenter:CGPointMake(frame.size.width/2, frame.size.height*(-1)+10)];
       [self setBackgroundColor:[UIColor clearColor]];

        frame.origin.y -= 2.0;
        self.title = [[UILabel alloc] initWithFrame:frame];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.backgroundColor = [UIColor clearColor];
        NSDictionary *currentStyle = [[UINavigationBar appearance] titleTextAttributes];
        self.title.textColor = currentStyle[UITextAttributeTextColor];
        //self.title.font =[UIFont systemFontOfSize:WidthScale_IOS6(14)];
        self.title.font = GXFONT_PingFangSC_Light(GXFitFontSize14);
        [self addSubview:self.title];

        [self.arrow setHidden:YES];
        self.arrow = [[UIImageView alloc] initWithImage:[SIMenuConfiguration arrowImage]];
        self.arrow1 = [[UIImageView alloc] initWithImage:[SIMenuConfiguration arrowImage]];
        [self addSubview:self.arrow];
        [self addSubview:self.arrow1];
        self.arrow1.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
    }
    return self;
}

- (UIImageView *)defaultGradient
{
    return nil;
}

- (void)layoutSubviews
{
    //[self.title sizeToFit];
    self.title.center = CGPointMake(self.frame.size.width/2, (self.frame.size.height-2.0)/2);
    self.arrow.center = CGPointMake((GXScreenWidth + 16)/2, self.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height-self.frame.size.height/2 - 2);
    
    float number=self.title.text.length/2;
    int last=self.title.text.length%2;
    if (last!=0) {
        number+=.5;
    }
    
    NSRange range = [self.title.text rangeOfString:@")"];
    if (range.location !=NSNotFound) {
        number-=1;
    }
    if (IS_IPHONE_5) {
        self.arrow1.center = CGPointMake(self.frame.size.width/2 + number * 14 + [SIMenuConfiguration arrowPadding], self.frame.size.height / 2);
    }else{
        self.arrow1.center = CGPointMake(self.frame.size.width/2+number*WidthScale_IOS6(14)+[SIMenuConfiguration arrowPadding], self.frame.size.height / 2);
    }

}

#pragma mark -
#pragma mark Handle taps
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.isActive = !self.isActive;
    CGGradientRef defaultGradientRef = [[self class] newSpotlightGradient];
    [self setSpotlightGradientRef:defaultGradientRef];
    CGGradientRelease(defaultGradientRef);
    return YES;
}
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES;
}
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.spotlightGradientRef = nil;
}
- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    self.spotlightGradientRef = nil;
}

#pragma mark - Drawing Override
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGGradientRef gradient = self.spotlightGradientRef;
    float radius = self.spotlightEndRadius;
    float startRadius = self.spotlightStartRadius;
    CGContextDrawRadialGradient (context, gradient, self.spotlightCenter, startRadius, self.spotlightCenter, radius, kCGGradientDrawsAfterEndLocation);
}


#pragma mark - Factory Method

+ (CGGradientRef)newSpotlightGradient
{
    size_t locationsCount = 2;
    CGFloat locations[2] = {1.0f, 0.0f,};
    CGFloat colors[12] = {0.0f,0.0f,0.0f,0.0f,
        0.0f,0.0f,0.0f,0.55f};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
    CGColorSpaceRelease(colorSpace);
    
    return gradient;
}

- (void)setSpotlightGradientRef:(CGGradientRef)newSpotlightGradientRef
{
    CGGradientRelease(_spotlightGradientRef);
    _spotlightGradientRef = nil;
    
    _spotlightGradientRef = newSpotlightGradientRef;
    CGGradientRetain(_spotlightGradientRef);
    
    [self setNeedsDisplay];
}

#pragma mark - Deallocation

- (void)dealloc
{
    [self setSpotlightGradientRef:nil];
}

@end
