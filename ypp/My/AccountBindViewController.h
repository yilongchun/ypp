//
//  AccountBindViewController.h
//  ypp
//
//  Created by Stephen Chin on 15/12/7.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountBindViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idnumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *membershipcardnumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
- (IBAction)getCode:(id)sender;
- (IBAction)submit:(id)sender;

@end
