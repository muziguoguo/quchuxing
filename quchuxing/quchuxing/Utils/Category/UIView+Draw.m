//
//  UIView+Draw.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/25.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "UIView+Draw.h"
#import <objc/runtime.h>


@implementation UIView (Draw)

#pragma mark --运行时添加字段判断是否存在边框圆角或渐变背景色
- (void)setBorderLayer:(CAShapeLayer *)borderLayer{
    objc_setAssociatedObject(self, @"borderLayer", borderLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAShapeLayer *)borderLayer{
    return objc_getAssociatedObject(self, @"borderLayer");
}

- (void)setGradientLayer:(CAGradientLayer *)gradientLayer{
    objc_setAssociatedObject(self, @"gradientLayer", gradientLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAGradientLayer *)gradientLayer{
    return objc_getAssociatedObject(self, @"gradientLayer");
}

#pragma mark --绘制圆角和边框
- (void)drawCornerWithRadius:(CGFloat)radius connerDirect:(UIRectCorner)cornerDirect borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor{
    [self drawCornerWithRadius:radius connerDirect:cornerDirect borderWidth:borderWidth borderColor:borderColor backgroundColor:backgroundColor bounds:CGRectZero];
}

- (void)drawCornerWithRadius:(CGFloat)radius connerDirect:(UIRectCorner)cornerDirect borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor bounds:(CGRect)bounds{
    if (self.borderLayer) {
        [self.borderLayer removeFromSuperlayer];
        self.borderLayer = nil;
    }
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    [self.layer insertSublayer:borderLayer atIndex:0];
    borderLayer.bounds = CGRectZero;
    if (CGRectEqualToRect(bounds, CGRectZero)) {
        borderLayer.bounds = self.bounds;
    }
    else{
        borderLayer.bounds = bounds;
    }
    borderLayer.position = CGPointMake(CGRectGetMidX(borderLayer.bounds), CGRectGetMidY(borderLayer.bounds));
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds byRoundingCorners:cornerDirect cornerRadii:CGSizeMake(radius, radius)].CGPath;
    if (borderWidth != 0) {
        borderLayer.lineWidth = borderWidth;
        borderLayer.strokeColor = borderColor.CGColor;
    }
    if (backgroundColor!=nil) {
        borderLayer.fillColor = backgroundColor.CGColor;
    }
    self.borderLayer = borderLayer;
}


#pragma mark --设置渐变背景色
- (void)gradualBackgroundColorWithCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth colors:(NSArray *)colors locations:(NSArray<NSNumber *> *)locations{
    [self gradualBackgroundColorWithCornerRadius:cornerRadius borderWidth:borderWidth colors:colors locations:locations bounds:CGRectZero];
}

- (void)gradualBackgroundColorWithCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth colors:(NSArray *_Nullable)colors  locations:(NSArray<NSNumber *> *_Nullable)locations bounds:(CGRect)bounds{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    if (self.gradientLayer) {
        [self.gradientLayer removeFromSuperlayer];
        self.gradientLayer = nil;
    }
    CGRect layerBounds = CGRectZero;
    if (CGRectEqualToRect(bounds, CGRectZero)) {
        layerBounds = self.bounds;
    }
    else{
        layerBounds = bounds;
    }
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(borderWidth, borderWidth, layerBounds.size.width-borderWidth*2, layerBounds.size.height-borderWidth*2);
    gradientLayer.cornerRadius = cornerRadius;
    gradientLayer.startPoint = CGPointMake(0, 1);;
    gradientLayer.endPoint = CGPointMake(1, 1);
    NSArray *colorArray = @[(__bridge id)    UICOLOR_FROM_RGB(80, 209, 255, 1).CGColor, (__bridge id)UICOLOR_FROM_RGB(67, 116, 255, 1).CGColor];
    gradientLayer.colors = colors?colors:colorArray;
    NSArray *locationArray = @[@(0.25), @(1)];
    gradientLayer.locations = locations?locations:locationArray;
    [self.layer insertSublayer:gradientLayer atIndex:0];
    self.gradientLayer = gradientLayer;
}

@end






