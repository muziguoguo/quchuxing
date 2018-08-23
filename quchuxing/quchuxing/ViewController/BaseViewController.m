//
//  BaseNavigationController.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/27.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "BaseViewController.h"
#import "UIImage+Utils.h"
#import "NSString+Utils.h"
#import "NavItemCustomView.h"

@interface BaseViewController ()
{
    UIBarButtonItem * _backButtonItem;
    UIBarButtonItem * _leftButtonItem;
    UIBarButtonItem * _rightButtonItem;
}

@end

@implementation BaseViewController

- (void)dealloc{
    DLog(@"%@ dealloc", self.nibName);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _isInit = NO;
        _isNavBarToTop = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //给控制器视图设置默认背景色，避免忘记跳转时发生闪屏
    [self.view setBackgroundColor:kAppMainLightGrayColor];
    [self customNavigationBar];
    self.enableBackButton = NO;
    [self.navigationController.navigationItem setHidesBackButton:YES animated:NO];
    
    if(self!=[self.navigationController.viewControllers objectAtIndex:0]){
        // Put Back button in navigation bar
        [self setEnableBackButton:YES];
    }
    else
    {
        [self setEnableBackButton:NO];
    }
}

#pragma mark - CustomNavBar
- (void)customNavigationBar
{
    _customNavBar = [[UINavigationBar alloc] init];
    [self.view addSubview:_customNavBar];
    __WeakSelf__ weakSelf = self;
    [_customNavBar makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(44);
        make.width.equalTo(weakSelf.view.width);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(weakSelf.view.qcx_top).offset(0);

        }
        else{
            make.top.equalTo(weakSelf.view).offset(20);
            
        }

        make.left.equalTo(weakSelf.view.qcx_left).offset(0);
        make.right.equalTo(weakSelf.view.qcx_right).offset(0);
    }];
    _customNavItem = [[UINavigationItem alloc] init];
    [_customNavBar pushNavigationItem:_customNavItem animated:NO];
    UIImage *naviBarImage = [UIImage buttonImageFromColor:UICOLOR_FROM_RGB(255, 255, 255, 1) withFrame:_customNavBar.bounds];
    self.navBgImage = naviBarImage;
    [_customNavBar setShadowImage:nil];
    
    //标题
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor blackColor]];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
}

#pragma mark --设置导航栏背景图片
- (void)setNavBgImage:(UIImage *)navBgImage
{
    _navBgImage = navBgImage;
    [_customNavBar setBackgroundImage:navBgImage forBarMetrics:UIBarMetricsDefault];
}

#pragma mark --设置导航栏标题
- (void)setTitle:(NSString *)title
{
    //设置标题 else 显示logo
    if (title) {
        [_titleLabel setText:title];
        [_titleLabel setFrame:CGRectMake(_titleLabel.cur_x, _titleLabel.cur_y, [title widthWithHeigth:22 font:[UIFont boldSystemFontOfSize:16]], 22)];
        [_customNavItem setTitleView:_titleLabel];
    }
}

#pragma mark --设置导航栏标题颜色
- (void)setTitleColor:(UIColor *)titleColor
{
    //设置标题 else 显示logo
    if (titleColor) {
        [_titleLabel setTextColor:titleColor];
    }
}

#pragma mark --设置自定义标题视图
- (void)setCustomTitleView:(UIView *) titleView
{
    if (titleView)
    {
        [_customNavItem setTitleView:titleView];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (_isNavBarToTop) {
        [self.view bringSubviewToFront:_customNavBar];
    }
    
    [self.view layoutIfNeeded];
}

#pragma mark --配置子视图（子类重写）
- (void)setUpView
{
    
}

#pragma mark --进行网络请求（子类重写）
- (void)requestServer
{
    
}

#pragma mark --处理请求返回的数据（子类重写）
- (void)handleDataToUpdateView
{
    
}

#pragma mark --设置是否使用自定义返回按钮
- (void)setEnableBackButton:(BOOL)enableBackButton
{
    if (enableBackButton) {
        _enableBackButton = enableBackButton;
        //返回按钮默认按钮
        NavItemCustomView* backButton = [NavItemCustomView buttonWithType: UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(0, 0, 44, 44)];
        [backButton setBackgroundColor:[UIColor clearColor]];
        [backButton setImage:[UIImage imageNamed:@"btn_nav_back"] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"btn_nav_back"]forState:UIControlStateHighlighted];
        [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        _backButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        
        [self addLeftBarButtonItem:_backButtonItem];
    }
}

#pragma mark --向导航栏右侧添加一个按钮
- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem{
    if (@available(iOS 11.0, *)) {
        [_customNavItem setLeftBarButtonItem:rightBarButtonItem];
        if([rightBarButtonItem.customView isMemberOfClass:[NavItemCustomView class]]){
            [rightBarButtonItem.customView setQcx_edgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
        }
    }
    else{
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        [_customNavItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,rightBarButtonItem,nil]];
    }
}

#pragma mark --向导航栏右侧添加多个按钮
- (void)addRightBarButtonItems:(NSArray *)rightBarButtonItems{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:negativeSpacer,nil];
    [array addObjectsFromArray:rightBarButtonItems];
    [_customNavItem setRightBarButtonItems:array];
}

#pragma mark --向导航栏左侧添加一个按钮
- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem{
    if (@available(iOS 11.0, *)) {
        [_customNavItem setLeftBarButtonItem:leftBarButtonItem];
        if([leftBarButtonItem.customView isMemberOfClass:[NavItemCustomView class]]){
            [leftBarButtonItem.customView setQcx_edgeInsets:UIEdgeInsetsMake(0, 20, 0, -20)];
        }
    }
    else{
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = -10;
        [_customNavItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem,nil]];
        
    }
}

#pragma mark --向导航栏左侧添加多个按钮
- (void)addLeftBarButtonItems:(NSArray *)rightBarButtonItems animation:(BOOL)animation{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = IS_IPHONE_Plus||IS_IPHONE_X?-15:-10;
    NSMutableArray *array = [NSMutableArray arrayWithObjects:negativeSpacer,nil];
    [array addObjectsFromArray:rightBarButtonItems];
    [_customNavItem setLeftBarButtonItems:array animated:animation];
}

#pragma mark --返回按钮的响应事件
- (void)backAction:(UIButton *)sender{
    //返回按钮 可重写
    [self.navigationController popViewControllerAnimated:YES];
}

@end
