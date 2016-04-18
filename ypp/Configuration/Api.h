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
    ResultCodeNoData = 571,//无数据
    ResultCodeFail = 431//
};

//环信推送证书密码 123456
//环信相关参数：
//client_id：YXA6Rg0AQJmHEeWSNTHvoCMYcw
//client_secret：UueEQ_o53sR3rZmprjSNP18I9E
//org_name：szhcyj
//app_name：yuewanba
//https://console.easemob.com/app_users.html           szhcyj  1qazxsw2


//微信公众号身份的唯一标识AppID(应用ID)：
#define WX_APP_ID @"wxc1cbee2d78d4c06a"
//APPSECRET = '61551771f596db8f42d80532c5b51cf7';
//受理商MCHID：1323105401
//商户支付密钥KEY ：hcyjhcyjhcyjhcyjhcyjhcyjhcyjhcyj

#define WX_PREPAY_URL @"app1/wxpay.php"

//支付宝参数
#define ALIPAY_PID @"2088121057432667"
#define ALIPAY_SELLER @"179868099@qq.com"
#define ALIPAY_PRIVATE_KEY @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBALIYRqm8KNRVcp1iy4NInt7NL+lMO2i+lJ6jxd2XjUzMNpcHNAiBuvq1IiFsQdsOqI06X+D58ZRU8eqRWZtTNUmgHs+T1wG5gDz92KAKbIwXmBfmhKyYoo0+mEGhdcYX5FK0x/oqfTnTFFP/4EwF9FNRmRpgqNWc9ne3f0z3hqyzAgMBAAECgYAGROp/4RrC1rsxJSAq3+yPxUNRgBh7SHIs33EAquwTbwDg8iT3w7FUT/oCmS/8SRjP1+U2IzZI1XCqpDE2UYiHnu2C8K6WNjsdghs7KNbVw6nG9jjHdBsHmJzxSLWoRM98mWKA/xX3ciJync2VeVCdjC9Rk1gyWe+0Ava/GeQS4QJBANigDsvXf2hhBDsRTwxPGPo1NqQJJtzDSsZwwRKx1Qv5ymYEJdaVOKAXpJN0haqz3KslMFg9jy2Bwo09JGCm9UMCQQDSd1U7rYQ5OlOXFi8j2CO35xUxM1G0DQLQbIjrNQTbj9PHfDawkUffqbW4hZltG4bfnY2ik7NjzGCI1C70ZjvRAkEAzTYzTh+DbtoZK+ulur9jpgOrE5In4pKOz5YZESCt9n5XonTjc3hBAEflfFqyFZf1v5unRLBsZmu6Zho5z+XaCQJBALlqyltGFcv5F7VupN8WRvl4itIKnTtbjxQh2kolLn9kabZAN0o8464nLGJAyRc3fg45FpOZPhx47L7+99L20lECQHMcpZg+QdvddhrYw3l0aTA2HnMWWJJOePMfSHFeyMhjbCavvzS0cwBmIVR/rQ8Z4zb8fYDBHf8SXVANi3u3cds="
#define ALIPAY_PUBLIC_KEY @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI6d306Q8fIfCOaTXyiUeJHkrIvYISRcc73s3vF1ZT7XN8RNPwJxo8pWaJMmvyTn9N4HQ632qJBVHf8sxHi/fEsraprwCtzvzQETrNRwVxLO5jVmRGi60j8Ue1efIlzPXV9je9mkjzOmdssymZkh2QhUrCmZYI/FCEa3/cNMW0QIDAQAB"

//(1)PID 2088121057432667
//APPID: 2016031701220292
//安全校验码(Key)
//默认加密： 80tnkm2gbu85ct8f4qj8xwd4zetiddo6
//APP SECRET: b41cf8b42db54db59a95429d35850f17
//支付宝公钥：MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDDI6d306Q8fIfCOaTXyiUeJHkrIvYISRcc73s3vF1ZT7XN8RNPwJxo8pWaJMmvyTn9N4HQ632qJBVHf8sxHi/fEsraprwCtzvzQETrNRwVxLO5jVmRGi60j8Ue1efIlzPXV9je9mkjzOmdssymZkh2QhUrCmZYI/FCEa3/cNMW0QIDAQAB
//（4）、生成商户私钥【MAC生成方法】
//（5）、生成用户公钥及网页填充

#define LOGOUT @"logout"

//已登录账号密码
#define LOGINED_PHONE @"loginedPhone"
#define LOGINED_PASSWORD @"loginedPassword"
//已登录用户
#define LOGINED_USER @"loginedUser"

//服务器地址
#define HOST @"http://oa.hcyj.net/"
////图片文件夹路径
//#define PIC_PATH @"app1/uploads/"

