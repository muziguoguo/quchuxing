//
//  NSString+Utils.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/25.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "NSString+Utils.h"

@implementation NSString (Utils)

- (CGFloat)heightWithWidth:(CGFloat)width font:(UIFont *)font{
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(width, MAXFLOAT);
    //1.2配置计算时的行截取方法,和contentLabel对应
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:10];
    [style setAlignment:NSTextAlignmentLeft];
    [style setLineBreakMode:NSLineBreakByWordWrapping];
    //1.4配置属性字典
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style};
    //2.计算
    //如果想保留多个枚举值,则枚举值中间加按位或|即可,并不是所有的枚举类型都可以按位或,只有枚举值的赋值中有左移运算符时才可以
    CGFloat height = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return height;
}

- (CGFloat)widthWithHeigth:(CGFloat)height font:(UIFont *)font{
    //1.1最大允许绘制的文本范围
    CGSize size = CGSizeMake(MAXFLOAT, height);
    //1.3配置计算时的字体的大小
    NSDictionary *dic = @{NSFontAttributeName:font};
    CGFloat width = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:dic context:nil].size.width;
    return width;
}

@end







