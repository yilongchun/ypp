//
//  MainTabBarController.m
//  ypp
//
//  Created by haidony on 15/11/4.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "MainTabBarController.h"
#import "JYSlideSegmentController.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "ViewController4.h"
#import "ViewController5.h"

#import "FabuyuewanViewController.h"
#import "ConversationListController.h"
#import "EMCDDeviceManager.h"
#import "ChatViewController.h"

//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface MainTabBarController ()<IChatManagerDelegate>{
    UIViewController *tempvc;
    ConversationListController *_chatListVC;
}

@property (strong, nonatomic) NSDate *lastPlaySoundDate;

@end

@implementation MainTabBarController{
    UIBarButtonItem *bwhdButtonItem1;
    UIBarButtonItem *ggtzButtonItem2;
    UIBarButtonItem *bwrzButtonItem3;
    UIBarButtonItem *bwhdButtonItem4;
    UIBarButtonItem *ggtzButtonItem5;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerNotifications];
    
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(toMyDingdan)
                                                 name:@"toMyDingdan" object:nil];
    
    //去除阴影线
//    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
//    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
//    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithWhite:0.98 alpha:1]];
    
    
    CGRect rect = CGRectMake(0, 0, Main_Screen_Width, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   RGB(200, 22, 34).CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    UIImage *imgs = [[UIImage imageNamed:@"blue_btn2"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"yue"] highlightImage:[UIImage imageNamed:@"yue"]];
    
//    self.tabBar.tintColor = UIColorFromRGB(0xf39168);
//    self.tabBar.translucent = YES;
    self.delegate = self;
    
    self.tabBar.superview.backgroundColor = [UIColor whiteColor];
    
    UIImage *img1 = [UIImage imageNamed:@"t2.png"];
    UIImage *img1_h = [UIImage imageNamed:@"t2h.png"];
    
    UIImage *img2 = [UIImage imageNamed:@"t0.png"];
    UIImage *img2_h = [UIImage imageNamed:@"t0h"];
    
    UIImage *img3 = [UIImage imageNamed:@""];
    UIImage *img3_h = [UIImage imageNamed:@""];
    
    UIImage *img4 = [UIImage imageNamed:@"t3.png"];
    UIImage *img4_h = [UIImage imageNamed:@"t3h"];
    
    UIImage *img5 = [UIImage imageNamed:@"t4.png"];
    UIImage *img5_h = [UIImage imageNamed:@"t4h"];
    
    
    
    ViewController2 *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController2"];
    vc2.title = @"广场";
    ViewController3 *vc3 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController3"];
//    ViewController4 *vc4 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController4"];
    
    if (_chatListVC == nil) {
        _chatListVC = [[ConversationListController alloc] init];
        _chatListVC.title = @"消息";
    }
    
    
    
    ViewController5 *vc5 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController5"];
    vc5.title = @"我的";
    
    CGFloat offset = 7.0;
    CGFloat offset2 = 3.0;
    
    
    NSMutableArray *vcs = [NSMutableArray array];
    
    ViewController1 *vc1_1 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
    vc1_1.title = @"精选";
    vc1_1.type = 0;
    [vcs addObject:vc1_1];
    
    ViewController1 *vc1_2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
    vc1_2.title = @"热度";
    vc1_2.type = 1;
    [vcs addObject:vc1_2];
    
    ViewController1 *vc1_3 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
    vc1_3.title = @"新人";
    vc1_3.type = 2;
    [vcs addObject:vc1_3];
    
    JYSlideSegmentController *slideSegmentController = [[JYSlideSegmentController alloc] initWithViewControllers:vcs];
    slideSegmentController.title = @"陪练";
    slideSegmentController.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    slideSegmentController.indicatorColor = RGBA(200,22,34,1);
    
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"全国" style:UIBarButtonItemStylePlain target:self action:@selector(quanguo)];
//    [leftItem setTintColor:[UIColor whiteColor]];
//    slideSegmentController.navigationItem.leftBarButtonItem = leftItem;
//    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(shaixuan)];
//    [rightItem setTintColor:[UIColor whiteColor]];
//    slideSegmentController.navigationItem.rightBarButtonItem = rightItem;
    
    
    
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        img1 = [img1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        img1_h = [img1_h imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        img2 = [img2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        img2_h = [img2_h imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        img3 = [img3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        img3_h = [img3_h imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        img4 = [img4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        img4_h = [img4_h imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        img5 = [img5 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        img5_h = [img5_h imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        
        
        UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:nil image:img1 selectedImage:img1_h];
        [item1 setTag:0];
        slideSegmentController.tabBarItem = item1;
        slideSegmentController.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
//        vc1.tabBarItem = item1;
//        vc1.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
        
        UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:nil image:img2 selectedImage:img2_h];
        [item2 setTag:1];
        vc2.tabBarItem = item2;
        vc2.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
        
        UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:nil image:img3 selectedImage:img3_h];
        [item3 setTag:2];
        vc3.tabBarItem = item3;
        vc3.tabBarItem.imageInsets = UIEdgeInsetsMake(-offset2, 0, offset2, 0);
        
        UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:nil image:img4 selectedImage:img4_h];
        [item4 setTag:3];
        _chatListVC.tabBarItem = item4;
        _chatListVC.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
        
        UITabBarItem *item5 = [[UITabBarItem alloc] initWithTitle:nil image:img5 selectedImage:img5_h];
        [item5 setTag:4];
        vc5.tabBarItem = item5;
        vc5.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
    }else{
        UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:nil image:img1 tag:0];
        slideSegmentController.tabBarItem = item1;
        slideSegmentController.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
//        vc1.tabBarItem = item1;
//        vc1.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
        
        UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:nil image:img2 tag:1];
        vc2.tabBarItem = item2;
        vc2.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
        
        UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:nil image:img3 tag:2];
        vc3.tabBarItem = item3;
        vc3.tabBarItem.imageInsets = UIEdgeInsetsMake(-offset2, 0, offset2, 0);
        
        UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:nil image:img4 tag:3];
        _chatListVC.tabBarItem = item4;
        _chatListVC.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
        
        UITabBarItem *item5 = [[UITabBarItem alloc] initWithTitle:nil image:img5 tag:4];
        vc5.tabBarItem = item5;
        vc5.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
    }
    
    
    
    
    UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:slideSegmentController];
