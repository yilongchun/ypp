//
//  Register3ViewController.h
//  ypp
//
//  Created by haidony on 15/11/9.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+RGSize.h"

#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame       (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))

@interface Register3ViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *password;

@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;
- (IBAction)chooseImage:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
- (IBAction)chooseSex:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *birthdayBtn;
- (IBAction)chooseBirthday:(id)sender;




@end
