//
//  SignatureTool.m
//  BJEducation_student
//
//  Created by KuTian on 14-9-2.
//  Copyright (c) 2014年 Baijiahulian. All rights reserved.
//

#import "SignatureTool.h"
#import "NSString+MD5.h"

@interface SignatureTool()
/**
 *  分割url取出group action host等
 *
 *  @param url   url字段
 *
 *  @return url 格式成的字典{@"group":@{},@"action":@{},@"host":@{}}
 */
+ (NSDictionary *)transformUrl:(NSString *)url;

/**
 *  生成signature签名
 *
 *  @param group      group字段
 *  @param action     action字段
 *  @param auth_token 返回的签名
 *  @param timestamp  当前时间戳
 *  @param api_key    api_key
 *
 *  @return signature(md5)
 */
+ (NSString *)cretaSignatureWithGroup:(NSString *)group action:(NSString *)action auth_token:(NSString *)auth_token timestamp:(NSTimeInterval)timestamp api_key:(NSString *)api_key;

@end

@implementation SignatureTool

+ (NSString *)createSignatureWithUrl:(NSString *)Url auth_token:(NSString *)auth_token api_key:(NSString *)key timestamp:(NSTimeInterval)timestamp
{
    NSDictionary *urlDic = [self transformUrl:Url];
    NSString *group = [urlDic valueForKey:@"group"];
    NSString *action = [urlDic valueForKey:@"action"];
    NSTimeInterval timestamp1 = timestamp;
    return [self cretaSignatureWithGroup:group action:action auth_token:auth_token timestamp:timestamp1 api_key:key];
}

+ (NSString *)cretaSignatureWithGroup:(NSString *)group action:(NSString *)action auth_token:(NSString *)auth_token timestamp:(NSTimeInterval)timestamp api_key:(NSString *)api_key
{
    NSString *signature = nil;
    if (auth_token && ![auth_token isEqualToString:@""]) {
        signature = [NSString stringWithFormat:@"%@%@%@%.0f%@",auth_token,group,action,timestamp,api_key];
    }
    else
    {
        signature = [NSString stringWithFormat:@"%@%@%.0f%@",group,action,timestamp,api_key];
    }
//    DLog(@"signature:%@",signature);
//    DLog(@"group:%@ action:%@ auth_token:%@ api_key:%@ timestamp:%.0f",group,action,auth_token,api_key,timestamp);
    return [signature md5Encryption];
}

+(NSDictionary *)transformUrl:(NSString *)url
{
    //取出http:// /https:// 等开头
    if ([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) {
        if ([url hasPrefix:@"http://"]) {
            url = [url substringFromIndex:[@"http://" length]];
        }
        else
        {
            url = [url substringFromIndex:[@"https://" length]];
        }
    }
    
    //转换成数组
    NSArray *arr = [url componentsSeparatedByString:@"/"];
    NSAssert([arr count]>=3, @"signature url长度 生出失败");
    
    NSString *host = [arr objectAtIndex:0];
    host = [@"http://" stringByAppendingFormat:@"%@",host];
    NSString *group = [arr objectAtIndex:1];
    NSString *action = [arr objectAtIndex:2];
    return @{@"host":host,@"group":group,@"action":action};
}


@end