//    UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    UINavigationController *nc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    UINavigationController *nc4 = [[UINavigationController alloc] initWithRootViewController:_chatListVC];
    UINavigationController *nc5 = [[UINavigationController alloc] initWithRootViewController:vc5];
    
    
    
    nc1.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    nc2.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    nc4.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    nc5.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    //    把导航控制器加入到数组
    NSMutableArray *viewArr_ = [NSMutableArray arrayWithObjects:nc1,nc2,vc3,nc4,nc5, nil];
    
    
    self.viewControllers = viewArr_;
    self.selectedIndex = 0;
    tempvc = nc1;
    
//    CGFloat offset = 7.0;
//    for (UITabBarItem *item in self.tabBar.items) {
//        item.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
//    }
    
    [self setupUnreadMessageCount];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    if (item.tag == 2) {
        //发布约玩
        FabuyuewanViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FabuyuewanViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [((UINavigationController *)tempvc) pushViewController:vc animated:YES];
        
//        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
//        nc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor] , NSFontAttributeName : [UIFont boldSystemFontOfSize:19]};
//        nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//        [self presentViewController:nc animated:YES completion:^{
//            
//        }];
        
        
        
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.5f;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromRight;
//        transition.delegate = self;
//        [nc.view.layer addAnimation:transition forKey:nil];
//        [self.view addSubview:nc.view];
        
        
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
//    NSLog(@"shouldSelectViewController:%@\t%@",tabBarController,viewController);
    if ([viewController isKindOfClass:[ViewController3 class]]) {
        return NO;
    }else{
        tempvc = viewController;
        return YES;
        
    }
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    DLog(@"123");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)quanguo{
    NSLog(@"全国");
}

