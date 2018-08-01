//
//  LimitInputLength.h
//  测试文本框(Objective_C)
//
//  Created by 李伟国 on 2018/7/17.
//  Copyright © 2018年 李伟国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UITextField (LimitCount)

@property (nonatomic, strong) NSNumber *limitCount;     //字数限制

@end

@interface UITextView (LimitCount)

@property (nonatomic, strong) NSNumber *limitCount;     //字数限制

@end

@interface LimitInputLength : NSObject

@property (nonatomic, assign) BOOL enableLimitCount;

+ (LimitInputLength *)sharedSingleCase;

@end
