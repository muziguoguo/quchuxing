//
//  AddressTableViewCell.h
//  quchuxing
//
//  Created by 李伟国 on 2018/8/13.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@class AddressCellView;
@protocol AddressCellViewDelegate<NSObject>

/**
 删除指定位置的cell

 @param index 下标
 */
- (void)deleteCellAtIndex:(NSInteger)index;

/**
 搜索文本改变

 @param addressCell 自身
 */
- (void)searchValueChangedInAddressCell:(AddressCellView *)addressCell;

/**
 正在编辑的文本框

 @param addressCell 自身
 */
- (void)editTextFieldInAddressCell:(AddressCellView *)addressCell;


/**
 点击了搜索按钮

 @param addressCell 自身
 */
- (void)clickedTextFieldReturnBtnInAddressCell:(AddressCellView *)addressCell;

/**
 点击折叠视图
 */
- (void)tapFoldAddressView;

@end

@interface AddressCellView : UIView

@property (nonatomic, copy) NSString *content;
@property (nonatomic, weak) id<AddressCellViewDelegate> delegate;
@property (nonatomic, assign) BOOL isLocation;  //是否定位
@property (nonatomic, strong) AMapGeoPoint *geoPoint;
@property (nonatomic, assign) BOOL isFold; //是否是合并样式


/**
 为视图配置数据

 @param index 下标
 @param totals 总数
 */
- (void)contentForCellWithIndex:(NSInteger)index totals:(NSInteger)totals;


@end
