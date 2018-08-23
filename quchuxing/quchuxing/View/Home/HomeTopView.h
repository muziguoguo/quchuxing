//
//  HomeTopView.h
//  quchuxing
//
//  Created by 李伟国 on 2018/8/8.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTopView : UIView

@property (nonatomic, assign) NSInteger loginType;  //登录状态：0/未登录 1：登录

/**
 缩放头部视图

 @param scale 缩放比例
 */
- (void)zoomViewWithScale:(CGSize)scale;

@end








