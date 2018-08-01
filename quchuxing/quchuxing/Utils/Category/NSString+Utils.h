//
//  NSString+Utils.h
//  quchuxing
//
//  Created by 李伟国 on 2018/7/25.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Utils)

/**
 计算动态字符串内容占用高度

 @param width 固定宽度
 @param font 字体样式
 @return 动态高度
 */
- (CGFloat)heightWithWidth:(CGFloat)width font:(UIFont *)font;

- (CGFloat)widthWithHeigth:(CGFloat)height font:(UIFont *)font;

@end






