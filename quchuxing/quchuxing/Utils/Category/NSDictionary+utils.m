//
//  NSDictionary+utils.m
//  BJEducation_student
//
//  Created by Mrlu-bjhl on 15/2/6.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import "NSDictionary+utils.h"

@implementation NSDictionary (utils)
- (id)objectValueForKey:(NSString *)key
{
    id value = [self valueForKey:key];
    if ((!value || [value isKindOfClass:[NSNull class]]))
    {
        return nil;
    }
    else
    {
        return value;
    }
}
- (NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue
{
    id value = [self valueForKey:key];
    if (!value || [value isEqual:[NSNull null]])
    {
        return defaultValue;
    } else {
        return value;
    }
}

- (id)objectValueForKey:(NSString *)key defaultValue:(id)defaultValue
{
    id value = [self objectForKey:key];
    if ((!value || [value isKindOfClass:[NSNull class]]))
    {
        return defaultValue;
    }
    else
    {
        return value;
    }
}

- (NSInteger)integerValueForkey:(NSString *)key defaultValue:(NSInteger)defaultValue
{
    id value = [self valueForKey:key];
    if (!value || [value isEqual:[NSNull null]])
    {
        return defaultValue;
    } else {
        return [value integerValue];
    }
}

- (int)intValueForkey:(NSString *)key defaultValue:(int)defaultValue
{
    id value = [self valueForKey:key];
    if (!value || [value isEqual:[NSNull null]])
    {
        return defaultValue;
    } else {
        return [value intValue];
    }
}

- (long long)longLongValueForKey:(NSString *)key defalutValue:(long long)defaultValue
{
    id value = [self valueForKey:key];
    if (!value || [value isEqual:[NSNull null]])
    {
        return defaultValue;
    } else {
        return [value longLongValue];
    }
}

- (BOOL)boolValueForKey:(NSString *)key defalutValue:(BOOL)defaultValue
{
    id value = [self valueForKey:key];
    if (!value || [value isEqual:[NSNull null]])
    {
        return defaultValue;
    } else {
        return [value boolValue];
    }
}

- (float)floatValueForKey:(NSString *)key defalutValue:(float)defaultValue
{
    id value = [self valueForKey:key];
    if (!value || [value isEqual:[NSNull null]])
    {
        return defaultValue;
    } else {
        return [value floatValue];
    }
}

- (double)doubleValueForKey:(NSString *)key defalutValue:(double)defaultValue
{
    id value = [self valueForKey:key];
    if (!value || [value isEqual:[NSNull null]])
    {
        return defaultValue;
    } else {
        return [value doubleValue];
    }
}

@end
