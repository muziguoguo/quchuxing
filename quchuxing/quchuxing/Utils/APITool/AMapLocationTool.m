//
//  AMapLocationTool.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/31.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "AMapLocationTool.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface AMapLocationTool()
{
    AMapLocationManager *_locationManager;
}

@end

@implementation AMapLocationTool

+ (AMapLocationTool *)sharedAMapLocation{
    static AMapLocationTool *amapLocation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (amapLocation == nil) {
            amapLocation = [[super allocWithZone:NULL] init];
        }
    });
    return amapLocation;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _locationManager = [[AMapLocationManager alloc] init];
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        _locationManager.locationTimeout =3;
        _locationManager.reGeocodeTimeout = 3;
        _locationSuccess = NO;
    }
    return self;
}

- (void)startLocationWithSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    _locationText = @"正在获取当前位置";
    _locationSuccess = NO;
    _city = @"北京";
    _location = nil;
    __WeakSelf__ weakSelf = self;
    [[NSNotificationCenter defaultCenter] postNotificationName:StartLocationNotification object:nil];
    [_locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error == nil) {
            weakSelf.locationText = regeocode.POIName;
            weakSelf.locationSuccess = YES;
            if ([regeocode.city containsString:@"市"]) {
                weakSelf.city = [regeocode.city substringWithRange:NSMakeRange(0, regeocode.city.length-1)];
            }
            else{
                weakSelf.city = regeocode.city;
            }
            weakSelf.location = location;
            NSDictionary *userInfoDic= @{@"Location":location, @"ReGeocode":regeocode};
            [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdateSuccessNotification object:nil userInfo:userInfoDic];
            if (success) {
                success(userInfoDic);
            }
        }
        else{
            weakSelf.city = @"北京";
            weakSelf.locationText = @"定位失败";
            weakSelf.locationSuccess = NO;
            weakSelf.location = nil;
            DLog(@"定位失败码：%ld", error.code);
            NSDictionary *userInfoDic= @{@"Error":error};
            [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdateFailureNotification object:nil userInfo:userInfoDic];
            if (failure) {
                failure(error);
            }
        }
    }];
}

#pragma mark --完整单例实现
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [AMapLocationTool sharedAMapLocation];
}

- (id)copy{
    return [AMapLocationTool sharedAMapLocation];
}

- (id)mutableCopy{
    return [AMapLocationTool sharedAMapLocation];
}

@end
