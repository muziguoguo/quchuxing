//
//  MySearchResultView.h
//  iOS-trip-search
//
//  Created by hanxiaoming on 2017/5/24.
//  Copyright © 2017年 Amap. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyLocation;
@class MySearchResultView;

@protocol MySearchResultViewDelegate <NSObject>
@optional

/**
 点击地址cell

 @param listView 结果视图
 @param poi 地址点
 */
- (void)resultListView:(MySearchResultView *)listView didPOISelected:(MyLocation *)poi;

/**
 点击设置家的地址

 @param listView 结果视图
 @param home 家的地址
 */
- (void)resultListView:(MySearchResultView *)listView didHomeSelected:(MyLocation *)home;

/**
 点击设置公司地址

 @param listView 结果视图
 @param company 公司地址
 */
- (void)resultListView:(MySearchResultView *)listView didCompanySelected:(MyLocation *)company;


/**
 结果视图滚动

 @param listView 结果视图
 */
- (void)didResultListViewScroll:(MySearchResultView *)listView;


/**
 结果视图停止滚动

 @param listView 结果视图
 */
- (void)didResultListViewEndScroll:(MySearchResultView *)listView;

@end

@interface MySearchResultView : UIView
@property (nonatomic, weak) id<MySearchResultViewDelegate> delegate;

@property (nonatomic, strong) NSArray<MyLocation *> *poiArray;
@property (nonatomic, strong) NSArray<MyLocation *> *historyArray;

@property (nonatomic, assign) BOOL showsAddressSettingCell; // 默认YES

@property (nonatomic, readonly) MyLocation *home;
@property (nonatomic, readonly) MyLocation *company;

- (void)updateAddressSetting;
- (void)searchTipsByKeyword:(NSString *)keyword;

@end
