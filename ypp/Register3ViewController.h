//
//  Register3ViewController.h
//  ypp
//
//  Created by haidony on 15/11/9.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Register3ViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *password;

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
- (IBAction)chooseImage:(id)sender;

@end
