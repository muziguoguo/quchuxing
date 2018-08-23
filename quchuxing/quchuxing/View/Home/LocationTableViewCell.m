//
//  LocationTableViewCell.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/2.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "LocationTableViewCell.h"

@interface LocationTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UILabel *getForceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;


@end

@implementation LocationTableViewCell

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationNotiResponse:) name:StartLocationNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationNotiResponse:) name:LocationUpdateSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationNotiResponse:) name:LocationUpdateFailureNotification object:nil];

    [self.contentView setBackgroundColor:kAppMainLightGrayColor];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [_getForceLabel drawCornerWithRadius:8 connerDirect:UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight borderWidth:0 borderColor:nil backgroundColor:UICOLOR_FROM_RGB(255, 152, 0, 1)];
    [_locationView setBackgroundColor:[UIColor whiteColor]];
    [_locationView.layer setCornerRadius:10];
}

- (void)setLocationText:(NSString *)locationText{
    if (locationText) {
        _locationLabel.text = locationText;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark --通知响应事件
- (void)locationNotiResponse:(NSNotification *)noti{
    NSString *content = nil;
    if ([noti.name isEqualToString:StartLocationNotification]) {
        content = @"正在获取当前位置";
    }
    else if ([noti.name isEqualToString:LocationUpdateSuccessNotification]){
        content = [noti.userInfo[@"ReGeocode"] valueForKeyPath:@"POIName"];
    }
    else{
        content = @"定位失败";
    }
    _locationLabel.text = content;
}

@end
