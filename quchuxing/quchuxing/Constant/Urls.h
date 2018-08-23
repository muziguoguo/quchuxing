//
//  Urls.h
//  quchuxing
//
//  Created by 李伟国 on 2018/7/24.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#ifndef Urls_h
#define Urls_h

#ifdef DEBUG
#define kBaseURL @"http://t1.driver.quchuxing.com.cn"
#else
#define kBaseURL @"https://v1.driver.quchuxing.com.cn"   //服务器地址
#endif

#define kApi_Post_SendCaptcha [NSString stringWithFormat:@"%@/sendCaptcha", kBaseURL]   //发送验证码

#define kApi_Post_Login [NSString stringWithFormat:@"%@/loginNew", kBaseURL]   //登录

#define kApi_Post_ListOfHome [NSString stringWithFormat:@"%@/personalTL/listOfHome", kBaseURL]  //首页展示列表

#endif /* Urls_h */
