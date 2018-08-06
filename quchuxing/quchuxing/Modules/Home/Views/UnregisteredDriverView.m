//
//  UnregisteredDriver.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/4.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "UnregisteredDriverView.h"

@interface UnregisteredDriverView()

@property (weak, nonatomic) IBOutlet UIButton *registerDriverBtn;

@end

@implementation UnregisteredDriverView

- (void)awakeFromNib{
    [super awakeFromNib];
    [self setBackgroundColor:[UIColor whiteColor]];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_registerDriverBtn gradualBackgroundColorWithCornerRadius:6 borderWidth:0 colors:nil locations:nil];
}

#pragma mark -- 点击注册车主按钮
- (IBAction)clickedRegisterDriver:(UIButton *)sender {
}

@end
