//
//  APIClient.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/25.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "APIClient.h"
#import "Urls.h"
#import "NetTool.h"

@implementation APIClient

#pragma mark --请求错误信息
+ (NSString *)errorMessageWithResponse:(id)response{
    NSString *message = nil;
    switch ([response[@"status"] integerValue]) {
        case kSuccess:
            message = @"请求成功";
            break;
        case kUnLogin:
            message = @"还没有登录哦~";
            break;
        case kServerError:
            message = @"服务器发生错误";
            break;
        case kVerifiCodeError:
            message = @"验证码错误";
            break;
        case kParameterError:
            message = @"请求参数错误";
            break;
        case kDriverAduitFaild:
            message = @"司机审核未通过哦~";
            break;
        default:
            break;
    }
    return message;
}

#pragma mark --获取验证码
+ (void)networkPostGetCaptchaWithPhone:(NSInteger)phone success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *formData = [NSMutableDictionary dictionary];
    [formData setValue:@(phone) forKey:@"phone"];
    [NetTool httpPostRequest:kApi_Post_SendCaptcha WithFormdata:formData WithSuccess:^(id response) {
        success(response);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

#pragma mark --登录
+ (void)networkPostLoginWithPhone:(NSInteger)phone captcha:(NSInteger)captcha idfa:(NSString *)idfa success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSMutableDictionary *formData = [NSMutableDictionary dictionary];
    [formData setValue:@(phone) forKey:@"phone"];
    [formData setValue:@(captcha) forKey:@"captcha"];
    [formData setValue:idfa forKey:@"idfa"];
    [NetTool httpPostRequest:kApi_Post_Login WithFormdata:formData WithSuccess:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end















