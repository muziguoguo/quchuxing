//
//  HomeListScrollView.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/10.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "HomeListScrollView.h"
#import "SelectBarView.h"
#import "DriverAndPassengerTableView.h"
#import "UnregisteredDriverView.h"

@interface HomeListScrollView()<SelectBarViewDelegate, UIScrollViewDelegate>
{
    UIScrollView *_horizenScrollView;   //横向滚动视图
    UIView *_driverSuperView;   //车主页基础视图
    SelectBarView *_selectBarView;  //选择条
    DriverAndPassengerTableView *_passengerTableView;   //乘客页TableView
    DriverAndPassengerTableView *_driverTableView;   //车主页TableView
    NSInteger _pageIndex;   //页面
    CGFloat _lastOffsetX;   //上一次横向偏移量
}

@property (nonatomic, strong) UIView *topBarView;    //头部底部视图
@property (nonatomic, strong) UnregisteredDriverView *unregisterDriverView;  //未注册车主页

@end

@implementation HomeListScrollView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setSelectBarView];
        [self setHorizenScrollView];
    }
    return self;
}

#pragma mark --配置属性
- (void)setTableScrollEnable:(BOOL)tableScrollEnable{
    if (!tableScrollEnable) {
        _passengerTableView.contentOffset = CGPointZero;
        _driverTableView.contentOffset = CGPointZero;
    }
}

- (void)setShowTopBarView:(BOOL)showTopBarView{
    self.topBarView.backgroundColor = showTopBarView?kAppMainLightGrayColor:[UIColor clearColor];
}

#pragma mark --选择条
- (void)setSelectBarView{
    _selectBarView = [[SelectBarView alloc] initWithItems:@[@"乘客", @"车主"] withTitleFont:[UIFont systemFontOfSize:18] normalColor:FrenchGrayColor selectedColor:DarkGrayColor];
    _selectBarView.frame = CGRectMake(0, 0, self.cur_w, 44);
    [_selectBarView drawCornerWithRadius:10 connerDirect:UIRectCornerTopLeft|UIRectCornerTopRight borderWidth:0 borderColor:nil backgroundColor:kAppMainLightGrayColor];
    _selectBarView.delegate = self;
    [_selectBarView selectItem:0];
    [self addSubview:_selectBarView];
}

#pragma mark --横向滚动视图
- (void)setHorizenScrollView{
    _horizenScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _selectBarView.cur_y_h, self.cur_w, self.cur_h-kTabBarHeight)];
    _horizenScrollView.contentSize = CGSizeMake(self.cur_w*2, 0);
    _horizenScrollView.showsHorizontalScrollIndicator = NO;
    _horizenScrollView.pagingEnabled = YES;
    _horizenScrollView.bounces = NO;
    _horizenScrollView.scrollEnabled = NO;
    _horizenScrollView.delegate = self;
    [self addSubview:_horizenScrollView];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(horizenPanGestrueResponse:)];
    [_horizenScrollView addGestureRecognizer:panGesture];
    
    [self setPassengerView];
    [self setDriverView];
}

#pragma mark --设置乘客页
- (void)setPassengerView{
    _passengerTableView = [[DriverAndPassengerTableView alloc] initWithFrame:CGRectMake(0, 0, _horizenScrollView.cur_w, _horizenScrollView.cur_h) style:UITableViewStyleGrouped viewType:kPassengerPage];
    [_horizenScrollView addSubview:_passengerTableView];
    [self invokeDelegateMethodForTableView:_passengerTableView];
}

#pragma mark --设置车主页
- (void)setDriverView{
    _driverSuperView = [[UIView alloc] initWithFrame:CGRectMake(_horizenScrollView.cur_w, 0, _horizenScrollView.cur_w, _horizenScrollView.cur_h)];
    [_horizenScrollView addSubview:_driverSuperView];
    
    _driverTableView = [[DriverAndPassengerTableView alloc] initWithFrame:_driverSuperView.bounds style:UITableViewStyleGrouped viewType:kDriverPage];
    [_driverSuperView addSubview:_driverTableView];
    [self invokeDelegateMethodForTableView:_driverTableView];
    
    UserModel *userModel = [UserDefault sharedUserDefault].userInfo;
    if (!userModel || !userModel.isAuth) {
        [self.unregisterDriverView setHidden:NO];
    }
    else{
        if (_unregisterDriverView) {
            [self.unregisterDriverView setHidden:YES];
        }
    }
}

