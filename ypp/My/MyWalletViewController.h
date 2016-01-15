//
//  MyWalletViewController.h
//  ypp
//
//  Created by Stephen Chin on 16/1/15.
//  Copyright © 2016年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyWalletViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *mytableview;
@property (strong, nonatomic) NSDictionary *userinfo;

@end
