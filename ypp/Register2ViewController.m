//
//  Register2ViewController.m
//  ypp
//
//  Created by haidony on 15/11/9.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "Register2ViewController.h"
#import "Register3ViewController.h"

@interface Register2ViewController ()

@end

@implementation Register2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"注册(2/3)";
    
    [self.view setBackgroundColor:RGBA(235,235,235,1)];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor] , NSFontAttributeName : [UIFont boldSystemFontOfSize:19]};
    
    self.password1TextField.leftViewMode = UITextFieldViewModeAlways;
    self.password1TextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 1)];;
    self.password1TextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.password1TextField.layer.borderWidth = 0.4f;
    
    self.password2TextField.leftViewMode = UITextFieldViewModeAlways;
    self.password2TextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 1)];
    self.password2TextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.password2TextField.layer.borderWidth = 0.4f;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)done{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    //验证密码1是否为空
    if (_password1TextField.text == nil || [_password1TextField.text isEqualToString:@""]) {
        [self showHint:@"请输入新密码！"];
        [_password1TextField becomeFirstResponder];
        return;
    }
    if (_password2TextField.text == nil || [_password2TextField.text isEqualToString:@""]) {
        [self showHint:@"请再次输入密码！"];
        [_password2TextField becomeFirstResponder];
        return;
    }
    if (![_password1TextField.text isEqualToString:_password2TextField.text]) {
        [self showHint:@"两次密码不一致，请重新输入！"];
        [_password1TextField becomeFirstResponder];
        return;
    }
    
    Register3ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Register3ViewController"];
    vc.phone = _phone;
    vc.password = _password1TextField.text;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
