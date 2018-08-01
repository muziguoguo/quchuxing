//
//  TabBarViewController.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/27.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "DiscoverViewController.h"
#import "AttentionViewController.h"
#import "MessageViewController.h"
#import "UserCenterViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewcontrollers];
}

#pragma mark --添加子控制器
- (void)setViewcontrollers{
    
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UINavigationController *homeNav = [[UINavigationController alloc] initWithRootViewController:homeVC];
    [homeNav setNavigationBarHidden:YES];
    
    DiscoverViewController *discoverVC = [[DiscoverViewController alloc] init];
    UINavigationController *discoverNav = [[UINavigationController alloc] initWithRootViewController:discoverVC];
    [discoverNav setNavigationBarHidden:YES];

    AttentionViewController *attentionVC = [[AttentionViewController alloc] init];
    UINavigationController *attentionNav = [[UINavigationController alloc] initWithRootViewController:attentionVC];
    [attentionNav setNavigationBarHidden:YES];

    MessageViewController *messageVC = [[MessageViewController alloc] init];
    UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController:messageVC];
    [messageNav setNavigationBarHidden:YES];

    UserCenterViewController *userCenterVC = [[UserCenterViewController alloc] init];
    UINavigationController *userCenterNav = [[UINavigationController alloc] initWithRootViewController:userCenterVC];
    [userCenterNav setNavigationBarHidden:YES];

    self.viewControllers = @[homeNav, discoverNav, attentionNav, messageNav, userCenterNav];
    
    [self loadData];
}

#pragma mark --给tabbar配置内容
- (void)loadData{
    NSArray *nomalImages = @[@"btn_home", @"btn_find", @"btn_follow", @"btn_news", @"btn_me"];
    NSArray *selectImages = @[@"btn_home_on", @"btn_find_on", @"btn_follow_on", @"btn_news_on", @"btn_me_on"];
    NSArray *titles = @[@"首页", @"发现", @"关注", @"消息", @"我"];
    
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.tabBarItem setImage:[[UIImage imageNamed:nomalImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [obj.tabBarItem setSelectedImage:[[UIImage imageNamed:selectImages[idx]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [obj.tabBarItem setTitle:titles[idx]];
        [obj.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UICOLOR_FROM_RGB(151, 155, 166, 1), NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
        [obj.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:UICOLOR_FROM_RGB(151, 155, 166, 1), NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateSelected];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
