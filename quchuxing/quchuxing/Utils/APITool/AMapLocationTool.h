//
//  AMapLocationTool.h
//  quchuxing
//
//  Created by 李伟国 on 2018/7/31.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AMapLocationTool : NSObject

+ (AMapLocationTool *)sharedAMapLocation;

- (void)startLocation;    //开始定位

@end
