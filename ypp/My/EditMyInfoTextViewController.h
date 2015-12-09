//
//  EditMyInfoTextViewController.h
//  ypp
//
//  Created by Stephen Chin on 15/12/9.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditMyInfoTextViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *mytextview;

@property (strong, nonatomic) NSString *column;
@property (strong, nonatomic) NSString *columnValue;

@end
