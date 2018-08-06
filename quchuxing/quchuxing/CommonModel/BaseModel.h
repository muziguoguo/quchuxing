//
//  BaseModel.h
//  quchuxing
//
//  Created by 李伟国 on 2018/8/2.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "JSONModel.h"

#pragma mark --数据模型基类
@interface BaseModel : JSONModel


/**
 模型初始化

 @param dic 数据字典
 @return 模型对象
 */
- (id)initWithDic:(NSDictionary *)dic;

@end
