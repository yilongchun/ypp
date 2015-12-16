//
//  XieyiViewController.h
//  ypp
//
//  Created by Stephen Chin on 15/12/16.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XieyiViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *mywebview;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
- (IBAction)agree:(id)sender;
@end
