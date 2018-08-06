//
//  LoginView.h
//  quchuxing
//
//  Created by 李伟国 on 2018/7/31.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#pragma mark --登录视图
#import <UIKit/UIKit.h>

typedef enum{
    kLaunchWithLogin = 0,   //首次进入程序时登录
    kLoginWithWeChat = 1,   //通过微信登录（未绑定手机号）
    kWithoutLogin = 2           //未登录
} LoginType;

@interface LoginView : UIView

@property (nonatomic, assign) LoginType loginType;
@property (nonatomic, copy) void (^dismissVC)(void);

@end
