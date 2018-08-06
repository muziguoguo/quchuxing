//
//  NetTool.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/25.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "NetTool.h"
#import <AFNetworking.h>
#import <MBProgressHUD.h>
#import "SignatureTool.h"
#import "UIWindow+LastWindow.h"

@implementation NetTool

+ (void)initAFNetframework{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [AFHTTPSessionManager manager].securityPolicy = [NetTool customSecurityPolicy];
}

#pragma mark - 载入和保存cookie
+ (void)saveCookies{
    NSData *cookiesData = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject: cookiesData forKey: @"sessionCookies"];
    [defaults synchronize];
}

+ (void)loadCookies{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey: @"sessionCookies"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in cookies){
        [cookieStorage setCookie: cookie];
    }
}


+ (void)handleAFHttpNetworkError:(NSError *)error{
    UIWindow *lastWindow = [UIWindow lastWindow];
    [MBProgressHUD hideHUDForView:lastWindow animated:NO];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:lastWindow animated:YES];
    [hud.label setText:error.description];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:lastWindow animated:YES];
    });
}

+ (void)httpPostRequest:(NSString *)url WithFormdata:(NSMutableDictionary *)formData WithSuccess:(void (^)(id response))success failure:(void (^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = responseSerializer;
    manager.requestSerializer = requestSerializer;
    
    [manager POST:url parameters:formData progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (AFSecurityPolicy*)customSecurityPolicy
{
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"qcxn" ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    
    securityPolicy.pinnedCertificates =@[certData];
    
    return securityPolicy;
}

@end







