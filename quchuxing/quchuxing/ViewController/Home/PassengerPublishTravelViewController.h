//
//  PassengerPublishTravelViewController.h
//  quchuxing
//
//  Created by 李伟国 on 2018/8/13.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "BaseViewController.h"

@interface PassengerPublishTravelViewController : BaseViewController

@property (nonatomic, assign) BOOL isLoctaionSuccess;   //是否定位成功

- (instancetype)initWithType:(ViewType)type;

@end