//获取上传图片token
#define PHOTO_UPTOKEN_URL @"app1/upload_token.php"
//上传文件
#define QINIU_UPLOAD @"http://upload.qiniu.com/"
//图片路径
#define QINIU_IMAGE_URL @"http://7xpcmr.com1.z0.glb.clouddn.com/"

//发送短信验证码
#define API_SENDCODE @"app1/index.php?action=getverificationcode"
//注册
#define API_REGISTER @"app1/index.php?action=register"
//登录
#define API_LOGIN @"app1/index.php?action=login"
//签到
#define API_SIGNIN @"app1/index.php?action=signin"
//陪练列表
#define API_YOUSHENLIST @"app1/index.php?action=vipuserlist"
//动态列表
#define API_TOPICLIST @"app1/index.php?action=topiclist"
////上传图片
//#define API_UPLOADIMG @"app1/index.php?action=uploadImg"
//发布动态
#define API_SEVEDYNAMIC @"app1/index.php?action=savedynamic"
//用户详情
#define API_GETUSERINFO @"app1/index.php?action=getuserinfo"
//重新绑定新手机，更换账号
#define API_UPDATEPHONE @"app1/index.php?action=updatephone"
//绑定会员卡
#define API_SETCARD @"app1/index.php?action=setcard"
//设置隐身模式
#define API_UPDATESTATUS @"app1/index.php?action=updatestatus"
//动态点赞
#define API_FAVTOPIC @"app1/index.php?action=favtopic"
//常玩游戏
#define API_OFTENPLAYGAMES @"app1/index.php?action=oftenplaygames"
//门店列表
#define API_STORELIST @"app1/index.php?action=storelist"
//行业列表
#define API_HANGYE @"app1/index.php?action=hys"
//编辑资料
#define API_UPDATEUSER @"app1/index.php?action=saveuser"
//动态回复
#define API_INSERT_TOPIC_REPLY @"app1/index.php?action=insert_topic_reply"
//动态赞列表
#define API_FAVTOPIC_LIST @"app1/index.php?action=favtopic_list"
//动态回复列表
#define API_TOPIC_REPLY_LIST @"app1/index.php?action=topic_reply_list"
//关注
#define API_FOCUSUSER @"app1/index.php?action=focususer"
//是否已经关注了用户
#define API_IS_FOCUSUSER @"app1/index.php?action=isfocususer"
//查询用户动态
//参数：userid、type（0 获取最新一条,1获取所有并分页）、page（页数，默认1）
//type ：陪玩详情页面调用0，点击动态进入动态列表，type传值为1
#define API_TOPICLIST_BY_USER @"app1/index.php?action=topiclistByuser"
//根据游戏ID查询游戏区 参数gameid
#define API_GAMEAREAS_BY_ID @"app1/index.php?action=gameareasByID"
//申请成为陪练
#define API_DARENSUBMIT @"app1/index.php?action=darensubmit"
//获取文字说明的url
//type（0用户协议 1游神协议 2帮助说明 3用户帮助）
#define API_GETURL @"app1/index.php?action=geturl"
//优惠券列表
#define API_YOUHUI_LIST @"app1/index.php?action=youhuilist"
//约
#define API_YUE @"app1/index.php?action=yue"
//约TA
#define API_YUETA @"app1/index.php?action=yueTA"
//取消约单
#define API_CANCELYUE @"app1/index.php?action=cancelyue"
//陪玩记录
#define API_ORDER_LIST @"app1/index.php?action=orderlist"


//查询约单列表
#define API_MY_YUE_LIST @"app1/index.php?action=myyuelist"


//查询游神参与应约了的约单，分页
#define API_GET_ORDER_BY_VIP @"app1/index.php?action=getOrderbyvip"
//游神应约操作
#define API_JOIN_ORDER @"app1/index.php?action=joinorder"
//查询参与会员约单并应约了的游神列表，分页
#define API_GET_VIP_LIST @"app1/index.php?action=getviplist"
//约单发布者 选择完游神，付款确认
#define API_CONFIRM_YUE @"app1/index.php?action=confirmyue"
//修改约单状态，１已完成，２已取消
#define API_UPDATE_STATUS @"app1/index.php?action=updatestatus"

//充值列表
#define API_RECHARGE_LIST @"app1/index.php?action=rechargelist"
//绑定YY账号
#define API_SETYY @"app1/index.php?action=setyy"
//增加浏览量(热点)
#define API_HOTCOUNT @"app1/index.php?action=hotcount"
//动态分享
#define API_RELAYTOPIC @"app1/index.php?action=relaytopic"
//创建活动
#define API_CREATE_EVENT @"app1/index.php?action=createevent"
//活动列表
#define API_EVENTLIST @"app1/index.php?action=eventlist"
//创建群组
#define API_CREATEEVENT @"app1/index.php?action=createevent"
//附近群组
#define API_GROUPLIST @"app1/index.php?action=grouplist"

@interface Api : NSObject

@end
