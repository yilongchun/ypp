//
//  UpdatePhoneViewController.h
//  ypp
//
//  Created by Stephen Chin on 15/12/7.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePhoneViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UITextField *oldPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
- (IBAction)getCode:(id)sender;
- (IBAction)submit:(id)sender;
@end
