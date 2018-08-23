//
//  HomeTopView.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/8.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "HomeTopView.h"

@interface HomeTopView()

#pragma mark --未登录样式
@property (weak, nonatomic) IBOutlet UIView *unLoginView;
@property (weak, nonatomic) IBOutlet UIButton *makeMoneyBtn;

#pragma mark --登录样式
@property (weak, nonatomic) IBOutlet UIView *loginTypeView;
@property (weak, nonatomic) IBOutlet UILabel *forceNumLabel;

@end

@implementation HomeTopView

- (void)awakeFromNib{
    [super awakeFromNib];
    [_makeMoneyBtn.layer setCornerRadius:8];
}

#pragma mark --缩放头部视图
- (void)zoomViewWithScale:(CGSize)scale{
    if (_loginType == 0) {
        _unLoginView.transform = CGAffineTransformMakeScale(scale.width, scale.height);
    }
    else{
        _loginTypeView.transform = CGAffineTransformMakeScale(scale.width, scale.height);
    }
}

#pragma mark --按钮响应事件
- (IBAction)clickedMakeMoneyBtn:(UIButton *)sender {
}

- (IBAction)clickedRolesDescripBtn:(UIButton *)sender {
}

- (IBAction)clickedGetForceBtn:(UIButton *)sender {
}


@end








