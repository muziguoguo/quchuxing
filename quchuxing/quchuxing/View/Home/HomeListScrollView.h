//
//  HomeListScrollView.h
//  quchuxing
//
//  Created by 李伟国 on 2018/8/10.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeListScrollViewDelegate<NSObject>

@optional

/**
 选中某条cell
 
 @param indexPath cell的位置
 @param tableViewType 操作的tableView类型
 */
- (void)didSelectedRowOfIndexPath:(NSIndexPath *)indexPath inTableViewType:(ViewType)tableViewType;

/**
 点击添加路线按钮
 
 @param tableViewType 操作的tableView类型
 */
- (void)clickedAddRouteBtnInTableViewType:(ViewType)tableViewType;


/**
 点击某个块中的头部按钮
 
 @param tableViewType 操作的tableView类型
 @param section section下标
 */
- (void)clickedHeaderBtnInTableViewType:(ViewType)tableViewType section:(NSInteger)section;

@end

@interface HomeListScrollView : UIScrollView

@property (nonatomic, copy) NSArray *passengerTravels;
@property (nonatomic, copy) NSArray *passengerRoutes;
@property (nonatomic, copy) NSArray *driverTravels;
@property (nonatomic, copy) NSArray *driverRoutes;
@property (nonatomic, assign) BOOL tableScrollEnable;
@property (nonatomic, assign) BOOL showTopBarView;  //是否展示头部视图
@property (nonatomic, weak) id<HomeListScrollViewDelegate> responseDelegate;

- (void)reloadData;

@end
