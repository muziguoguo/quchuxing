//
//  UserModel.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/2.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "UserDefault.h"
#import "UserModel.h"

@implementation UserDefault

#pragma mark --用户信息单例创建
+ (UserDefault *)sharedUserDefault{
    static UserDefault *userSingle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!userSingle) {
            userSingle = [super allocWithZone:NULL];
        }
    });
    return userSingle;
}

#pragma mark - 用户信息
- (void)setUserInfo:(UserModel *)userInfo
{
    
    NSUserDefaults * userDefauts = [NSUserDefaults standardUserDefaults];
    if (userInfo) {
        NSDictionary *dic = [userInfo toDictionary];
        [userDefauts setObject:dic forKey:@"userInfo"];
    }
    else
    {
        [userDefauts removeObjectForKey:@"userInfo"];
    }
    [userDefauts synchronize];
}

- (UserModel *)userInfo
{
    NSUserDefaults * userDefauts = [NSUserDefaults standardUserDefaults];
    NSDictionary *userInfoDic = [userDefauts objectForKey:@"userInfo"];
    
    if (!userInfoDic) {
        return nil;
    }
    return [[UserModel alloc] initWithDic:userInfoDic];
}

- (void)setPhoneNumber:(NSNumber *)phoneNumber{
    if (phoneNumber) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:phoneNumber forKey:@"phoneNumber"];
        [defaults synchronize];
    }
}

- (NSNumber *)phoneNumber{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"phoneNumber"];
}

#pragma mark --获取全部key
- (NSArray *)allKey{
    return @[@"userInfo", @"phoneNumber"];
}

#pragma mark --移除用户全部数据
- (void)clear{
    NSUserDefaults * userDefauts = [NSUserDefaults standardUserDefaults];
    [[self allKey] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [userDefauts removeObjectForKey:obj];
        [userDefauts synchronize];
    }];
}

@end
