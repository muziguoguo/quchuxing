//
//  BaseModel.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/2.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (id)initWithDic:(NSDictionary *)dic{
    NSError *error = nil;
    self = [self initWithDictionary:dic error:&error];
    return self;
}

@end
