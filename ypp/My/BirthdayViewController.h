//
//  BirthdayViewController.h
//  ypp
//
//  Created by Stephen Chin on 15/12/9.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BirthdayViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIDatePicker *myPicker;
@property (strong, nonatomic) NSDate *birthday;
@property (weak, nonatomic) IBOutlet UILabel *agelabel;
@property (weak, nonatomic) IBOutlet UILabel *xingzuoLabel;

@end
