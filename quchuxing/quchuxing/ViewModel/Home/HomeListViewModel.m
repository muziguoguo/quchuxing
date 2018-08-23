//
//  HomeListViewModel.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/7.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "HomeListViewModel.h"
#import "RouteModel.h"
#import "TravelModel.h"

@interface HomeListViewModel()

@property (nonatomic, strong) id passengerResponse;
@property (nonatomic, strong) id driverResponse;

@end

@implementation HomeListViewModel

#pragma mark --处理数据
- (void)handleRequestWithSuccess:(void (^)(StatusCode))success failure:(void (^)(NSError *))failure{
    __WeakSelf__ weakSelf = self;
    UserModel *userInfo = [UserDefault sharedUserDefault].userInfo;
    [APIClient networkPostHomeListWithToken:userInfo.token success:^(id response) {
        if ([response[@"status"] integerValue] == kSuccess) {
            if (((NSDictionary *)response[@"driver"]).count != 0) {
                [self handleDriverData:response[@"driver"]];
            }
            if (((NSDictionary *)response[@"passenger"]).count != 0){
                [weakSelf handlePassengerData:response[@"passenger"]];
            }
            if (success) {
                success([response[@"status"] integerValue]);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark --处理车主数据
- (void)handleDriverData:(NSDictionary *)response{
    [self.driverRouteDataArray removeAllObjects];
    [self.driverTravelDataArray removeAllObjects];
    __WeakSelf__ weakSelf = self;
    //处理行程
    [response[@"driverTravel"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TravelModel *travelModel = [[TravelModel alloc] initWithDic:obj];
        [weakSelf.driverTravelDataArray addObject:travelModel];
    }];
    
    //处理路线
    [response[@"driverLine"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RouteModel *routeModel = [[RouteModel alloc] initWithDic:obj];
        [self.driverRouteDataArray addObject:routeModel];
    }];
}

#pragma mark --处理乘客数据
- (void)handlePassengerData:(id)response{
    [self.passengerRouteDataArray removeAllObjects];
    [self.passengerTravelDataArray removeAllObjects];
    __WeakSelf__ weakSelf = self;
    //处理行程
    [response[@"passengerTravel"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TravelModel *travelModel = [[TravelModel alloc] initWithDic:obj];
        [weakSelf.passengerTravelDataArray addObject:travelModel];
    }];
    
    //处理路线
    [response[@"passengerLine"] enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSError *error = nil;
        RouteModel *routeModel = [[RouteModel alloc] initWithDictionary:obj error:&error];
        [weakSelf.passengerRouteDataArray addObject:routeModel];
    }];

}

#pragma mark --懒加载集合对象
- (NSMutableArray *)passengerTravelDataArray{
    if (!_passengerTravelDataArray) {
        _passengerTravelDataArray = [NSMutableArray array];
    }
    return _passengerTravelDataArray;
}

- (NSMutableArray *)passengerRouteDataArray{
    if (!_passengerRouteDataArray) {
        _passengerRouteDataArray = [NSMutableArray array];
    }
    return _passengerRouteDataArray;
}

- (NSMutableArray *)driverTravelDataArray{
    if (!_driverTravelDataArray) {
        _driverTravelDataArray = [NSMutableArray array];
    }
    return _driverTravelDataArray;
}

- (NSMutableArray *)driverRouteDataArray{
    if (!_driverRouteDataArray) {
        _driverRouteDataArray = [NSMutableArray array];
    }
    return _driverRouteDataArray;
}

@end






