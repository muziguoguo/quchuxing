//
//  RouteOrTripTableViewCell.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/3.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "RouteOrTripTableViewCell.h"
#import "TravelModel.h"
#import "RouteModel.h"
#import "NSString+Utils.h"

@interface RouteOrTripTableViewCell()

#pragma mark --未登录状态常用路线控件
@property (weak, nonatomic) IBOutlet UIView *withoutLoginRouteView;
@property (weak, nonatomic) IBOutlet UIButton *addRouteBtn;
@property (weak, nonatomic) IBOutlet UILabel *getFiftyLabel;

#pragma mark --登录状态控件

@property (weak, nonatomic) IBOutlet UIImageView *tripIconImgView;
@property (weak, nonatomic) IBOutlet UILabel *tripTypeLabel;
@property (weak, nonatomic) IBOutlet UIView *routeView;
@property (weak, nonatomic) IBOutlet UILabel *routeTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *routeDetailView;
@property (weak, nonatomic) IBOutlet UILabel *routeStartLocateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *routeArrawImaView;
@property (weak, nonatomic) IBOutlet UILabel *routeEndLocateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *routeBackImgView;
@property (weak, nonatomic) IBOutlet UIView *routeLineView;

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
        [_withoutLoginRouteView drawCornerWithRadius:10 connerDirect:UIRectCornerBottomLeft | UIRectCornerBottomRight borderWidth:0 borderColor:nil backgroundColor:[UIColor whiteColor]];
        [_addRouteBtn.layer setCornerRadius:8];
        [_addRouteBtn.layer setBorderWidth:1];
        [_addRouteBtn.layer setBorderColor:UICOLOR_FROM_RGB(200, 201, 204, 1).CGColor];
        [_getFiftyLabel drawCornerWithRadius:8  connerDirect:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight borderWidth:0 borderColor:nil backgroundColor:UICOLOR_FROM_RGB(255, 152, 0, 1)];
    }
    else{
        _routeView.frame = CGRectMake(8, 0, self.contentView.cur_w-16, self.contentView.cur_h);
        _routeBackImgView.frame = CGRectMake(_routeView.cur_w-8-15, (_routeView.cur_h-14)/2, 8, 14);
        _routeLineView.frame = CGRectMake(15, _routeView.cur_h-0.5, _routeView.cur_w-15, 0.5);
    }
}

#pragma mark cv-根据数据动态配置子视图框架
- (void)setDynamicLayoutWithDataModel:(BaseModel *)dataModel{
    if (_cellType == kLoginTrip) {
        TravelModel *commonModel = (TravelModel *)dataModel;
        _routeTypeLabel.hidden = YES;
        _routeTimeLabel.hidden = YES;
        _tripIconImgView.frame = CGRectMake(15, 27, 24, 24);
        _tripTypeLabel.frame = CGRectMake(_tripIconImgView.cur_x_w+15, 15, _routeBackImgView.cur_x-_tripIconImgView.cur_x_w-30, 20);
        _routeDetailView.frame = CGRectMake(_tripTypeLabel.cur_x, _tripTypeLabel.cur_y_h+6, _tripTypeLabel.cur_w, 20);
        [self setRouteDetailFrameWithStartAddress:commonModel.travelVo.startAddress];
    }
    else if (_cellType == kLoginUsualRoute){
        RouteModel *routeModel = (RouteModel *)dataModel;
        _tripIconImgView.hidden = YES;
        _tripTypeLabel.hidden = YES;
        
        CGFloat width = [routeModel.lineDesc widthWithHeigth:14 font:[UIFont systemFontOfSize:10]];
        _routeTypeLabel.frame = CGRectMake(15, 15, width==0?0:width+6, 14);
        [_routeTypeLabel drawCornerWithRadius:2 connerDirect:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight borderWidth:0 borderColor:nil backgroundColor:UICOLOR_FROM_RGB(108, 113, 128, 1)];
        
        _routeTimeLabel.frame = CGRectMake(_routeTypeLabel.cur_x_w+3, _routeTypeLabel.cur_y, _routeBackImgView.cur_x-_routeTypeLabel.cur_x_w-18, _routeTypeLabel.cur_h);
        _routeDetailView.frame = CGRectMake(15, _routeTimeLabel.cur_y_h+6, _routeBackImgView.cur_x-30, 20);
        [self setRouteDetailFrameWithStartAddress:routeModel.startAddress];
    }
}

- (void)setRouteDetailFrameWithStartAddress:(NSString *)startAddress{
    CGFloat startAddressWidth = [startAddress widthWithHeigth:20 font:[UIFont systemFontOfSize:14]];
    startAddressWidth = startAddressWidth>(_routeDetailView.cur_w-10)/2?(_routeDetailView.cur_w-10)/2:startAddressWidth;
    _routeStartLocateLabel.frame = CGRectMake(0, 0, startAddressWidth, _routeDetailView.cur_h);
    _routeArrawImaView.frame = CGRectMake(_routeStartLocateLabel.cur_x_w+2, (_routeDetailView.cur_h-20)/2, 20, 20);
    _routeEndLocateLabel.frame = CGRectMake(_routeArrawImaView.cur_x_w, 0, _routeDetailView.cur_w-_routeStartLocateLabel.cur_x_w-24, _routeStartLocateLabel.cur_h);
}

#pragma mark --配置数据
- (void)setDataWithModel:(BaseModel *)dataModel{
    [self setDynamicLayoutWithDataModel:dataModel];
    if (_cellType == kLoginTrip) {
        TravelModel *commonModel = (TravelModel *)dataModel;
        _tripTypeLabel.text = [NSString stringWithFormat:@"%@", commonModel.travelVo.startTimeTxt];
        _routeStartLocateLabel.text = commonModel.travelVo.startAddress;
        _routeEndLocateLabel.text = commonModel.travelVo.endAddress;
    }
    else if (_cellType == kLoginUsualRoute){
        RouteModel *routeModel = (RouteModel *)dataModel;
        _routeTypeLabel.text = routeModel.lineDesc;
        _routeTimeLabel.text = routeModel.startTime;
        _routeStartLocateLabel.text = routeModel.startAddress;
        _routeEndLocateLabel.text = routeModel.endAddress;
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius{
    if (_cellType != kWithoutLoginUsualRoute) {
        [_routeView drawCornerWithRadius:cornerRadius connerDirect:UIRectCornerBottomLeft | UIRectCornerBottomRight borderWidth:0 borderColor:nil backgroundColor:[UIColor whiteColor] bounds:CGRectMake(0, 0, self.contentView.cur_w-8*2, self.contentView.cur_h)];
        _routeLineView.frame = CGRectMake(15, _routeView.cur_h-0.5, _routeView.cur_w-15, 0);
    }
}

#pragma mark -- 添加路线按钮响应事件
- (IBAction)clickedAddRouteBtn:(UIButton *)sender {
    if (_clickedAddBtn) {
        _clickedAddBtn();
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
