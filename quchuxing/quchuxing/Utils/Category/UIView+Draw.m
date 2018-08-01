//
//  UIView+Draw.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/25.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "UIView+Draw.h"

@implementation UIView (Draw)

#pragma mark --绘制圆角和边框
- (void)drawCornerWithRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *_Nullable)borderColor backgroundColor:(UIColor *_Nullable)backgroundColor{
    CGSize imageSize = self.bounds.size;
    self.layer.shouldRasterize = YES;  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContext(imageSize);
    
        if (borderWidth!=0 || borderColor) {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(1, 1, imageSize.width-2, imageSize.height-2) cornerRadius:radius];
            [path setLineWidth:borderWidth];
            [(borderColor?borderColor:[UIColor clearColor]) setStroke];
            [path stroke];
        }
        
        if (radius!=0 && backgroundColor) {
            UIBezierPath *rectPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(1, 1, imageSize.width-2, imageSize.height-2) cornerRadius:radius];
            [(backgroundColor?backgroundColor:[UIColor clearColor]) setFill];
            [rectPath fill];
        }
        
        UIImage* rectImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            self.layer.contents = (__bridge id)rectImage.CGImage;
        });
    });

}

#pragma mark --设置渐变背景色
- (void)gradualBackgroundColorWithCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth colors:(NSArray *_Nullable)colors  locations:(NSArray<NSNumber *> *_Nullable)locations{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(borderWidth, borderWidth, self.cur_w-borderWidth*2, self.cur_h-borderWidth*2);
    gradientLayer.cornerRadius = cornerRadius;
    gradientLayer.startPoint = CGPointMake(0, 1);;
    gradientLayer.endPoint = CGPointMake(1, 1);
    NSArray *colorArray = @[(__bridge id)    UICOLOR_FROM_RGB(30, 183, 255, 1).CGColor, (__bridge id)UICOLOR_FROM_RGB(59, 95, 255, 1).CGColor];
    gradientLayer.colors = colors?colors:colorArray;
    NSArray *locationArray = @[@(0.25), @(1)];
    gradientLayer.locations = locations?locations:locationArray;
    [self.layer insertSublayer:gradientLayer atIndex:0];
}

@end





