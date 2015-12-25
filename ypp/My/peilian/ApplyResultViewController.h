//
//  ApplyResultViewController.h
//  ypp
//
//  Created by Stephen Chin on 15/12/17.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyResultViewController : UIViewController

@property (strong, nonatomic) NSString *resultCode;

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UILabel *msg1;
@property (weak, nonatomic) IBOutlet UILabel *msg2;


@end