#pragma mark --lazyload
- (UIView *)topBarView{
    if (!_topBarView) {
        _topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -KStatusBarHeight, self.cur_w, KStatusBarHeight + 44)];
        _topBarView.opaque = NO;
        [self insertSubview:_topBarView belowSubview:_selectBarView];
    }
    return _topBarView;
}

- (UnregisteredDriverView *)unregisterDriverView{
    if(!_unregisterDriverView){
        _unregisterDriverView = [[[NSBundle mainBundle] loadNibNamed:@"UnregisteredDriverView" owner:self options:nil] lastObject];
        [_unregisterDriverView setFrame:_driverSuperView.bounds];
        [_driverSuperView addSubview:_unregisterDriverView];
    }
    return _unregisterDriverView;
}

#pragma mark --刷新数据
- (void)reloadData{
    UserModel *userModel = [[UserDefault sharedUserDefault] userInfo];
    self.unregisterDriverView.hidden = userModel && userModel.isAuth ? YES : NO;
    _passengerTableView.routeArray = self.passengerRoutes;
    _passengerTableView.travelArray = self.passengerTravels;
    [_passengerTableView reloadData];
    _driverTableView.routeArray = self.driverRoutes;
    _driverTableView.travelArray = self.driverTravels;
    [_driverTableView reloadData];
}

#pragma mark --调用代理函数
- (void)invokeDelegateMethodForTableView:(DriverAndPassengerTableView *)tableView{
    __WeakSelf__ weakSelf = self;
    ViewType type = tableView==_passengerTableView?kPassengerPage:kDriverPage;
    [tableView setClickedHeaderBtn:^(UITableView *tableView, NSInteger section) {
        if (weakSelf.responseDelegate && [weakSelf.responseDelegate respondsToSelector:@selector(clickedHeaderBtnInTableViewType:section:)]) {
            [weakSelf.responseDelegate clickedHeaderBtnInTableViewType:type section:section];
        }
    }];
    
    [tableView setClickedAddRouteBtn:^(UITableView *tableView) {
        if (weakSelf.responseDelegate && [weakSelf.responseDelegate respondsToSelector:@selector(clickedAddRouteBtnInTableViewType:)]) {
            [weakSelf.responseDelegate clickedAddRouteBtnInTableViewType:type];
        }
    }];
    
    [tableView setSelectedRow:^(UITableView *tableView, NSIndexPath *indexPath) {
        if (weakSelf.responseDelegate && [weakSelf.responseDelegate respondsToSelector:@selector(didSelectedRowOfIndexPath:inTableViewType:)]) {
            [weakSelf.responseDelegate didSelectedRowOfIndexPath:indexPath inTableViewType:type];
        }
    }];
}

#pragma mark --手势响应事件
- (void)horizenPanGestrueResponse:(UIPanGestureRecognizer *)gesture{
    CGPoint point = [gesture translationInView:self];
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _lastOffsetX = point.x;
    }
    else if (gesture.state == UIGestureRecognizerStateChanged){
        if (fabs(point.x) > _horizenScrollView.cur_w/3) {
            if (_lastOffsetX > point.x) { //向左滑
                [_selectBarView selectItem:1];
                [_horizenScrollView setContentOffset:CGPointMake(_horizenScrollView.cur_w, 0) animated:YES];
            }
            else if (_lastOffsetX < point.x){  //向右滑
                [_selectBarView selectItem:0];
                [_horizenScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }
        _lastOffsetX = point.x;
    }
}

#pragma mark --SelectBarViewDelegate
- (void)selectedIndex:(NSInteger)index{
    [_horizenScrollView setContentOffset:CGPointMake(index*_horizenScrollView.cur_w, 0) animated:YES];
}

@end



