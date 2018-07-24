//
//  Prefix.h
//  quchuxing
//
//  Created by 李伟国 on 2018/7/24.
//  Copyright © 2018年 趣出行. All rights reserved.
//

//用于在此处导入在程序中大多数地方都要使用到的头文件，声明宏定义

#ifndef Prefix_h
#define Prefix_h

//标明某个函数在某个版本之后被启用，通过新的指定方法替代
#define QCX_DEPRECATED_WILL_BE_REMOVED_IN_PLEASE_USE(VERSION, METHOD) __attribute__((deprecated("This method has been deprecated and will be removed in QuChuXing " VERSION ". Please use `" METHOD "` instead.")))

#pragma mark --导入常用头文件
#import "Notifications.h"
#import "Enums.h"
#import "Urls.h"

#pragma mark --三方API密钥
#ifdef DEBUG
#define RYAppKey @"e5t4ouvpers8a" //融云
#define RYAppSecret @"RD4YwyWHMDbmj"
#elif TEST
#define RYAppKey @"e5t4ouvpers8a"
#define RYAppSecret @"RD4YwyWHMDbmj"
#elif BETA
#define RYAppKey @"mgb7ka1nm3p8g"
#define RYAppSecret @"Yt0q6VnaRtr"
#elif REALEASE
#define RYAppKey @"mgb7ka1nm3p8g"
#define RYAppSecret @"Yt0q6VnaRtr"
#endif

#define WXAppKey @"wxb4188a08e56b21a0"  //微信
#warning 未找到微信秘钥
#define WXAppSecret @""

#define JPushAppKey @"348b362efeae8fce549b9d6d" //极光推送
#define JPushAppSecret @"693ce5c70ff35f08af1bd0ec"

#define UMAppKey @"590b1f9b1c5dd07f620000e8"    //友盟

#define AMapAppKey @"0d4329439b78d6a507db7efcd833f1ed"  //高德

#pragma mark --常用系统宏定义
//IOS版本
#define SYSTEM_VERSION [[UIDevice currentDevice].systemVersion floatValue]
//系统名字  手机型号+系统+系统版本
#define SYSTEM_NAME  [NSString stringWithFormat:@"%@ %@ %@",[[UIDevice currentDevice] model],[[UIDevice currentDevice] systemName],[[UIDevice currentDevice] systemVersion]]
//设备名称
#define DEVICE_NAME  [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] model]]
// 应用版本
#define APPVERISON            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//当前设备屏幕框架
#define DEVICE_SCREEN [UIScreen mainScreen].bounds.size.height
#define DEVICE_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define DEVICE_SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//判断设备
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_4 (fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480) < DBL_EPSILON)

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IPHONE_Plus ([UIScreen mainScreen].scale == 3 )

#define IS_IPHONE_6OrMore (fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )667 ) < DBL_EPSILON )

#define IS_IPHONE_X (fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )812 ) < DBL_EPSILON )
//系统版本是否为iOS11及以上
#define IS_OS_11_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)

#pragma mark --内容打印
#ifdef DEBUG
#define DLog( s, ...) NSLog(@"<%@ :%d> %@",[[NSString stringWithUTF8String:__FILE__]lastPathComponent],__LINE__,[NSString stringWithFormat:(s),##__VA_ARGS__]);
#elif TEST
#define DLog( s, ...) NSLog(@"<%@ :%d> %@",[[NSString stringWithUTF8String:__FILE__]lastPathComponent],__LINE__,[NSString stringWithFormat:(s),##__VA_ARGS__]);
#elif BETA
#define DLog( s, ...) NSLog(@"<%@ :%d> %@",[[NSString stringWithUTF8String:__FILE__]lastPathComponent],__LINE__,[NSString stringWithFormat:(s),##__VA_ARGS__]);
#else
#define DLog(s,...)

#endif

#pragma mark --常用偏移高度
#define kNavBarHeight (IS_IPHONE_X?88:64)
#define kTabBarHeight (IS_IPHONE_X?83:49)
#define kOriginOffset_Y_Top (IS_IPHONE_X?44:20)
#define kOriginOffset_Y_Bottom (IS_IPHONE_X?34:0)

#pragma mark --设置弱引用
#define __WeakSelf__  __weak typeof (self)
#define __WeakObject(object) __weak typeof (object)

#pragma mark --常用方法宏定义
#define UICOLOR_FROM_RGB(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIFont_Font(size) [UIFont systemFontOfSize:size]
#define UIFont_bold_Font(size) [UIFont boldSystemFontOfSize:size]

#pragma mark --下载图片同时的裁剪方式
//实际裁剪
#define MakedImageUrl(oriUrl,w,h) [NSString stringWithFormat:@"%@@1e_%dw_%dh_1c_0i_1o_90Q_1x.png",oriUrl,(int)RetinaSize(w),(int)RetinaSize(h)]
//等比例裁剪
#define Maked0ImageUrl(oriUrl,w,h) [NSString stringWithFormat:@"%@@0e_%dw_%dh_1c_0i_1o_90Q_1x.png",oriUrl,(int)RetinaSize(w),(int)RetinaSize(h)]
#define RetinaSize(size) (int)([UIScreen mainScreen].scale*size)

#endif /* Prefix_h */











