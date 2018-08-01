//
//  UIView+AutoLayout.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/27.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "UIView+AutoLayout.h"

@implementation UIView (AutoLayout)

- (MASViewAttribute *)qcx_top{
    if (@available(iOS 11.0, *)) {
        return self.safeAreaLayoutGuideTop;
    }
    return self.top;
}

- (MASViewAttribute *)qcx_bottom{
    if (@available(iOS 11.0, *)) {
        return self.safeAreaLayoutGuideBottom;
    }
    return self.bottom;
}

- (MASViewAttribute *)qcx_left{
    if (@available(iOS 11.0, *)) {
        return self.safeAreaLayoutGuideLeft;
    }
    return self.left;
}

- (MASViewAttribute *)qcx_right{
    if (@available(iOS 11.0, *)) {
        return self.safeAreaLayoutGuideRight;
    }
    return self.right;
}

- (UIEdgeInsets)qcx_edgeInsets{
    if (@available(iOS 11.0, *)) {
        return self.safeAreaInsets;
    }
    return UIEdgeInsetsZero;
}

@end
