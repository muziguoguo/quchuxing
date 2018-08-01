//
//  LimitInputLength.m
//  测试文本框(Objective_C)
//
//  Created by 李伟国 on 2018/7/17.
//  Copyright © 2018年 李伟国. All rights reserved.
//

#import "LimitInputLength.h"

@implementation UITextField (LimitCount)

- (void)setLimitCount:(NSNumber *)limitCount{
    objc_setAssociatedObject(self, "limitCount", limitCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)limitCount{
    return objc_getAssociatedObject(self, "limitCount");
}

@end

@implementation UITextView (LimitCount)

- (void)setLimitCount:(NSNumber *)limitCount{
    objc_setAssociatedObject(self, "limitCount", limitCount, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)limitCount{
    return objc_getAssociatedObject(self, "limitCount");
}

@end

@implementation LimitInputLength

+ (void)load{
    [super load];
    [LimitInputLength sharedSingleCase];
}

+ (LimitInputLength *)sharedSingleCase{
    static LimitInputLength *singleCase = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (singleCase == nil) {
            singleCase = [[super allocWithZone:nil] init];
        }
        singleCase.enableLimitCount = YES;
    });
    return singleCase;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldValueChangedResponse:) name:UITextFieldTextDidChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewValueChangedResponse:) name:UITextFieldTextDidChangeNotification object:nil];
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [LimitInputLength sharedSingleCase];
}

- (id)copy{
    return [LimitInputLength sharedSingleCase];
}

- (id)mutableCopy{
    return [LimitInputLength sharedSingleCase];
}

#pragma mark -- UITextField文本改变通知回调
- (void)textFieldValueChangedResponse:(NSNotification *)notification{
    if (!self.enableLimitCount) return;
    UITextField *textField = notification.object;
    NSNumber *limitCount = textField.limitCount;
    if (limitCount && textField.text.length>[limitCount integerValue] && textField.markedTextRange == nil) {
        textField.text = [textField.text substringWithRange:NSMakeRange(0, limitCount.integerValue)];
    }
}

#pragma mark -- UITextView文本改变通知回调
- (void)textViewValueChangedResponse:(NSNotification *)notification{
    if (!self.enableLimitCount) return;
    UITextView *textView = notification.object;
    NSNumber *limitCount = textView.limitCount;
    if (limitCount && textView.text.length>[limitCount integerValue] && textView.markedTextRange == nil) {
        textView.text = [textView.text substringWithRange:NSMakeRange(0, limitCount.integerValue)];
    }
}

@end
