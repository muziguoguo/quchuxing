//
//  RouteOrTripTableViewCell.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/3.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "RouteOrTripTableViewCell.h"

@interface RouteOrTripTableViewCell()
#pragma mark --未登录状态常用路线控件
@property (weak, nonatomic) IBOutlet UIView *withoutLoginRouteView;
@property (weak, nonatomic) IBOutlet UIButton *addRouteBtn;
@property (weak, nonatomic) IBOutlet UILabel *getFiftyLabel;

#pragma mark --登录状态待完成行程
@property (weak, nonatomic) IBOutlet UILabel *tripTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripStartLocatLable;
@property (weak, nonatomic) IBOutlet UILabel *tripEndLocatLabel;

#pragma mark --登录状态常用路线控件
@property (weak, nonatomic) IBOutlet UILabel *routeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeStartLocateLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeEndLocateLabel;

@end

@implementation RouteOrTripTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setBackgroundColor:kAppMainLightGrayColor];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_cellType == kWithoutLoginUsualRoute) {
        [_withoutLoginRouteView.layer setCornerRadius:10];
        [_addRouteBtn.layer setCornerRadius:8];
        [_addRouteBtn.layer setBorderWidth:1];
        [_addRouteBtn.layer setBorderColor:UICOLOR_FROM_RGB(200, 201, 204, 1).CGColor];
        [_getFiftyLabel drawCornerWithRadius:8  connerDirect:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight borderWidth:0 borderColor:nil backgroundColor:UICOLOR_FROM_RGB(255, 152, 0, 1)];
    }
    else if (_cellType == kLoginUsualRoute){
        [_routeTypeLabel drawCornerWithRadius:2 connerDirect:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight borderWidth:0 borderColor:nil backgroundColor:UICOLOR_FROM_RGB(108, 113, 128, 1)];
    }
}

#pragma mark --配置数据
- (void)setDataWithModel:(BaseModel *)dataModel{
#warning 替换真实数据
    if (_cellType == kLoginTrip) {
        _tripTimeLabel.text = @"今天9:30，待上车";
        _tripStartLocatLable.text = @"上地创新大厦";
        _tripEndLocatLabel.text = @"西小口地铁站";
    }
    else if (_cellType == kLoginUsualRoute){
        _routeTypeLabel.text = @"下班";
        _routeTimeLabel.text = @"18:00";
        _routeStartLocateLabel.text = @"上地三街信息路26号创新大厦";
        _routeEndLocateLabel.text = @"北四环西路68号左岸工社";
    }
}

#pragma mark -- 添加路线按钮响应事件
- (IBAction)clickedAddRouteBtn:(UIButton *)sender {
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
