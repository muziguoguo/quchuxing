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
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationManager.locationTimeout =10;
        _locationManager.reGeocodeTimeout = 10;
    }
    return self;
}

- (void)startLocation{
    [_locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error == nil) {
            NSDictionary *userInfoDic= @{@"Location":location, @"ReGeocode":regeocode};
            [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdateSuccess object:nil userInfo:userInfoDic];
        }
        else{
            [[NSNotificationCenter defaultCenter] postNotificationName:LocationUpdateFailure object:nil userInfo:@{@"error":error.userInfo[NSLocalizedDescriptionKey]}];
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
