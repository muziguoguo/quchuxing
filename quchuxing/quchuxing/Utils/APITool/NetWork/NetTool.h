//
//  NetTool.h
//  quchuxing
//
//  Created by 李伟国 on 2018/7/25.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Response;


@interface NetTool : NSObject

/**
 初始化配置
 */
+ (void)initAFNetframework;

/**
 *    捕获网络异常
 *
 *    @param    error    网络异常错误
 */
+ (void)handleAFHttpNetworkError:(NSError *)error;


/**
 发送Post请求

 @param url 请求地址
 @param formData 请求参数字典集合
 @param success 请求成功回调
 @param failure 请求失败回调
 */
+ (void)httpPostRequest:(NSString *)url WithFormdata:(NSMutableDictionary *)formData WithSuccess:(void (^)(Response *response))success failure:(void (^)(NSError *error))failure;

@end











