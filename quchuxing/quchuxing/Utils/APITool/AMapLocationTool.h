//
//  AMapLocationTool.h
//  quchuxing
//
//  Created by 李伟国 on 2018/7/31.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface AMapLocationTool : NSObject

@property (nonatomic, strong) NSString *locationText;
@property (nonatomic, assign) BOOL locationSuccess;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, strong) CLLocation *location;

+ (AMapLocationTool *)sharedAMapLocation;

/**
 开始单次定位

 @param success 定位成功回调
 @param failure 定位失败回调
 */
- (void)startLocationWithSuccess:(void (^)(NSDictionary *infoDic))success
                         failure:(void (^)(NSError *error))failure;

@end
