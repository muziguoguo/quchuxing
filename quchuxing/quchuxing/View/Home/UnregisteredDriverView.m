//
//  UnregisteredDriver.m
//  quchuxing
//
//  Created by 李伟国 on 2018/8/4.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "UnregisteredDriverView.h"

@interface UnregisteredDriverView()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *registerDriverBtn;
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@end

@implementation UnregisteredDriverView

- (void)awakeFromNib{
    [super awakeFromNib];
    UIImage *image = [UIImage imageNamed:@"img_chezhurenzheng"];
    [_backImageView setImage:image];
    [self sendSubviewToBack:_backImageView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [_registerDriverBtn gradualBackgroundColorWithCornerRadius:10 borderWidth:0 colors:nil locations:nil];
}

#pragma mark -- 点击注册车主按钮
- (IBAction)clickedRegisterDriver:(UIButton *)sender {
}

@end
