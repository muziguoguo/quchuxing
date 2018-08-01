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
#import "Response.h"
#import "SignatureTool.h"
#import "UIWindow+LastWindow.h"

@implementation NetTool

+ (void)initAFNetframework{
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
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
    [MBProgressHUD showHUDAddedTo:lastWindow animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:lastWindow animated:YES];
    });
}

+ (void)httpPostRequest:(NSString *)url WithFormdata:(NSMutableDictionary *)formData WithSuccess:(void (^)(Response *response))success failure:(void (^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
    responseSerializer.removesKeysWithNullValues = YES;
    manager.responseSerializer = responseSerializer;
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    [manager POST:url parameters:formData progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


@end







