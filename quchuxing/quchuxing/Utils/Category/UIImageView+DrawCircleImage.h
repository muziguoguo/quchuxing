//
//  UIImageView+DrawCircleImage.h
//  quchuxing
//
//  Created by 李伟国 on 2018/7/25.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (DrawCircleImage)


/**
 给imageView绘制圆形图片

 @param image 图片
 @param offset 圆形起始坐标
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 */
- (void)drawCircleImage:(UIImage *_Nonnull)image withOffset:(CGFloat)offset borderColor:(UIColor *_Nullable)borderColor borderWidth:(CGFloat)borderWidth;

@end
