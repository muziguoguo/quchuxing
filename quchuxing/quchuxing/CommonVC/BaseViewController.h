//
//  BaseNavigationController.h
//  quchuxing
//
//  Created by 李伟国 on 2018/7/27.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
{
    UILabel * _titleLabel;
    BOOL _isInit;            //Default:NO 是否显示过 //用来判断只在首次创建显示是调用的函数时使用
    UINavigationItem * _customNavItem;
}

@property (nonatomic, assign) BOOL enableBackButton;  //是否启用自定义返回item
@property (strong, nonatomic) UILabel *titleLabel;      //头像
@property (strong, nonatomic) UINavigationBar  *customNavBar;//自定义导航栏
@property (assign, nonatomic) BOOL isNavBarToTop;       //navgationBar 在试图最上层
@property (strong, nonatomic) UIImage *navBgImage;      //导航栏背景图片

//添加一个右侧item，并修改rightnavbarBtn位置
- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem;
//添加多个右侧item，并修改rightnavbarBtn位置
- (void)addRightBarButtonItems:(NSArray *)rightBarButtonItems;

//添加一个左侧item，并修改leftnavbarBtn位置
- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem;
//添加多个左侧item，并修改leftnavbarBtn位置
- (void)addLeftBarButtonItems:(NSArray *)rightBarButtonItems animation:(BOOL)animation;

//返回按钮的响应事件，可重写
- (void)backAction:(UIButton *)sender;

- (void)setTitleColor:(UIColor *)titleColor;
- (void)setCustomTitleView:(UIView *) titleView;

- (void)setUpView;      //配置视图
- (void)requestServer;  //请求服务器
- (void)handleDataToUpdateView;     //获取数据来更新视图

@end
