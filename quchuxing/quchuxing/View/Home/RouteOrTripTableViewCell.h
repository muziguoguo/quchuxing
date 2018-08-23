//
//  RouteOrTripTableViewCell.h
//  quchuxing
//
//  Created by 李伟国 on 2018/8/3.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#pragma mark --常用路线/待完成行程cell
#import <UIKit/UIKit.h>
typedef enum{
    kWithoutLoginUsualRoute,    //未登录状态常用路线
    kLoginUsualRoute,   //登录状态常用路线
    kLoginTrip  //登录状态行程
} RouteOrTripCellType;

@class BaseModel;
@interface RouteOrTripTableViewCell : UITableViewCell

@property (nonatomic, assign) RouteOrTripCellType cellType;    //设置cell样式
@property (nonatomic, copy) void(^clickedAddBtn)(void);    //点击添加按钮回调事件
@property (nonatomic, assign) CGFloat cornerRadius; //配置圆角


/**
 通过数据模型为cell配置数据

 @param dataModel 数据模型
 */
- (void)setDataWithModel:(BaseModel *)dataModel;


@end
