//
//  NavItemCustomView.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/30.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "NavItemCustomView.h"

@implementation NavItemCustomView

- (void)setQcx_edgeInsets:(UIEdgeInsets)qcx_edgeInsets{
    _qcx_edgeInsets = qcx_edgeInsets;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    [self.widthAnchor constraintEqualToConstant:fabs(qcx_edgeInsets.left)+44].active = YES;
    [self.heightAnchor constraintEqualToConstant:44].active = YES;
}

- (UIEdgeInsets)alignmentRectInsets{
    if (UIEdgeInsetsEqualToEdgeInsets(_qcx_edgeInsets, UIEdgeInsetsZero)) {
        return [super alignmentRectInsets];
    }
    else
        return _qcx_edgeInsets;
}

@end
