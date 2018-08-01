//
//  Response.h
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

#pragma mark --回调数据模型
@interface Response : NSObject

@property (assign, nonatomic) StatusCode code;
@property (strong, nonatomic) NSObject *result;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSObject *common;

- (id)initWithDictionary:(NSDictionary *)dic;

- (Response *)initWithState:(NSInteger)state result:(NSObject *)data common:(NSObject *)common message:(NSString *)msg;

- (NSString *)description;
@end

