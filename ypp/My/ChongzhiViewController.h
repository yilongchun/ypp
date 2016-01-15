//
//  ChongzhiViewController.h
//  ypp
//
//  Created by Stephen Chin on 16/1/15.
//  Copyright © 2016年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChongzhiViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *mytableview;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
- (IBAction)pay:(id)sender;

@end
