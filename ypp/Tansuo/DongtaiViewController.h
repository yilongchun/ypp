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

@end
