//
//  DongtaiViewController.h
//  ypp
//
//  Created by Stephen Chin on 15/12/7.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DongtaiViewController : UIViewController{
    NSMutableArray *dataSource;
}

@property (strong, nonatomic) IBOutlet UITableView *mytableview;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *dongtaiUserId;//查询个人动态专用

@end
