//
//  UserModel.h
//  quchuxing
//
//  Created by 李伟国 on 2018/8/2.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#pragma mark --用户数据模型
#import "BaseModel.h"

@interface UserModel : BaseModel

@property (nonatomic, assign) BOOL isAuth;
@property (nonatomic, assign) BOOL zmxyStatus;
@property (nonatomic, assign) BOOL authenStatus;
@property (nonatomic, assign) BOOL passStatus;
@property (nonatomic, assign) NSInteger carOwnerStatus;
@property (nonatomic, copy) NSString *rongToken;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, assign) NSInteger status;

@end
