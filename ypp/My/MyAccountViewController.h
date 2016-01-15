//
//  MyAccountViewController.h
//  ypp
//
//  Created by Stephen Chin on 16/1/15.
//  Copyright © 2016年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *chongzhiBtn;
@property (weak, nonatomic) IBOutlet UIButton *tixianBtn;

- (IBAction)pay:(id)sender;

@end
