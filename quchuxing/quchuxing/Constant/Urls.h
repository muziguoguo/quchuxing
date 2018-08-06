//
//  Urls.h
//  quchuxing
//
//  Created by 李伟国 on 2018/7/24.
//  Copyright © 2018年 趣出行. All rights reserved.
//

#ifndef Urls_h
#define Urls_h

#define kBaseURL @"https://v1.driver.quchuxing.com.cn"   //服务器地址

#define kApi_Post_SendCaptcha [NSString stringWithFormat:@"%@/sendCaptcha", kBaseURL]

#define kApi_Post_Login [NSString stringWithFormat:@"%@/login", kBaseURL]


#endif /* Urls_h */
