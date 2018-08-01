//
//  UIView+FrameLayout.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/25.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "UIView+FrameLayout.h"

@implementation UIView (FrameLayout)

- (CGFloat)cur_x{
    return self.frame.origin.x;
}

- (CGFloat)cur_y{
    return self.frame.origin.y;
}

- (CGFloat)cur_w{
    return self.frame.size.width;
}

- (CGFloat)cur_h{
    return self.frame.size.height;
}

- (CGFloat)cur_x_w{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)cur_y_h{
    return self.frame.origin.y + self.frame.size.height;
}

@end
