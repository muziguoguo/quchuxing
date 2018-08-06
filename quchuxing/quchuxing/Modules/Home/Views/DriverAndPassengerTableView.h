//
//  DriverAndPassengerTableView.h
//  quchuxing
//
//  Created by 李伟国 on 2018/8/2.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#pragma mark --司机/乘客页滚动视图
#import <UIKit/UIKit.h>

typedef enum{
    kDriverPage,    //司机页
    kPassengerPage  //乘客页
} ViewType;

@interface DriverAndPassengerTableView : UITableView


/**
 初始化视图

 @param viewType 视图状态
 @return 视图对象
 */
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style viewType:(ViewType)viewType;

@end
