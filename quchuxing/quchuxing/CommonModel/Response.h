//
//  Response.h
//  quchuxing
//
//  Created by 李伟国 on 2018/7/25.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject

@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) NSObject *result;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSObject *common;

- (id)initWithDictionary:(NSDictionary *)dic;

- (Response *)initWithState:(NSInteger)state result:(NSObject *)data common:(NSObject *)common message:(NSString *)msg;

- (NSString *)description;
@end

