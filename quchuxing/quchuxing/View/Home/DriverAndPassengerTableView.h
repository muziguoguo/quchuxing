//
//  DriverAndPassengerTableView.h
//  quchuxing
//
//  Created by 李伟国 on 2018/8/2.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#pragma mark --司机/乘客页滚动视图
#import <UIKit/UIKit.h>

@interface DriverAndPassengerTableView : UITableView

@property (nonatomic, strong) NSArray *routeArray;
@property (nonatomic, strong) NSArray *travelArray;
@property (nonatomic, copy) void (^selectedRow)(UITableView *tableView, NSIndexPath *indexPath);    //选中某条cell
@property (nonatomic, copy) void (^clickedAddRouteBtn)(UITableView *tableView); //点击添加路线按钮
@property (nonatomic, copy) void (^clickedHeaderBtn)(UITableView *tableView, NSInteger section);    //点击某个块中的头部按钮

/**
 初始化视图

 @param viewType 视图状态
 @return 视图对象
 */
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style viewType:(ViewType)viewType;


@end
