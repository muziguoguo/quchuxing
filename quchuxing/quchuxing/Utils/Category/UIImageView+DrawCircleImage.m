//
//  UIImageView+DrawCircleImage.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/25.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "UIImageView+DrawCircleImage.h"

@implementation UIImageView (DrawCircleImage)

- (void)drawCircleImage:(UIImage *_Nonnull)image withOffset:(CGFloat)offset borderColor:(UIColor *_Nullable)borderColor borderWidth:(CGFloat)borderWidth{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContext(image.size);
        
        CGContextRef context =UIGraphicsGetCurrentContext();
        
        CGContextSetLineWidth(context, borderWidth);
        
        CGContextSetStrokeColorWithColor(context, borderColor?borderColor.CGColor:nil);
        
        CGRect rect = CGRectMake(offset, offset, image.size.width - offset *2.0f, image.size.height - offset *2.0f);
        
        CGContextAddEllipseInRect(context, rect);
        
        CGContextClip(context);
        
        //在圆区域内画出image原图
        
        [image drawInRect:rect];
        
        CGContextAddEllipseInRect(context, rect);
        
        CGContextStrokePath(context);
        
        //生成新的image
        
        UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = nil;
            self.image = newImg;
        });
    });
}

@end
