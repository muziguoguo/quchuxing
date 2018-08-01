//
//  HomeViewController.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/29.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "HomeViewController.h"
#import "SelectBarView.h"
#import "LoginView.h"

@interface HomeViewController ()<UINavigationControllerDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate =self;
    
    [self setUpView];
}

#pragma mark --配置子视图
- (void)setUpView{
    SelectBarView *selectBarView = [[SelectBarView alloc] initWithItems:@[@"乘客", @"车主", @"原力"] withTitleFont:[UIFont systemFontOfSize:18] normalColor:FrenchGrayColor selectedColor:DarkGrayColor];
    [self.view addSubview:selectBarView];
    __WeakSelf__ weakSelf = self;
    [selectBarView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view.width);
        make.height.equalTo(44);
        make.centerX.equalTo(weakSelf.view.centerX);
        make.top.equalTo(weakSelf.view.qcx_top).offset(0);
    }];
    
    
    LoginView *loginView = [[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil] lastObject];
    [loginView setLoginType:kUnLogin];
    [loginView setFrame:CGRectMake(15, 150, self.view.cur_w-30, 400)];
    [self.view addSubview:loginView];
}

#pragma mark --通过导航控制器代理方法隐藏导航栏
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if ([viewController isMemberOfClass:[HomeViewController class]]) {
        self.customNavBar.hidden = YES;
    }
    else{
        if ([viewController isKindOfClass:[BaseViewController class]]) {
            [(BaseViewController *)viewController customNavBar].hidden = NO;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
