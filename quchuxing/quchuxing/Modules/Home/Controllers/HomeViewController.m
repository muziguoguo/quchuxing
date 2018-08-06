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
#import "RegisterLoginViewController.h"
#import "DriverAndPassengerTableView.h"
#import "UnregisteredDriverView.h"

@interface HomeViewController ()<UINavigationControllerDelegate, SelectBarViewDelegate>
{
    DriverAndPassengerTableView *_passengerTableView;   //乘客页
    DriverAndPassengerTableView *_driverTableView;   //车主页
    UnregisteredDriverView *_unregisterDriverView;  //未注册车主页
}

@property (nonatomic, strong) SelectBarView *selectBarView; //选择条

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate =self;
    [self setUpView];
    if (@available(iOS 11, *)) {
        _passengerTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _driverTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else{
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
}

#pragma mark --配置子视图
- (void)setUpView{
    SelectBarView *selectBarView = [[SelectBarView alloc] initWithItems:@[@"乘客", @"车主", @"原力"] withTitleFont:[UIFont systemFontOfSize:18] normalColor:FrenchGrayColor selectedColor:DarkGrayColor];
    _selectBarView = selectBarView;
    [self.view addSubview:selectBarView];
    selectBarView.delegate = self;
    [selectBarView selectFirstItem];
    __WeakSelf__ weakSelf = self;
    [selectBarView makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakSelf.view.width);
        make.height.equalTo(44);
        make.centerX.equalTo(weakSelf.view.centerX);
        if (@available(iOS 11, *)) {
            make.top.equalTo(weakSelf.view.safeAreaLayoutGuideTop).offset(0);
        }
        else{
            make.top.equalTo(weakSelf.view.top).offset(20);
        }
    }];
    //[self setDriverView];
    [self setPassengerView];
}

#pragma mark --设置乘客页
- (void)setPassengerView{
    _passengerTableView = [[DriverAndPassengerTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped viewType:kPassengerPage];
    _passengerTableView.tag = 30;
    [self.view addSubview:_passengerTableView];
    __WeakSelf__ weakSelf = self;
    [_passengerTableView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.bottom).offset(kTabBarHeight);
        make.top.equalTo(weakSelf.selectBarView.bottom).offset(0);
        make.width.equalTo(weakSelf.view.width);
        make.centerX.equalTo(weakSelf.view.centerX);
    }];
}

#pragma mark --设置车主页
- (void)setDriverView{
    _driverTableView = [[DriverAndPassengerTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped viewType:kDriverPage];
    _driverTableView.tag = 31;
    [self.view addSubview:_driverTableView];
    __WeakSelf__ weakSelf = self;
    [_driverTableView makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.bottom).offset(kTabBarHeight);
        make.top.equalTo(weakSelf.selectBarView.bottom).offset(0);
        make.width.equalTo(weakSelf.view.width);
        make.centerX.equalTo(weakSelf.view.centerX);
    }];
    
#warning 测试登出账号
    [UserDefault sharedUserDefault].userInfo = nil;
    UserModel *userModel = [UserDefault sharedUserDefault].userInfo;
    if (!userModel || !userModel.isAuth) {
        _unregisterDriverView = [[[NSBundle mainBundle] loadNibNamed:@"UnregisteredDriverView" owner:self options:nil] lastObject];
        [_driverTableView addSubview:_unregisterDriverView];
        __WeakObject(_driverTableView) superView = _driverTableView;
        DLog(@"%@", superView);
        [_unregisterDriverView makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(superView.width);
            make.height.equalTo(superView.height);
            make.centerX.equalTo(superView.centerX);
            make.centerY.equalTo(superView.centerY);
        }];
    }
    else{
        if (_unregisterDriverView) {
            _unregisterDriverView.hidden = YES;
        }
    }
}


- (void)selectedIndex:(NSInteger)index{
    [self.view bringSubviewToFront:[self.view viewWithTag:30+index]];
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
