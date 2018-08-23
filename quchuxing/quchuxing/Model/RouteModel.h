//
//  RouteModel.h
//  quchuxing
//
//  Created by 李伟国 on 2018/8/6.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#pragma mark --路线模型
#import "BaseModel.h"

@interface RouteModel : BaseModel

@property (nonatomic, assign) NSNumber<Optional> *updateTime;

@property (nonatomic, copy) NSArray<NSNumber *><Optional> *start;

@property (nonatomic, assign) NSNumber<Optional> *phone;

@property (nonatomic, copy) NSString<Optional> *lineDesc;

@property (nonatomic, copy) NSArray<Optional> *waypoints;

@property (nonatomic, strong) NSArray<Optional> *autoDays;

@property (nonatomic, assign) NSNumber<Optional> *strategy;

@property (nonatomic, assign) NSNumber<Optional> *type;

@property (nonatomic, assign) NSNumber<Optional> *lineId;

@property (nonatomic, assign) NSNumber<Optional> *price;

@property (nonatomic, copy) NSArray<Optional> *waypointsAddress;

@property (nonatomic, assign) NSNumber<Optional> *createTime;

@property (nonatomic, assign) NSNumber<Optional> *seats;

@property (nonatomic, copy) NSArray<NSNumber *><Optional> *end;

@property (nonatomic, copy) NSString<Optional> *startAddress;

@property (nonatomic, copy) NSString<Optional> *startTime;

@property (nonatomic, assign) BOOL autoCreate;

@property (nonatomic, copy) NSString<Optional> *endAddress;

@end
