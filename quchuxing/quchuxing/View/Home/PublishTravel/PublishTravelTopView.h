//
//  PublishTravelTopView.h
//  quchuxing
//
//  Created by 李伟国 on 2018/8/13.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressCellView;
@protocol PublishTravelTopViewDelegate<NSObject>

@optional
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
- (void)clickedTextFieldReturnBtnInAddressCell:(AddressCellView *)addressCell cellArray:(NSArray<AddressCellView *> *)cellArray;

@end

@interface PublishTravelTopView : UIView

@property (nonatomic, copy) void(^backToPrevious)(void);    //回到上一页
@property (nonatomic, weak) id<PublishTravelTopViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame viewType:(ViewType)viewType;

/**
 折叠视图
 */
- (void)foldAddressView;

@end