-(void)shaixuan{
    NSLog(@"筛选");
    
}

-(void)toMyDingdan{
    self.selectedIndex = 4;
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"toMyDingdan2" object:nil];
}

#pragma mark - myaction

// Create a custom UIButton and add it to the center of our tab bar
-(void) addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    button.frame = CGRectMake(0.0, 0.0, buttonImage.size.width, buttonImage.size.height);
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
//    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0)
        button.center = self.tabBar.center;
    else
    {
        
//        CGPoint center = self.tabBar.center;
//        center.y = center.y - heightDifference/2.0;
//        button.center = center;
        
        CGPoint center = self.tabBar.center;
        center.y = self.tabBar.frame.size.height / 2 - (buttonImage.size.height - self.tabBar.frame.size.height)*0.5 ;
        button.center = center;
    }
//    [button addTarget:self action:@selector(doAction) forControlEvents:UIControlEventTouchUpInside];
    [self.tabBar addSubview:button];
    
}
////中间按钮点击事件
//-(void)doAction{
//    //发布约玩
//    FabuyuewanViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FabuyuewanViewController"];
//    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
//    nc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor] , NSFontAttributeName : [UIFont boldSystemFontOfSize:19]};
//    nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//    [self presentViewController:nc animated:YES completion:^{
//        
//    }];
//}

#pragma mark - private

-(void)registerNotifications
{
    [self unregisterNotifications];
    
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications
{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (_chatListVC == nil) {
        _chatListVC = [[ConversationListController alloc] init];
        _chatListVC.title = @"消息";
    }
    
    if (unreadCount > 0) {
        _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
    }else{
        _chatListVC.tabBarItem.badgeValue = nil;
    }
    
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}

//- (void)setupUntreatedApplyCount
//{
//    NSInteger unreadCount = [[[ApplyViewController shareController] dataSource] count];
//    if (_contactsVC) {
//        if (unreadCount > 0) {
//            _contactsVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
//        }else{
//            _contactsVC.tabBarItem.badgeValue = nil;
//        }
//    }
//}

- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}

#pragma mark - IChatManagerDelegate 消息变化

- (void)didUpdateConversationList:(NSArray *)conversationList
{
    [self setupUnreadMessageCount];
    [_chatListVC refreshDataSource];
}

// 未读消息数量变化回调
-(void)didUnreadMessagesCountChanged
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineMessages
{
    [self setupUnreadMessageCount];
}

- (void)didFinishedReceiveOfflineCmdMessages
{
    
}

- (BOOL)needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EaseMob sharedInstance].chatManager ignoredGroupIds];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    
    return ret;
}

// 收到消息回调
-(void)didReceiveMessage:(EMMessage *)message
{
    BOOL needShowNotification = (message.messageType != eMessageTypeChat) ? [self needShowNotification:message.conversationChatter] : YES;
    if (needShowNotification) {
#if !TARGET_IPHONE_SIMULATOR
        
        //        BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
        //        if (!isAppActivity) {
        //            [self showNotificationWithMessage:message];
        //        }else {
        //            [self playSoundAndVibration];
        //        }
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateActive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateInactive:
                [self playSoundAndVibration];
                break;
            case UIApplicationStateBackground:
                [self showNotificationWithMessage:message];
                break;
            default:
                break;
        }
#endif
    }
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
}

- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushNotificationOptions *options = [[EaseMob sharedInstance].chatManager pushNotificationOptions];
    //发送本地推送
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [NSDate date]; //触发通知的时间
    
    if (options.displayStyle == ePushNotificationDisplayStyle_messageSummary) {
        id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
        NSString *messageStr = nil;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Text:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case eMessageBodyType_Image:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case eMessageBodyType_Location:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case eMessageBodyType_Voice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case eMessageBodyType_Video:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
//        NSString *title = [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
        NSString *title = @"title";
        if (message.messageType == eMessageTypeGroupChat) {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:message.conversationChatter]) {
                    title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, group.groupSubject];
                    break;
                }
            }
        }
        else if (message.messageType == eMessageTypeChatRoom)
        {
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
            NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
            NSString *chatroomName = [chatrooms objectForKey:message.conversationChatter];
            if (chatroomName)
            {
                title = [NSString stringWithFormat:@"%@(%@)", message.groupSenderName, chatroomName];
            }
        }
        
        notification.alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
    }
    else{
        notification.alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
#warning 去掉注释会显示[本地]开头, 方便在开发中区分是否为本地推送
    //notification.alertBody = [[NSString alloc] initWithFormat:@"[本地]%@", notification.alertBody];
    
    notification.alertAction = NSLocalizedString(@"open", @"Open");
    notification.timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
    } else {
        notification.soundName = UILocalNotificationDefaultSoundName;
        self.lastPlaySoundDate = [NSDate date];
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.messageType] forKey:kMessageType];
    [userInfo setObject:message.conversationChatter forKey:kConversationChatter];
    notification.userInfo = userInfo;
    
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    //    UIApplication *application = [UIApplication sharedApplication];
    //    application.applicationIconBadgeNumber += 1;
}

#pragma mark - IChatManagerDelegate 登陆回调（主要用于监听自动登录是否成功）

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(EMError *)error
{
    if (error) {
        NSString *hintText = NSLocalizedString(@"reconnection.retry", @"Fail to log in your account, is try again... \nclick 'logout' button to jump to the login page \nclick 'continue to wait for' button for reconnection successful");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                                            message:hintText
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"reconnection.wait", @"continue to wait")
                                                  otherButtonTitles:NSLocalizedString(@"logout", @"Logout"),
                                  nil];
        alertView.tag = 99;
        [alertView show];
        [_chatListVC isConnect:NO];
    }
}

#pragma mark - IChatManagerDelegate 好友变化

- (void)didReceiveBuddyRequest:(NSString *)username
                       message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
    
    BOOL isAppActivity = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
    if (!isAppActivity) {
        //发送本地推送
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = [NSString stringWithFormat:NSLocalizedString(@"friend.somebodyAddWithName", @"%@ add you as a friend"), username];
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
    }
#endif
    
//    [_contactsVC reloadApplyView];
}

- (void)_removeBuddies:(NSArray *)userNames
{
    [[EaseMob sharedInstance].chatManager removeConversationsByChatters:userNames deleteMessages:YES append2Chat:YES];
    [_chatListVC refreshDataSource];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    ChatViewController *chatViewContrller = nil;
    for (id viewController in viewControllers)
    {
        if ([viewController isKindOfClass:[ChatViewController class]] && [userNames containsObject:[(ChatViewController *)viewController conversation].chatter])
        {
            chatViewContrller = viewController;
            break;
        }
    }
    if (chatViewContrller)
    {
        [viewControllers removeObject:chatViewContrller];
        if ([viewControllers count] > 0) {
            [self.navigationController setViewControllers:@[viewControllers[0]] animated:YES];
        } else {
            [self.navigationController setViewControllers:viewControllers animated:YES];
        }
    }
    [self showHint:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"delete", @"delete"), userNames[0]]];
}

