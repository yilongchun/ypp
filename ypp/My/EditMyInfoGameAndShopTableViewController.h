//
//  EditMyInfoGameAndShopTableViewController.h
//  ypp
//
//  Created by Stephen Chin on 15/12/11.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditMyInfoGameAndShopTableViewController : UITableViewController

@property int type;//1 游戏 2 门店
@property (nonatomic,strong) NSDictionary *userinfo;

@end
