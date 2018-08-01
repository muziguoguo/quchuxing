//
//  LastIntroView.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/26.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "LastIntroView.h"
#import "UIView+Draw.h"

@interface LastIntroView()

@property (weak, nonatomic) IBOutlet UIButton *wxLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *phoneLoginBtn;
@property (weak, nonatomic) IBOutlet UIButton *visiLoginBtn;


@end

@implementation LastIntroView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [_wxLoginBtn.layer setCornerRadius:12];
    [_wxLoginBtn setBackgroundColor:UICOLOR_FROM_RGB(31, 215, 108, 1)];
    
    [_phoneLoginBtn.layer setCornerRadius:12];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_phoneLoginBtn gradualBackgroundColorWithCornerRadius:12 borderWidth:0 colors:nil locations:nil];
}


#pragma mark --点击微信登录按钮
- (IBAction)clickedWXLoginBtn:(UIButton *)sender {
    if (_clickedLogin) {
        DLog(@"%@", sender);
        _clickedLogin();
    }
}

#pragma mark --点击手机登录按钮
- (IBAction)clickedPhoneLoginBtn:(UIButton *)sender {
    if (_clickedLogin) {
        _clickedLogin();
    }
}

#pragma mark --点击游客登录按钮
- (IBAction)clickedVisitLoginBtn:(UIButton *)sender {
    if (_clickedLogin) {
        _clickedLogin();
    }
}


@end
