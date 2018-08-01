//
//  LoginView.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/31.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "LoginView.h"
#import <WXApi.h>
#import "LimitInputLength.h"
#import "UIView+Draw.h"
#import "AlertView.h"

@interface LoginView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *getVerCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *wxLoginView;


@end

@implementation LoginView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUpView];
}

- (void)setLoginType:(LoginType)loginType{
    if (loginType) {
        _loginType = loginType;
        _topTitleLabel.text = loginType==kLoginWithWeChat?@"绑定手机号":@"注册/登录";
        if (loginType == kUnLogin && [WXApi isWXAppInstalled]) {
            [_wxLoginView setHidden:NO];
        }
    }
}

#pragma mark --配置子视图
- (void)setUpView{
    [self.layer setCornerRadius:8];
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [_phoneNumberField setDelegate:self];
    [_phoneNumberField setLimitCount:@11];

    [_passwordField setDelegate:self];
    
    [_loginBtn.layer setCornerRadius:8];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_loginBtn gradualBackgroundColorWithCornerRadius:8 borderWidth:0 colors:nil locations:nil];
}

#pragma mark --按钮响应事件
- (IBAction)clickedLoginBtn:(UIButton *)sender {
}

- (IBAction)clickedGetVerCodeBtn:(UIButton *)sender {
}

- (IBAction)clickedCategoryBtn:(id)sender {
}

- (IBAction)clickedWXLoginBtn:(id)sender {
}

#pragma mark --UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _passwordField && _phoneNumberField.text.length == 11) {
        return YES;
    }
    else if (textField == _phoneNumberField){
        return YES;
    }
    else{
        [[AlertView createSingleCase] showAlertMessage:@"请输入正确的手机号" withCenter:_passwordField.center];
        return NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

#pragma mark --点击屏幕响应事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_passwordField resignFirstResponder];
    [_phoneNumberField resignFirstResponder];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

@end
