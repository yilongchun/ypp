//
//  GameAndShopTableViewController.h
//  ypp
//
//  Created by Stephen Chin on 15/12/17.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameAndShopTableViewController : UITableViewController

@property int type;//1 游戏 2 门店 3 游戏区

@property (strong, nonatomic) NSString *columnId;
@property (strong, nonatomic) NSString *columnIdValue;
@property (strong, nonatomic) NSString *column;
@property (strong, nonatomic) NSString *columnValue;

@property (strong, nonatomic) NSString *gameid;//游戏区参数

@end
