//
//  NSDictionary+utils.h
//  BJEducation_student
//
//  Created by Mrlu-bjhl on 15/2/6.
//  Copyright (c) 2015年 Baijiahulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (utils)
/*!
 *  @author liweiguo
 *
 *  @brief  兼容php对象返回为空(调用此方法当对象为nsnull时返回为nil)
 *
 *  @param key 键值
 *
 *  @return 返回对象
 */
- (id)objectValueForKey:(NSString *)key;

/*!
 *  @author liweiguo
 *
 *  @brief  兼容php对象返回为空(调用此方法当对象为nsnull时返回为defaultValue)
 *
 *  @param key 键值
 *
 *  @return 返回对象
 */
- (id)objectValueForKey:(NSString *)key defaultValue:(id)defaultValue;

/*!
 *  @author liweiguo
 *
 *  @brief  兼容php对象返回为空(调用此方法当对象为nsnull时返回为defaultValue字符串)
 *
 *  @param key 键值
 *
 *  @return 返回对象字符串
 */
- (NSString *)stringValueForKey:(NSString *)key defaultValue:(NSString *)defaultValue;

- (int)intValueForkey:(NSString *)key defaultValue:(int)defaultValue;
- (long long)longLongValueForKey:(NSString *)key defalutValue:(long long)defaultValue;
- (BOOL)boolValueForKey:(NSString *)key defalutValue:(BOOL)defaultValue;
- (float)floatValueForKey:(NSString *)key defalutValue:(float)defaultValue;
- (double)doubleValueForKey:(NSString *)key defalutValue:(double)defaultValue;
- (NSInteger)integerValueForkey:(NSString *)key defaultValue:(NSInteger)defaultValue;
@end
