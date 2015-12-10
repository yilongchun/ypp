//
//  DongtaiDetailViewController.h
//  ypp
//
//  Created by Stephen Chin on 15/12/10.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DongtaiDetailViewController : UIViewController{
    NSMutableArray *dataSource;
}

@property (strong, nonatomic) IBOutlet UITableView *mytableview;
//@property (strong, nonatomic) IBOutlet UIView *keyboardBackview;
@property (strong, nonatomic) NSDictionary *info;
//@property (weak, nonatomic) IBOutlet UITextField *mytextfield;

@end
