//
//  AlertView.m
//  测试文本框(Objective_C)
//
//  Created by 李伟国 on 2018/7/17.
//  Copyright © 2018年 李伟国. All rights reserved.
//

#import "AlertView.h"
#import "NSString+Utils.h"

@interface AlertView()
{
    CALayer *_backLayer;
}

@end

@implementation AlertView

#pragma mark --单例方法
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

#pragma mark --初始化函数
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.textColor = UIColor.whiteColor;
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:16];
        self.backgroundColor = FrenchGrayColor;
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark --展示提示框
- (void)showAlertMessage:(NSString *)message inView:(UIView *)view withCenter:(CGPoint)center{
    CGFloat width = [message widthWithHeigth:32 font:[UIFont systemFontOfSize:16]];
    if (CGPointEqualToPoint(center, CGPointZero)) {
        self.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-(width+10))/2, 200, width+10, 32);
    }
    else{
        self.frame = CGRectMake(center.x-(width+10)/2, center.y-32/2, width+10, 32);
    }
    self.text = message;
    [view addSubview:self];
    __weak typeof(self) weakSelf = self; dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf removeFromSuperview];
    });
}

#pragma mark--获取主窗口（未用）
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

#pragma mark --完整单例构建
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










