//
//  TextViewController.h
//  ypp
//
//  Created by Stephen Chin on 15/12/16.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *mytextview;
@property (strong, nonatomic) NSString *column;
@property (strong, nonatomic) NSString *columnValue;

@end