- (void)didUpdateBuddyList:(NSArray *)buddyList
            changedBuddies:(NSArray *)changedBuddies
                     isAdd:(BOOL)isAdd
{
    if (!isAdd)
    {
        NSMutableArray *deletedBuddies = [NSMutableArray array];
        for (EMBuddy *buddy in changedBuddies)
        {
            if ([buddy.username length])
            {
                [deletedBuddies addObject:buddy.username];
            }
        }
        if (![deletedBuddies count])
        {
            return;
        }
        
        [self _removeBuddies:deletedBuddies];
    } else {
        // clear conversation
        NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
        NSMutableArray *deleteConversations = [NSMutableArray arrayWithArray:conversations];
        NSMutableDictionary *buddyDic = [NSMutableDictionary dictionary];
        for (EMBuddy *buddy in buddyList) {
            if ([buddy.username length]) {
                [buddyDic setObject:buddy forKey:buddy.username];
            }
        }
        for (EMConversation *conversation in conversations) {
            if (conversation.conversationType == eConversationTypeChat) {
                if ([buddyDic objectForKey:conversation.chatter]) {
                    [deleteConversations removeObject:conversation];
                }
            } else {
                [deleteConversations removeObject:conversation];
            }
        }
        if ([deleteConversations count] > 0) {
//            NSMutableArray *deletedBuddies = [NSMutableArray array];
//            for (EMConversation *conversation in deleteConversations) {
//                if (![[RobotManager sharedInstance] isRobotWithUsername:conversation.chatter]) {
//                    [deletedBuddies addObject:conversation.chatter];
//                }
//            }
//            if ([deletedBuddies count] > 0) {
//                [self _removeBuddies:deletedBuddies];
//            }
        }
    }
//    [_contactsVC reloadDataSource];
}

- (void)didRemovedByBuddy:(NSString *)username
{
    [self _removeBuddies:@[username]];
//    [_contactsVC reloadDataSource];
}

- (void)didAcceptedByBuddy:(NSString *)username
{
//    [_contactsVC reloadDataSource];
}

- (void)didRejectedByBuddy:(NSString *)username
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.beRefusedToAdd", @"you are shameless refused by '%@'"), username];
    DLog(@"%@",message);
//    TTAlertNoTitle(message);
}

- (void)didAcceptBuddySucceed:(NSString *)username
{
//    [_contactsVC reloadDataSource];
}

#pragma mark - IChatManagerDelegate 群组变化

- (void)didReceiveGroupInvitationFrom:(NSString *)groupId
                              inviter:(NSString *)username
                              message:(NSString *)message
{
#if !TARGET_IPHONE_SIMULATOR
    [self playSoundAndVibration];
#endif
    
//    [_contactsVC reloadGroupView];
}

//接收到入群申请
- (void)didReceiveApplyToJoinGroup:(NSString *)groupId
                         groupname:(NSString *)groupname
                     applyUsername:(NSString *)username
                            reason:(NSString *)reason
                             error:(EMError *)error
{
    if (!error) {
#if !TARGET_IPHONE_SIMULATOR
        [self playSoundAndVibration];
#endif
        
//        [_contactsVC reloadGroupView];
    }
}

- (void)didReceiveGroupRejectFrom:(NSString *)groupId
                          invitee:(NSString *)username
                           reason:(NSString *)reason
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"friend.beRefusedToAdd", @"you are shameless refused by '%@'"), username];
    DLog(@"%@",message);
//    TTAlertNoTitle(message);
}


- (void)didReceiveAcceptApplyToJoinGroup:(NSString *)groupId
                               groupname:(NSString *)groupname
{
    NSString *message = [NSString stringWithFormat:NSLocalizedString(@"group.agreedAndJoined", @"agreed to join the group of \'%@\'"), groupname];
    [self showHint:message];
}

#pragma mark - IChatManagerDelegate 收到聊天室邀请

- (void)didReceiveChatroomInvitationFrom:(NSString *)chatroomId
                                 inviter:(NSString *)username
                                 message:(NSString *)message
{
    message = [NSString stringWithFormat:NSLocalizedString(@"chatroom.somebodyInvite", @"%@ invite you to join chatroom \'%@\'"), username, chatroomId];
    [self showHint:message];
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//        alertView.tag = 100;
//        [alertView show];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginAtOtherDevice", @"your login account has been in other places") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
        
    } onQueue:nil];
}

