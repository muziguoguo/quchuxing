//
//  AlertView.m
//  测试文本框(Objective_C)
//
//  Created by 李伟国 on 2018/7/17.
//  Copyright © 2018年 李伟国. All rights reserved.
//

#import "AlertView.h"
#import "NSString+Utils.h"

@implementation AlertView

+ (AlertView *)createSingleCase{
    static AlertView *alertView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (alertView == nil) {
            alertView = [[super allocWithZone:nil] initWithFrame:CGRectZero];
        }
    });
    return alertView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = FrenchGrayColor;
        self.textColor = UIColor.whiteColor;
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:18];
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)showAlertMessage:(NSString *)message withCenter:(CGPoint)center{
    CGFloat width = [message widthWithHeigth:32 font:[UIFont systemFontOfSize:18]];
    if (CGPointEqualToPoint(center, CGPointZero)) {
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-width+6)/2, 200, width+6, 32);
    }
    else{
        self.frame = CGRectMake(center.x-(width+6)/2, center.y-32/2, width+6, 32);
    }
    self.text = message;
    UIWindow *window = [AlertView lastWindow];
    [window addSubview:self];
    __weak typeof(self) weakSelf = self; dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf removeFromSuperview];
    });
}

+ (UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            
            return window;
    }
    
    return [UIApplication sharedApplication].keyWindow;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return nil;
}

- (id)copy{
    return nil;
}

- (id)mutableCopy{
    return nil;
}

@end










