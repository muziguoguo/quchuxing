//
//  DriverAndPassengerTableView.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/2.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "DriverAndPassengerTableView.h"
#import "UserDefault.h"
#import "LocationTableViewCell.h"
#import "RouteOrTripTableViewCell.h"

#define LocationCellIdentifer @"LocationTableViewCell"
#define WithoutLoginRouteCellIdentifer @"WithoutLoginRouteTableViewCell"
#define UsualRouteCellIdentifer @"UsualRouteTableViewCell"
#define TripCellIdentifer @"TripTableViewCell"

@interface DriverAndPassengerTableView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) BOOL isLogin; //是否登录

@end

@implementation DriverAndPassengerTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style viewType:(ViewType)viewType{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self setBackgroundColor:kAppMainLightGrayColor];
        [self setDelegate:self];
        [self setDataSource:self];
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.estimatedRowHeight =0;
        self.estimatedSectionHeaderHeight =0;    
        self.estimatedSectionFooterHeight =0;
        //注册cell
        [self registerNib:[UINib nibWithNibName:@"LocationTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:LocationCellIdentifer];
        [self registerNib:[UINib nibWithNibName:@"WithoutLoginRouteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:WithoutLoginRouteCellIdentifer];
        [self registerNib:[UINib nibWithNibName:@"UsualRouteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:UsualRouteCellIdentifer];
        [self registerNib:[UINib nibWithNibName:@"TripTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:TripCellIdentifer];

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
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:LocationCellIdentifer ];
    }
    else if (indexPath.section == 1 && self.isLogin){
        cell = [tableView dequeueReusableCellWithIdentifier:TripCellIdentifer];
        [(RouteOrTripTableViewCell *)cell setCellType:kLoginTrip];
        [(RouteOrTripTableViewCell *)cell setDataWithModel:nil];
    }
    else if (indexPath.section == 1 && !self.isLogin){
        cell = [tableView dequeueReusableCellWithIdentifier:WithoutLoginRouteCellIdentifer];
        [(RouteOrTripTableViewCell *)cell setCellType:kWithoutLoginUsualRoute];
    }
    else if(indexPath.section == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:UsualRouteCellIdentifer];
        [(RouteOrTripTableViewCell *)cell setCellType:kLoginUsualRoute];
        [(RouteOrTripTableViewCell *)cell setDataWithModel:nil];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.isLogin ? 3 : 2;
}

#pragma mark --UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }
    else if (self.isLogin){
        return 74;
    }
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section==0 ? 8 : 44;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *headerView = nil;
    if ((section == 1 && !self.isLogin) || (section == 2 && self.isLogin)) {
        headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UsualRouteHeaderView"];
        if (!headerView) {
            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"UsualRouteHeaderView"];
            [self headerViewWithSectionTitle:@"常用路线" btnTile:@"管理" section:section forView:headerView ];
        }
    }
    else if(section == 1 && self.isLogin){
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
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark --配置头部视图
- (void)headerViewWithSectionTitle:(NSString *)sectionTilte btnTile:(NSString *)btnTile section:(NSInteger)section forView:(UITableViewHeaderFooterView *)view{
    UIView *backView = [[UIView alloc] init];
    [view.contentView addSubview:backView];
    [backView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(view.leading).offset(8);
        make.trailing.equalTo(view.trailing).offset(-8);
        make.height.equalTo(view.height);
        make.centerX.equalTo(view.centerX);
    }];
    [backView setBackgroundColor:[UIColor yellowColor]];
    [backView drawCornerWithRadius:10 connerDirect:UIRectCornerTopLeft | UIRectCornerTopRight borderWidth:0 borderColor:nil backgroundColor:[UIColor orangeColor]];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = UICOLOR_FROM_RGB(97, 98, 102, 1 );
    titleLabel.text = sectionTilte;
    titleLabel.font = [UIFont systemFontOfSize:14];
    [backView addSubview:titleLabel];
    
    [titleLabel makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(backView.height);
        make.width.equalTo(200);
        make.leading.equalTo(backView.leading).offset(15);
        make.centerY.equalTo(backView.centerY);
    }];
    
    UIButton *nextBtn = [[UIButton alloc] init];
    nextBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    nextBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 30, 15, 0);
    [nextBtn setTitle:btnTile forState:UIControlStateNormal];
    [nextBtn setTitleColor:UICOLOR_FROM_RGB(147, 148, 153, 1) forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    [nextBtn setImage:[UIImage imageNamed:@"icon_return_left_mini"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(headerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [nextBtn setTag:100+section];
    [backView addSubview:nextBtn];
    
    [nextBtn makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(backView.height);
        make.centerY.equalTo(backView.centerY);
        make.trailing.equalTo(backView.trailing).offset(-15);
    }];
}

#pragma mark --头部按钮响应事件
- (void)headerBtnClicked:(UIButton *)sender{
    
}

@end
