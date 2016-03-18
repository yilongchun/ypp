//
//  AppDelegate.m
//  ypp
//
//  Created by haidony on 15/11/4.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "AppDelegate.h"
#import "IQKeyboardManager.h"
#import "EaseUI.h"
#import "WXApi.h"

@interface AppDelegate ()<WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    BOOL b = [WXApi registerApp:WX_APP_ID withDescription:@"weixinPay"];
    DLog(@"注册微信支付%d",b);
    
    //注册登录状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNOTIFICATION_LOGINCHANGE
                                               object:nil];
    
    NSString *apnsCertName = nil;
#if DEBUG
    apnsCertName = @"ypp_push_dev2";
#else
    apnsCertName = @"ypp_push_pro";
#endif
    
//    [[EaseSDKHelper shareHelper] easemobApplication:application
//                      didFinishLaunchingWithOptions:launchOptions
//                                             appkey:@"szhcyj#yuewanba"
//                                       apnsCertName:apnsCertName
//                                        otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    
    [self registerRemoteNotification];
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"szhcyj#yuewanba" apnsCertName:apnsCertName];
    
    
    //以下一行代码的方法里实现了自动登录，异步登录，需要监听[didLoginWithInfo: error:]
    //demo中此监听方法在MainViewController中
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    //注册为SDK的ChatManager的delegate (及时监听到申请和通知)
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    //获取数据库中数据
    [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
    //获取群组列表
    [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    options.displayStyle = ePushNotificationDisplayStyle_messageSummary;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout)
                                                 name:LOGOUT object:nil];
    
    [IQKeyboardManager sharedManager].enable = YES;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        [[UINavigationBar appearance] setBarTintColor:RGBA(52,170,235,1)];
        [[UINavigationBar appearance] setBarTintColor:RGBA(200,22,34,1)];
    }
    
    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[backImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backImage.size.width, 0, 0)]                                                       forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-233, -230) forBarMetrics:UIBarMetricsDefault];
    
//    NSString *account = [[NSUserDefaults standardUserDefaults] stringForKey:LOGINED_PHONE];
//    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:LOGINED_PASSWORD];
//    
//    BOOL isLoggedIn;
//    
//    if (account.length>=6 && password.length>=6) {
//        isLoggedIn = YES;
//    }else{
//        isLoggedIn = NO;
//    }
//    
//    NSString *storyboardId = isLoggedIn ? @"MainTabBarController" : @"initNc";
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:storyboardId];
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = vc;
//    [self.window makeKeyAndVisible];
    
    [self loginStateChange:nil];
    
    
    return YES;
}

#pragma mark - login changed

- (void)loginStateChange:(NSNotification *)notification{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    BOOL isAutoLogin = [[[EaseMob sharedInstance] chatManager] isAutoLoginEnabled];
    BOOL loginSuccess = [notification.object boolValue];
    NSString *storyboardId;
    if (isAutoLogin || loginSuccess) {//登陆成功加载主窗口控制器
        storyboardId = @"MainTabBarController";
//        _mainTabBarController = [storyboard instantiateViewControllerWithIdentifier:storyboardId];
    }
    else{//登陆失败加载登陆页面控制器
        storyboardId = @"initNc";
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGINED_USER];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGINED_PHONE];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGINED_PASSWORD];
    }
    
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:storyboardId];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
}

//退出登录
-(void)logout{
    
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
        if (!error && info) {
            NSLog(@"退出成功");
        }
    } onQueue:nil];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGINED_USER];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGINED_PHONE];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGINED_PASSWORD];
    NSString *storyboardId = @"initNc";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:storyboardId];
    self.window.rootViewController = vc;
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - App Delegate

// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    DLog(@"divickToken:%@",deviceToken);
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
}

// 注册deviceToken失败，此处失败，与环信SDK无关，一般是您的环境配置或者证书配置有误
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark - push
- (void)didBindDeviceWithError:(EMError *)error
{
    if (error) {
        NSLog(@"消息推送与设备绑定失败");
    }
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
     NSLog(@"%@",notificationSettings);
    [application registerForRemoteNotifications];
}


//系统方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    //SDK方法调用
    [[EaseMob sharedInstance] application:application didReceiveRemoteNotification:userInfo];
//    if (_mainTabBarController) {
        NSLog(@"userInfo == %@",userInfo);
        NSString *message = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil ,nil];
        
        [alert show];
//        [_mainTabBarController jumpToChatList];
//    }
    
}
//系统方法
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    //SDK方法调用
    [[EaseMob sharedInstance] application:application didReceiveLocalNotification:notification];
}

- (void)registerRemoteNotification{

    UIApplication *application = [UIApplication sharedApplication];
    
//    //iOS8 注册APNS
//    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
//        [application registerForRemoteNotifications];
//        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }else{
//        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
//        UIRemoteNotificationTypeSound |
//        UIRemoteNotificationTypeAlert;
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
//    }
    
//    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
//                                                                       settingsForTypes:(UIUserNotificationTypeSound |UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
//                                                                       categories:nil]];
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
    

//    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
//    {
//        //IOS8
//        //创建UIUserNotificationSettings，并设置消息的显示类类型
//        UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound) categories:nil];
//        
//        [application registerUserNotificationSettings:notiSettings];
//        
//    } else{ // ios7
//        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge                                       |UIRemoteNotificationTypeSound                                      |UIRemoteNotificationTypeAlert)];
//    }
    
    //注册推送功能
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIUserNotificationType types =
        UIUserNotificationTypeBadge|
        UIUserNotificationTypeSound|
        UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         UIRemoteNotificationTypeAlert |
         UIRemoteNotificationTypeBadge|
         UIRemoteNotificationTypeSound];
    }
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)onResp:(BaseResp *)resp
{
    if ([resp isKindOfClass:[PayResp class]])
    {
        PayResp *response = (PayResp *)resp;
        
//        NSString *strTitle = [NSString stringWithFormat:@"支付结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", response.errCode];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle
//                                                        message:strMsg
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil, nil];
//        [alert show];
        
        switch (response.errCode) {
            case WXSuccess: {
                NSNotification *notification = [NSNotification notificationWithName:@"getOrderPayResult" object:@"success"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
                
            default: {
                NSNotification *notification = [NSNotification notificationWithName:@"getOrderPayResult" object:@"fail"];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                break;
            }
        }
    }
}

@end
