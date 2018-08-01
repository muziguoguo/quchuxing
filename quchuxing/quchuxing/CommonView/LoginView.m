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

#define PhoneNumberLimit 11 //电话号码长度限制
#define VerCodeLimit 6      //验证码长度限制

@interface LoginView()<UITextFieldDelegate>
{
    bool _isValidMobile; //手机号是否合法
    UILabel *_loginLable;   //登录按钮标签
    NSInteger _seconds; //重发验证码秒数
}

@property (weak, nonatomic) IBOutlet UILabel *topTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *getVerCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIView *wxLoginView;
@property (weak, nonatomic) IBOutlet UILabel *unLoginLable;
@property (weak, nonatomic) IBOutlet UIButton *protocalBtn;
@property (nonatomic, assign) BOOL loginEnable;
@property (nonatomic, assign) BOOL getCodeEnable;

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
    
    [_passwordField setDelegate:self];

    [self setGetCodeEnable:NO];

    [_loginBtn.layer setCornerRadius:8];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setLoginEnable:NO];
    
    NSDictionary *attriDic = @{NSForegroundColorAttributeName:UICOLOR_FROM_RGB(255, 199, 77, 1), NSFontAttributeName:[UIFont systemFontOfSize:14]};
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"我已阅读并同意趣出行用户协议"];
    [attribute setAttributes:attriDic range:NSMakeRange(7, 7)];
    [_protocalBtn setAttributedTitle:attribute forState:UIControlStateNormal];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_loginBtn gradualBackgroundColorWithCornerRadius:8 borderWidth:0 colors:nil locations:nil];
    [_unLoginLable drawCornerWithRadius:8 borderWidth:0 borderColor:nil backgroundColor:UICOLOR_FROM_RGB(246, 246, 246, 1)];
}

#pragma mark --设置登录按钮是否可以点击
- (void)setLoginEnable:(BOOL)loginEnable{
    _loginEnable = loginEnable;
    _loginBtn.enabled = loginEnable;
    _unLoginLable.hidden = loginEnable;
}

#pragma mark --设置获取验证码按钮是否可点击
- (void)setGetCodeEnable:(BOOL)getCodeEnable{
    _getCodeEnable = getCodeEnable;
    _getVerCodeBtn.enabled = getCodeEnable;
    [_getVerCodeBtn setTitleColor:getCodeEnable?UICOLOR_FROM_RGB(40, 142, 239, 1):UICOLOR_FROM_RGB(203, 204, 207, 1) forState:UIControlStateNormal];
}

#pragma mark --手机号码文本框响应事件
- (IBAction)phoneNumberFieldChanged:(UITextField *)sender {
    NSInteger length = sender.text.length >PhoneNumberLimit ? PhoneNumberLimit : sender.text.length;
    if (length == PhoneNumberLimit) {
        sender.text = [sender.text substringWithRange:NSMakeRange(0, PhoneNumberLimit)];
        _isValidMobile = [self isValidMobile:_phoneNumberField.text];
        if (!_isValidMobile) {
            [[AlertView createSingleCase] showAlertMessage:@"手机号不合法" inView:self withCenter:_phoneNumberField.center];
        }
        else{
            self.getCodeEnable = YES;
            if (_passwordField.text.length == VerCodeLimit) {
                self.loginEnable = YES;
            }
        }
    }
    else{
        self.getCodeEnable = NO;
        self.loginEnable = NO;
    }
}

#pragma mark --验证码文本框响应事件
- (IBAction)passWordChanged:(UITextField *)sender {
    CGFloat length = sender.text.length>=VerCodeLimit ? VerCodeLimit : sender.text.length;
    if (length == VerCodeLimit) {
        sender.text = [sender.text substringWithRange:NSMakeRange(0, VerCodeLimit)];
        [self setLoginEnable:YES];
    }
    else{
        [self setLoginEnable:NO];
    }
}


#pragma mark --登录按钮响应事件
- (IBAction)clickedLoginBtn:(UIButton *)sender {
    
}

#pragma mark --获取验证码按钮响应事件
- (IBAction)clickedGetVerCodeBtn:(UIButton *)sender {
    _seconds = 60;
    self.getCodeEnable = NO;
    __WeakSelf__ weakTarget = self;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakTarget selector:@selector(timerResponse:) userInfo:nil repeats:YES];
}

#pragma mark --计时器响应事件
- (void)timerResponse:(NSTimer *)sender{
    _seconds--;
    if (_seconds == 0) {
        [_getVerCodeBtn setTitle:@"重新发送验证码" forState:UIControlStateNormal];
        [self setGetCodeEnable:YES];
        _seconds = 60;
        [sender invalidate];
        return;
    }
    NSString *title = [NSString stringWithFormat:@"%lds", _seconds];
    [_getVerCodeBtn setTitle:title forState:UIControlStateNormal];
}

#pragma mark --阅读协议按钮响应事件
- (IBAction)clickedProtocolBtn:(id)sender {
}

#pragma mark --微信登录按钮响应事件
- (IBAction)clickedWXLoginBtn:(id)sender {
}

#pragma mark --UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _passwordField && _phoneNumberField.text.length == 11 && _isValidMobile) {
        return YES;
    }
    else if (textField == _phoneNumberField){
        return YES;
    }
    else{
        [[AlertView createSingleCase] showAlertMessage:@"请输入正确的手机号" inView:self withCenter:_passwordField.center];
        return NO;
    }
}

#pragma mark --判断手机号是否合法
- (BOOL) isValidMobile:(NSString *)mobileNumbel{
    /**
     * 手机号码
     * 移动：134 135 136 137 138 139 147 150 151 152 157 158 159 178 182 183 184 187 188 198
     * 联通：130 131 132 145 155 156 166 171 175 176 185 186
     * 电信：133 149 153 173 177 180 181 189 199
     * 虚拟运营商: 170
     */
    NSString *target = @"^(0|86|17951)?(13[0-9]|15[012356789]|16[6]|19[89]]|17[01345678]|18[0-9]|14[579])[0-9]{8}$";
    NSPredicate *targetPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", target];
    if ([targetPredicate evaluateWithObject:mobileNumbel]) {
        return YES;
    }
    
    return NO;
}

#pragma mark --点击屏幕响应事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_passwordField resignFirstResponder];
    [_phoneNumberField resignFirstResponder];
}

@end
