//
//  SelectBarView.h
//  quchuxing
//
//  Created by 李伟国 on 2018/7/30.
//  Copyright © 2018年 趣出行. All rights reserved.
//


#pragma mark --选择条
#import <UIKit/UIKit.h>

@protocol SelectBarViewDelegate<NSObject>

@optional
- (void)selectedIndex:(NSInteger)index;

@end

@interface BarItemButton : UIButton

@property (nonatomic, strong) UIColor *nomalTitleColor;
@property (nonatomic, strong) UIColor *selectTitleColor;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, copy)  NSString *title;

@end

@interface SelectBarView : UIView

@property (nonatomic, weak) id<SelectBarViewDelegate> delegate;

/**
 初始化

 @param items 选择视图文本
 @param font 字体
 @param normalColor 未选中状态颜色
 @param selectedColor 选择状态颜色
 @return 实例
 */
- (instancetype)initWithItems:(NSArray<NSString *> *)items withTitleFont:(UIFont *)font normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor;

/**
 选中第一个item
 */
- (void)selectItem:(NSInteger)index;

@end
