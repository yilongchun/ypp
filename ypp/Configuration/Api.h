//
//  Api.h
//  ypp
//
//  Created by Stephen Chin on 15/12/7.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HOST @"http://oa.hcyj.net/"
//发送短信验证码
#define API_SENDCODE @"app1/index.php?action=getverificationcode"
//注册
#define API_REGISTER @"app1/index.php?action=register"
//登录
#define API_LOGIN @"app1/index.php?action=login"

//游神列表
#define API_YOUSHENLIST @"app1/index.php?action=vipuserlist"

@interface Api : NSObject

@end
