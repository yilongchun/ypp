//
//  FabudongtaiViewController.h
//  ypp
//
//  Created by Stephen Chin on 15/12/7.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FabudongtaiViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextView *mytextview;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
- (IBAction)chooseImage:(id)sender;

@end
