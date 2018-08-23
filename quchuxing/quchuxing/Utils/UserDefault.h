//
//  UserModel.h
//  quchuxing
//
//  Created by 李伟国 on 2018/8/2.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#pragma mark --用户登录相关持久化数据操作
#import "JSONModel.h"
@class UserModel;

@interface UserDefault : NSObject

@property (nonatomic, strong) UserModel *userInfo;  //根据有无判断是否存在登录用户
@property (nonatomic, strong) NSNumber *phoneNumber;   

/**
 获取用户数据单例对象
 */
+ (UserDefault *)sharedUserDefault;

/**
 下一用户登录或当前登录退出，移除当前登录全部用户数据
 */
- (void)clear;

@end
