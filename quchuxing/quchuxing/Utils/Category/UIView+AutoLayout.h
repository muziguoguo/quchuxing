//
//  UIView+AutoLayout.h
//  quchuxing
//
//  Created by 李伟国 on 2018/7/27.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark --基于Masonry封装适配iOS11
@interface UIView (AutoLayout)

@property (nonatomic, strong, readonly) MASViewAttribute *qcx_top;
@property (nonatomic, strong, readonly) MASViewAttribute *qcx_bottom;
@property (nonatomic, strong, readonly) MASViewAttribute *qcx_left;
@property (nonatomic, strong, readonly) MASViewAttribute *qcx_right;
@property (nonatomic, assign, readonly) UIEdgeInsets qcx_edgeInsets;

@end

