//
//  ArrountPoiView.h
//  quchuxing
//
//  Created by 李伟国 on 2018/8/21.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AMapPOI;
@protocol ArrountPoiViewDelegate<NSObject>

/**
 选中某条cell

 @param poiData poi数据
 */
- (void)selectedCellWithPoiData:(AMapPOI *)poiData;

/**
 刷新头部
 
 @param page 页码
 */
- (void)headerRefreshWithPage:(NSInteger)page;

/**
 刷新尾部
 
 @param page 页码
 */
- (void)footerRefreshWithPage:(NSInteger)page;

@end

@interface ArrountPoiView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSArray *poiArray;
@property (nonatomic, weak) id<ArrountPoiViewDelegate> delegate;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) BOOL isRefreshHeader;
@property (nonatomic, assign) BOOL isRefreshFooter;

@end
