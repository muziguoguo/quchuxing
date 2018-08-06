//
//  AppDelegate+Libs.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/24.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "AppDelegate+Libs.h"
#import "NetTool.h"
#import <UMShare/UMShare.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@implementation AppDelegate (Libs)

#pragma mark --配置三方
- (void)settingLibs{
    //配置网络
    [NetTool initAFNetframework];
    
    //向微信注册
    [WXApi registerApp:WXAppKey];
    
    //注册高德地图
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    [AMapServices sharedServices].apiKey =AMapAppKey;
}


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return [WXApi handleOpenURL:url delegate:self];
}

#pragma mark --WXApiDelegate
-(void) onReq:(BaseReq*)reqonReq{
    
}

-(void) onResp:(BaseResp*)resp{
    
}

@end
