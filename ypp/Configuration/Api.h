//
//  Api.h
//  ypp
//
//  Created by Stephen Chin on 15/12/7.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ResultCodeType){
    ResultCodeSuccess = 200,//操作成功
    ResultCodeFileTooLarge = 201,//上传文件超过大小
    ResultCodeInvalidParam = 421,//参数有误
    ResultCodePasswordError = 412,//密码错误
    ResultCodeUserNameNotFound = 413,//用户名不存在
    ResultCodePhoneIsRegistered = 422,//手机号码已经注册
    ResultCodeNoData = 431,//无数据
    ResultCodeFail = 431//无数据
};

//环信相关参数：
//client_id：YXA6Rg0AQJmHEeWSNTHvoCMYcw
//client_secret：UueEQ_o53sR3rZmprjSNP18I9E
//org_name：szhcyj
//app_name：yuewanba

#define LOGOUT @"logout"

//已登录账号密码
#define LOGINED_PHONE @"loginedPhone"
#define LOGINED_PASSWORD @"loginedPassword"

//已登录用户
#define LOGINED_USER @"loginedUser"
//服务器地址
#define HOST @"http://oa.hcyj.net/"
//图片文件夹
#define PIC_PATH @"app1/uploads/"

//发送短信验证码
#define API_SENDCODE @"app1/index.php?action=getverificationcode"
//注册
#define API_REGISTER @"app1/index.php?action=register"
//登录
#define API_LOGIN @"app1/index.php?action=login"
//签到
#define API_SIGNIN @"app1/index.php?action=signin"
//游神列表
#define API_YOUSHENLIST @"app1/index.php?action=vipuserlist"
//动态列表
#define API_TOPICLIST @"app1/index.php?action=topiclist"
//上传图片
#define API_UPLOADIMG @"app1/index.php?action=uploadImg"
//发布动态
#define API_SEVEDYNAMIC @"app1/index.php?action=savedynamic"

//编辑资料
#define API_UPDATEUSER @"app1/index.php?action=saveuser"
//重新绑定新手机，更换账号
#define API_UPDATEPHONE @"app1/index.php?action=updatephone"
//绑定会员卡
#define API_SETCARD @"app1/index.php?action=setcard"
//绑定YY账号
#define API_SETYY @"app1/index.php?action=setyy"

@interface Api : NSObject

@end
