//
//  APIClient.h
//  quchuxing
//
//  Created by 李伟国 on 2018/7/25.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum:NSInteger{
    kSuccess = 200, //请求成功
    kUnLogin = -1,  //未登录
    kServerError = -2, //服务器发生错误
    kVerifiCodeError = -3,  //验证码错误
    kParameterError = -4,   //参数错误
    kDriverAduitFaild = -5  //司机审核未通过
} StatusCode;

@interface APIClient : NSObject


/**
 获取请求错误码信息

 @param response 请求回执数据
 @return 错误描述
 */
+ (NSString *)errorMessageWithResponse:(id)response;

/**
 获取验证码

 @param phone 手机号
 @param success 请求成功回调
 @param failure 请求失败回调
 */
+ (void)networkPostGetCaptchaWithPhone:(NSInteger)phone
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *error))failure;


/**
 登录

 @param phone 手机号
 @param captcha 验证码
 @param idfa 设备唯一标识
 @param success 请求成功回调
 @param failure 请求失败回调
 */
+ (void)networkPostLoginWithPhone:(NSInteger)phone
                          captcha:(NSInteger)captcha
                             idfa:(NSString *_Nonnull)idfa
                          success:(void (^)(id response))success
                          failure:(void (^)(NSError *error))failure;

@end
