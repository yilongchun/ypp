//
//  MainTabBarController.h
//  ypp
//
//  Created by haidony on 15/11/4.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMob.h"

@interface MainTabBarController : UITabBarController<UITabBarControllerDelegate>{
    EMConnectionState _connectionState;
}

- (void)jumpToChatList;

@end
