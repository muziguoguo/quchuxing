//
//  HomeListViewModel.h
//  quchuxing
//
//  Created by 李伟国 on 2018/8/7.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeListViewModel : NSObject

@property (nonatomic, copy, nullable) NSMutableArray *passengerTravelDataArray;    //乘客行程数据
@property (nonatomic, copy, nullable) NSMutableArray *passengerRouteDataArray;     //乘客路线数据
@property (nonatomic, copy, nullable) NSMutableArray *driverTravelDataArray;    //车主行程数据
@property (nonatomic, copy, nullable) NSMutableArray *driverRouteDataArray;     //车主路线数据
@property (nonatomic, copy) void(^requestFinished)(void);

/**
 处理首页数据
 */
- (void)handleRequestWithSuccess:(void(^)(StatusCode statusCode))success
                      failure:(void (^)(NSError *error))failure;

@end










