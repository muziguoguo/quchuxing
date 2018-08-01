//
//  SignatureTool.h
//  BJEducation_student
//
//  Created by KuTian on 14-9-2.
//  Copyright (c) 2014年 Baijiahulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignatureTool : NSObject

/**
 *  通过Url auth_token key来生成signature
 *
 *  @param Url        请求的url
 *  @param auth_token 签名
 *  @param timestamp  时间戳
 *  @param key        本地保存的key
 */
+ (NSString *)createSignatureWithUrl:(NSString *)Url auth_token:(NSString *)auth_token api_key:(NSString *)key timestamp:(NSTimeInterval)timestamp;

@end
