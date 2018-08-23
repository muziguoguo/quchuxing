//
//  DriverAndPassengerTableView.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/2.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DriverAndPassengerTableView.h"
#import "UserDefault.h"
#import "LocationTableViewCell.h"
#import "RouteOrTripTableViewCell.h"

#define LocationCellIdentifer @"LocationTableViewCell"
#define WithoutLoginRouteCellIdentifer @"WithoutLoginRouteTableViewCell"
#define TripRouteTableViewCellIdentifer @"TripRouteTableViewCell"

@interface DriverAndPassengerTableView()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, assign) BOOL isLogin; //是否登录

@end

@implementation DriverAndPassengerTableView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style viewType:(ViewType)viewType{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setBackgroundColor:kAppMainLightGrayColor];
        [self setDelegate:self];
        [self setDataSource:self];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self setEstimatedRowHeight:0];
        [self setEstimatedSectionFooterHeight:0];
        [self setEstimatedSectionHeaderHeight:0];
        //注册cell
        [self registerNib:[UINib nibWithNibName:@"LocationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:LocationCellIdentifer];
        [self registerNib:[UINib nibWithNibName:@"WithoutLoginRouteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:WithoutLoginRouteCellIdentifer];
        [self registerNib:[UINib nibWithNibName:@"TripRouteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TripRouteTableViewCellIdentifer];
    }
    return self;
}

- (BOOL)isLogin{
    _isLogin = [UserDefault sharedUserDefault].userInfo;
    return _isLogin;
}

#pragma mark --UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (!self.isLogin || section == 0) {
        return 1;
    }
    else if (section == 1){
        if (self.travelArray.count != 0) {
            return self.travelArray.count;
        }
        else{
            return self.routeArray.count != 0 ? self.routeArray.count : 1;
        }
    }
    return self.routeArray.count != 0 ? self.routeArray.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:LocationCellIdentifer ];
    }
    else if (indexPath.section == 1 && self.isLogin && self.travelArray.count!=0){
        cell = [tableView dequeueReusableCellWithIdentifier:TripRouteTableViewCellIdentifer];
        [(RouteOrTripTableViewCell *)cell setCellType:kLoginTrip];
    }
    else if ((indexPath.section == 1 && (!self.isLogin || (self.routeArray.count==0 && self.travelArray.count==0))) || (indexPath.section == 2 && self.routeArray.count==0)){
        cell = [tableView dequeueReusableCellWithIdentifier:WithoutLoginRouteCellIdentifer];
        [(RouteOrTripTableViewCell *)cell setCellType:kWithoutLoginUsualRoute];
        __WeakSelf__ weakSelf = self;
        [(RouteOrTripTableViewCell *)cell setClickedAddBtn:^{
            if (weakSelf.clickedAddRouteBtn) {
                weakSelf.clickedAddRouteBtn(tableView);
            }
        }];
    }
    else if(indexPath.section == 2 || self.travelArray.count==0){
        cell = [tableView dequeueReusableCellWithIdentifier:TripRouteTableViewCellIdentifer];
        [(RouteOrTripTableViewCell *)cell setCellType:kLoginUsualRoute];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.isLogin) {
        return 2;
    }
    else{
        if (self.travelArray.count != 0) {
            return 3;
        }
        return 2;
    }
}

#pragma mark --UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isLogin) {
        if (indexPath.section == 1 && self.travelArray.count!=0){
            if (indexPath.row == self.travelArray.count-1) {
                [(RouteOrTripTableViewCell *)cell setCornerRadius:10];
            }
            [(RouteOrTripTableViewCell *)cell setDataWithModel:self.travelArray[indexPath.row]];
        }
        else if((indexPath.section == 1 && self.travelArray.count==0 && self.routeArray.count!=0) || (indexPath.section == 2 && self.routeArray.count!=0)){
            if (indexPath.row == self.routeArray.count-1) {
                 [(RouteOrTripTableViewCell *)cell setCornerRadius:10];
            }
            [(RouteOrTripTableViewCell *)cell setDataWithModel:self.routeArray[indexPath.row]];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }
    else if (!self.isLogin || self.routeArray.count==0){
        return 140;
    }
    return 74;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0 ? 8 : 44;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headerView = [[UITableViewHeaderFooterView alloc] init];
    if ((section == 1 && (!self.isLogin || self.travelArray.count==0)) || (section == 2 && self.isLogin)) {
        headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UsualRouteHeaderView"];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UsualRouteHeaderView"];
            [self headerViewWithSectionTitle:@"常用路线" btnTile:@"管理" section:section forView:headerView ];
        }
    }
    else if(section == 1 && self.isLogin && self.travelArray.count!=0){
        headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"TripHeaderView"];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"TripHeaderView"];
            [self headerViewWithSectionTitle:@"待完成行程" btnTile:@"全部" section:section forView:headerView];
        }
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UITableViewHeaderFooterView *footerView = [[UITableViewHeaderFooterView alloc] init];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedRow) {
        self.selectedRow(tableView, indexPath);
    }
}

#pragma mark --配置头部视图
- (void)headerViewWithSectionTitle:(NSString *)sectionTilte btnTile:(NSString *)btnTile section:(NSInteger)section forView:(UITableViewHeaderFooterView *)view{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(8, 0, DEVICE_SCREEN_WIDTH-16, 44)];
    [view.contentView addSubview:backView];
    [backView drawCornerWithRadius:10 connerDirect:UIRectCornerTopLeft | UIRectCornerTopRight borderWidth:0 borderColor:nil backgroundColor:[UIColor whiteColor]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, backView.cur_h)];
    titleLabel.textColor = UICOLOR_FROM_RGB(97, 98, 102, 1 );
    titleLabel.text = sectionTilte;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:titleLabel];
    
    
    UIButton *nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(backView.cur_w-backView.cur_h-15, 0, backView.cur_h, backView.cur_h)];
    nextBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    nextBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 30, 15, 0);
    [nextBtn setTitle:btnTile forState:UIControlStateNormal];
    [nextBtn setTitleColor:UICOLOR_FROM_RGB(147, 148, 153, 1) forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [nextBtn setImage:[UIImage imageNamed:@"icon_return_left_mini"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(headerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTag:100+section];
    [backView addSubview:nextBtn];
    
 
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, backView.cur_h-0.5, backView.cur_w, 0.5)];
    [lineView setBackgroundColor:LineColor];
    [backView addSubview:lineView];
}

#pragma mark --头部按钮响应事件
- (void)headerBtnClicked:(UIButton *)sender{
    if (self.clickedHeaderBtn) {
        self.clickedHeaderBtn(self, sender.tag-100);
    }
}

#pragma mark --UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

@end
