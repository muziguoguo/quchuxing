//
//  HomeViewController.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/29.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "HomeViewController.h"
#import "LoginView.h"
#import "RegisterLoginViewController.h"
#import "HomeListViewModel.h"
#import "HomeTopView.h"
#import "HomeListScrollView.h"
#import "AMapLocationTool.h"
#import "PassengerPublishTravelViewController.h"

@interface HomeViewController ()<UINavigationControllerDelegate, HomeListScrollViewDelegate, UIGestureRecognizerDelegate>
{
    CGFloat _lastOffsetY;  //y轴偏移量
    BOOL _isDragToTop;  //是否向上拖动
}

@property (nonatomic, strong) HomeListScrollView *backView; //滚动列表视图
@property (nonatomic, strong) HomeTopView *topView; //顶部视图
@property (nonatomic, strong) HomeTopView *loginTypeTopView; //登录状态下顶部视图
@property (nonatomic, strong) HomeTopView *unLoginTypeTopView; //未登录状态下顶部视图
@property (nonatomic, strong) HomeListViewModel *homeViewModel;

@end

@implementation HomeViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate =self;
    
#warning 模拟退出登录
    [[UserDefault sharedUserDefault] setUserInfo:nil];
    
    //注册退出登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutNotificationResponse) name:LoginOutNotification object:nil];
    
    [self setUpView];
    
    if (@available(iOS 11, *)) {
        _backView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else{
        [self setAutomaticallyAdjustsScrollViewInsets:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self handleDataToUpdateView];
}

#pragma mark --配置子视图
- (void)setUpView{
    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.cur_w, 266)];
    [backImageView setImage:[UIImage imageNamed:@"beijing"]];
    [self.view addSubview:backImageView];
    
    [self topView];
    
    _backView = [[HomeListScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.cur_w, self.view.cur_h)];
    [_backView setContentSize:CGSizeMake(_backView.cur_w, _backView.cur_h+_topView.cur_y_h)];
    [_backView setContentOffset:CGPointMake(0, -_topView.cur_y_h)];
    [_backView setResponseDelegate:self];
    [_backView setScrollEnabled:NO];
    [self.view addSubview:_backView];
    
    UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureResponse:)];
    [pangesture setDelegate:self];
    [_backView addGestureRecognizer:pangesture];
}

#pragma mark --lazyLoad
- (HomeTopView *)topView{
    UserModel *userInfo = [[UserDefault sharedUserDefault] userInfo];
    if (_topView) {
        [_topView removeFromSuperview];
    }
    if (!userInfo) {
        _topView = self.unLoginTypeTopView;
        _topView.frame = CGRectMake(0, KStatusBarHeight, self.view.cur_w, 145);
    }
    else{
        _topView = self.loginTypeTopView;
        _topView.frame = CGRectMake(0, KStatusBarHeight, self.view.cur_w, 185);
        
    }
    if (_backView) {
        [_backView setContentSize:CGSizeMake(_backView.cur_w, _backView.cur_h+_topView.cur_y_h)];
        [_backView setContentOffset:CGPointMake(0, -_topView.cur_y_h)];
        [self.view insertSubview:_topView belowSubview:_backView];
    }
    else{
        [self.view addSubview:_topView];
    }
    return _topView;
}

- (HomeTopView *)unLoginTypeTopView{
    if (!_unLoginTypeTopView) {
        _unLoginTypeTopView = [[[NSBundle mainBundle] loadNibNamed:@"UnLoginHomeTopView" owner:self options:nil] lastObject];
        _unLoginTypeTopView.loginType = 0;
    }
    return _unLoginTypeTopView;
}

- (HomeTopView *)loginTypeTopView{
    if (!_loginTypeTopView) {
        _loginTypeTopView = [[[NSBundle mainBundle] loadNibNamed:@"LoginHomeTopView" owner:self options:nil] lastObject];
        _loginTypeTopView.loginType = 1;
    }
    return _loginTypeTopView;
}

- (HomeListViewModel *)homeViewModel{
    if (!_homeViewModel) {
        _homeViewModel = [[HomeListViewModel alloc] init];
    }
    return _homeViewModel;
}

#pragma mark --处理数据更新视图
- (void)handleDataToUpdateView{
    [self topView];
    UserModel *userInfo = [UserDefault sharedUserDefault].userInfo;
    if (userInfo) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __WeakSelf__ weakSelf = self;
        [self.homeViewModel handleRequestWithSuccess:^(StatusCode statusCode) {
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.backView.passengerRoutes = weakSelf.homeViewModel.passengerRouteDataArray;
                weakSelf.backView.passengerTravels = weakSelf.homeViewModel.passengerTravelDataArray;
                weakSelf.backView.driverRoutes = weakSelf.homeViewModel.driverRouteDataArray;
                weakSelf.backView.driverTravels = weakSelf.homeViewModel.driverTravelDataArray;
                [weakSelf.backView reloadData];
                [hud hideAnimated:YES];
            });
        } failure:^(NSError *error) {
            [hud hideAnimated:YES];
        }];
    }
}


