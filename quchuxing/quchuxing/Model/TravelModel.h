//
//  OrderModel.h
//  quchuxing
//
//  Created by 李伟国 on 2018/8/6.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#pragma mark --行程模型
#import "BaseModel.h"

@class Travel;
@interface  TravelModel: BaseModel

@property (nonatomic, copy) NSString *otherCarNumber;

@property (nonatomic, assign) BOOL attention;

@property (nonatomic, copy) NSString *endRecommend;

@property (nonatomic, strong) NSNumber *otherPhone;

@property (nonatomic, strong) Travel *travelVo;

@property (nonatomic, copy) NSString *otherPicture;

@property (nonatomic, copy) NSString *otherNickName;

@property (nonatomic, copy) NSString *startRecommend;

@property (nonatomic, copy) NSString *otherCar;

@property (nonatomic, strong) NSNumber * otherSex;

@end

@interface Travel : JSONModel

@property (nonatomic, assign) BOOL liked;

@property (nonatomic, strong) NSNumber *likesNum;

@property (nonatomic, copy) NSString *startAddress;

@property (nonatomic, strong) NSNumber *status;

@property (nonatomic, strong) NSNumber *passengerTravelId;

@property (nonatomic, copy) NSString *ordersId;

@property (nonatomic, copy) NSString *endAddress;

@property (nonatomic, strong) NSNumber *travelId;

@property (nonatomic, copy) NSString *startTimeTxt;

@property (nonatomic, strong) NSNumber *seats;

@property (nonatomic, copy) NSArray *headPictures;

@property (nonatomic, strong) NSNumber *sharesNum;

@property (nonatomic, strong) NSNumber *surplusSeats;

@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, copy) NSString *driverInfo;

@property (nonatomic, copy) NSString *waypoints;

@property (nonatomic, strong) NSNumber *ordersNum;

@property (nonatomic, assign) NSInteger redPacketPrice;

@property (nonatomic, assign) BOOL attention;

@property (nonatomic, copy) NSString *ordersTravelId;

@property (nonatomic, strong) NSNumber *pageViews;

@property (nonatomic, strong) NSNumber *travelPhone;

@property (nonatomic, strong) NSNumber *travelPrice;

@property (nonatomic, strong) NSArray<NSNumber *> *end;

@property (nonatomic, strong) NSNumber *commentsNum;

@property (nonatomic, strong) NSNumber *createTime;

@property (nonatomic, strong) NSNumber *startTime;

@property (nonatomic, strong) NSArray<NSNumber *> *start;

@end


