//
//  AppDelegate+LaunchView.m
//  quchuxing
//
//  Created by 李伟国 on 2018/7/24.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#import "AppDelegate+LaunchView.h"
#import "IntroView.h"

@implementation AppDelegate (LaunchView)

#pragma mark --加载引导页
- (void)loadIntroViewInWindow:(UIWindow *)window{
    
    float version = [[NSUserDefaults standardUserDefaults] floatForKey:VERSION];
    bool isLaunched = [[NSUserDefaults standardUserDefaults] boolForKey:LAUNCHED];
    if ((version==0.0 || [APPVERISON floatValue]>version) || !isLaunched ) {
        //记录更新UUID
        [[NSUserDefaults standardUserDefaults] setValue:[[NSUUID UUID] UUIDString] forKey:UUIDIDENTIFER];

        [[NSUserDefaults standardUserDefaults] setFloat:[APPVERISON floatValue]  forKey:VERSION];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:LAUNCHED];
#warning 替换真实引导页图片
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"png"];
        UIImage *introImage = [UIImage imageWithContentsOfFile:imagePath];
        IntroView *introView = [[IntroView alloc] initWithFrame:[UIScreen mainScreen].bounds pages:3 image:introImage];
        [window addSubview:introView];
    }
    
}

@end
