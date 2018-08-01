//
//  AlertView.h
//  测试文本框(Objective_C)
//
//  Created by 李伟国 on 2018/7/17.
//  Copyright © 2018年 李伟国. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UILabel

+ (AlertView *)createSingleCase;

- (void)showAlertMessage:(NSString *)message withCenter:(CGPoint)center;

@end
