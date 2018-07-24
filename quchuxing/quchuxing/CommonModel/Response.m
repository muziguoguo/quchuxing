//
//  Response.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/25.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "Response.h"

@implementation Response

- (id)initWithDictionary:(NSDictionary *)dic
{
    NSInteger flag = 0;
    NSObject *data = @"";
    NSObject *common = @"";
    NSString *msg = @"";
    if ([dic valueForKey:@"code"]) {
        flag = [[dic valueForKey:@"code"] integerValue];
    }
    if ([dic valueForKey:@"status"]) {
        flag = ![[dic valueForKey:@"status"] integerValue];
    }
    data = [dic objectValueForKey:@"result" defaultValue:@{}];
    common = [dic objectValueForKey:@"common" defaultValue:nil];
    msg = [dic stringValueForKey:@"message" defaultValue:@""];
    
    return [self initWithState:flag result:data common:common message:msg];
}

- (Response *)initWithState:(NSInteger)state result:(NSObject *)data common:(NSObject *)common message:(NSString *)msg
{
    self = [super init];
    if (self) {
        _code = state;
        _result = data;
        _message = msg;
        _common = common;
    }
    return self;
}
- (NSString *)description
{
    return  [NSString stringWithFormat:@"status=%ld,data=%@,common=%@,msg=%@",self.code,self.result,self.common,self.message];
}

@end