- (void)didRemovedFromServer
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES completion:^(NSDictionary *info, EMError *error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") delegate:self cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//        alertView.tag = 101;
//        [alertView show];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"prompt", @"Prompt") message:NSLocalizedString(@"loginUserRemoveFromServer", @"your account has been removed from the server side") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedString(@"ok", @"OK") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
        }];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    } onQueue:nil];
}

- (void)didServersChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

- (void)didAppkeyChanged
{
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@NO];
}

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        [self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
        }else{
            [self showHint:NSLocalizedString(@"reconnection.success", @"reconnection successful！")];
        }
    }
}

#pragma mark - public

- (void)jumpToChatList
{
    if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
//        ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
//                [chatController hideImagePicker];
    }
    else if(_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

- (EMConversationType)conversationTypeFromMessageType:(EMMessageType)type
{
    EMConversationType conversatinType = eConversationTypeChat;
    switch (type) {
        case eMessageTypeChat:
            conversatinType = eConversationTypeChat;
            break;
        case eMessageTypeGroupChat:
            conversatinType = eConversationTypeGroupChat;
            break;
        case eMessageTypeChatRoom:
            conversatinType = eConversationTypeChatRoom;
            break;
        default:
            break;
    }
    return conversatinType;
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo)
    {
        if ([self.navigationController.topViewController isKindOfClass:[ChatViewController class]]) {
//            ChatViewController *chatController = (ChatViewController *)self.navigationController.topViewController;
            //            [chatController hideImagePicker];
        }
        
        NSArray *viewControllers = self.navigationController.viewControllers;
        [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if (obj != self)
            {
                if (![obj isKindOfClass:[ChatViewController class]])
                {
                    [self.navigationController popViewControllerAnimated:NO];
                }
                else
                {
                    NSString *conversationChatter = userInfo[kConversationChatter];
                    ChatViewController *chatViewController = (ChatViewController *)obj;
                    if (![chatViewController.conversation.chatter isEqualToString:conversationChatter])
                    {
                        [self.navigationController popViewControllerAnimated:NO];
                        EMMessageType messageType = [userInfo[kMessageType] intValue];
                        chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                        switch (messageType) {
                            case eMessageTypeGroupChat:
                            {
                                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                                for (EMGroup *group in groupArray) {
                                    if ([group.groupId isEqualToString:conversationChatter]) {
                                        chatViewController.title = group.groupSubject;
                                        break;
                                    }
                                }
                            }
                                break;
                            default:
                                chatViewController.title = conversationChatter;
                                break;
                        }
                        [self.navigationController pushViewController:chatViewController animated:NO];
                    }
                    *stop= YES;
                }
            }
            else
            {
                ChatViewController *chatViewController = (ChatViewController *)obj;
                NSString *conversationChatter = userInfo[kConversationChatter];
                EMMessageType messageType = [userInfo[kMessageType] intValue];
                chatViewController = [[ChatViewController alloc] initWithConversationChatter:conversationChatter conversationType:[self conversationTypeFromMessageType:messageType]];
                switch (messageType) {
                    case eMessageTypeGroupChat:
                    {
                        NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                        for (EMGroup *group in groupArray) {
                            if ([group.groupId isEqualToString:conversationChatter]) {
                                chatViewController.title = group.groupSubject;
                                break;
                            }
                        }
                    }
                        break;
                    default:
                        chatViewController.title = conversationChatter;
                        break;
                }
                [self.navigationController pushViewController:chatViewController animated:NO];
            }
        }];
    }
    else if (_chatListVC)
    {
        [self.navigationController popToViewController:self animated:NO];
        [self setSelectedViewController:_chatListVC];
    }
}

@end
