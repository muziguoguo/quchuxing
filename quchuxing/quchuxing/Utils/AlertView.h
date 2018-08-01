//
//  AlertView.h
//  测试文本框(Objective_C)
//
//  Created by 李伟国 on 2018/7/17.
//  Copyright © 2018年 李伟国. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UILabel


/**
 单例方法

 @return 单例对象
 */
+ (AlertView *)createSingleCase;


/**
 展示提示框

 @param message 提示内容
 @param view  所在视图
 @param center 提示框中心位置。可传入CGPointZero，则显示在屏幕中心
 */
- (void)showAlertMessage:(NSString *)message inView:(UIView *)view withCenter:(CGPoint)center;

@end
