//
//  UIView+Draw.h
//  quchuxing
//
//  Created by 李伟国 on 2018/7/25.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Draw)


/**
 为UIView动态绘制圆角及边框

 @param radius 圆角大小
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 @param backgroundColor 背景色
 */
- (void)drawCornerWithRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *_Nullable)borderColor backgroundColor:(UIColor *_Nullable)backgroundColor;



/**
 绘制渐变背景色

 @param cornerRadius 圆角半径
 @param borderWidth  边框宽度
 @param colors 渐变色区
 @param locations 渐变颜色分割点
 */
- (void)gradualBackgroundColorWithCornerRadius:(CGFloat)cornerRadius borderWidth:(CGFloat)borderWidth colors:(NSArray *_Nullable)colors  locations:(NSArray<NSNumber *> *_Nullable)locations;


@end