#pragma mark --跳转登录页
- (UserModel *)presentLoginView{
    __block UserModel *userModel = [[UserDefault sharedUserDefault] userInfo];
    if (!userModel) {
        RegisterLoginViewController *loginVC = [[RegisterLoginViewController alloc] init];
        [self presentViewController:loginVC animated:YES completion:^{
            userModel = [[UserDefault sharedUserDefault] userInfo];
        }];
    }
    return userModel;
}

#pragma mark --手势响应事件
- (void)panGestureResponse:(UIPanGestureRecognizer *)pangesture{
    CGPoint transPoint = [pangesture translationInView:self.view];
    if (pangesture.state == UIGestureRecognizerStateBegan) {
        _lastOffsetY = transPoint.y;
    }
    else if (pangesture.state == UIGestureRecognizerStateChanged){
        CGFloat offsetY = transPoint.y-_lastOffsetY;
        CGFloat scaleY = _backView.contentOffset.y / -_topView.cur_y_h;
        if (_lastOffsetY > transPoint.y) {  //往上拉值越来越小
            _isDragToTop = true;
            if (_backView.contentOffset.y < -KStatusBarHeight) {
                [_backView setTableScrollEnable:NO];
                [_backView setContentOffset:CGPointMake(0, _backView.contentOffset.y-offsetY)];
                [_topView zoomViewWithScale:CGSizeMake(scaleY, scaleY)];
                [_backView setShowTopBarView:NO];
            }
            else{
                [_backView setContentOffset:CGPointMake(0, -KStatusBarHeight)];
                [_topView zoomViewWithScale:CGSizeMake(0, 0)];
                [_backView setShowTopBarView:YES];
                [_backView setTableScrollEnable:YES];
            }
        }
        else if (_lastOffsetY < transPoint.y){  //往下拉值越来越大
            _isDragToTop = false;
            if (_backView.contentOffset.y > -_topView.cur_y_h) {
                [_backView setTableScrollEnable:NO];
                [_backView setContentOffset:CGPointMake(0, _backView.contentOffset.y-offsetY)];
                [_topView zoomViewWithScale:CGSizeMake(scaleY, scaleY)];
                [_backView setShowTopBarView:NO];
            }
            else{
                [_backView setContentOffset:CGPointMake(0, -_topView.cur_y_h)];
                [_topView zoomViewWithScale:CGSizeMake(1, 1)];
                [_backView setTableScrollEnable:YES];
                [_backView setShowTopBarView:NO];
            }
        }
        else{
            [_backView setTableScrollEnable:YES];
        }
        _lastOffsetY = transPoint.y;
    }
    else if(pangesture.state == UIGestureRecognizerStateEnded){
        if (!_isDragToTop) {
            if (_backView.contentOffset.y>-_topView.cur_y_h/2) {
                [_backView setContentOffset:CGPointMake(0, -KStatusBarHeight) animated:YES];
                [_topView zoomViewWithScale:CGSizeMake(0, 0)];
                [_backView setShowTopBarView:YES];
            }
            else{
                [_backView setShowTopBarView:NO];
                [_backView setContentOffset:CGPointMake(0, -_topView.cur_y_h) animated:YES];
                [_topView zoomViewWithScale:CGSizeMake(1, 1)];
            }
        }
        else{
            if (_backView.contentOffset.y<-_topView.cur_y_h/2) {
                [_backView setShowTopBarView:NO];
                [_backView setContentOffset:CGPointMake(0, -_topView.cur_y_h) animated:YES];
                [_topView zoomViewWithScale:CGSizeMake(1, 1)];
            }
            else{
                [_backView setContentOffset:CGPointMake(0, -KStatusBarHeight) animated:YES];
                [_topView zoomViewWithScale:CGSizeMake(0, 0)];
                [_backView setShowTopBarView:YES];
            }
        }
    }
}

#pragma mark --通知响应事件
- (void)loginOutNotificationResponse{
    [_backView reloadData];
}

#pragma mark --UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark --HomeListScrollViewDelegate
- (void)didSelectedRowOfIndexPath:(NSIndexPath *)indexPath inTableViewType:(ViewType)tableViewType{
    UserModel *userModel = [self presentLoginView];
    //if (userModel) {
        if (indexPath.section == 0) {
            //发布行程
            if (tableViewType == kPassengerPage) {
                PassengerPublishTravelViewController *passengerPublishVC = [[PassengerPublishTravelViewController alloc] init];
                [passengerPublishVC setIsLoctaionSuccess:[AMapLocationTool sharedAMapLocation].locationSuccess];
                [self.navigationController pushViewController:passengerPublishVC animated:YES];
            }
        }
    //}
}

- (void)clickedHeaderBtnInTableViewType:(ViewType)tableViewType section:(NSInteger)section{
    UserModel *userModel = [self presentLoginView];
    if (userModel) {
        
    }
}

- (void)clickedAddRouteBtnInTableViewType:(ViewType)tableViewType{
    UserModel *userModel = [self presentLoginView];
    if (userModel) {
        
    }
}

#pragma mark --UINavigationControllerDelegate
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


@end
