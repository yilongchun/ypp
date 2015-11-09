//
//  Register1ViewController.m
//  ypp
//
//  Created by haidony on 15/11/9.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "Register1ViewController.h"
#import "Register2ViewController.h"

@interface Register1ViewController ()

@end

@implementation Register1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    
//    backItem.title = @"返回";
    
    self.title = @"注册(1/3)";
    
    [self.view setBackgroundColor:BACKGROUND_COLOR];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor] , NSFontAttributeName : [UIFont boldSystemFontOfSize:19]};
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 40, 55)];
    label.text = @"中国";
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textColor = NAVIGATION_BAR_COLOR;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 55)];
    [leftView addSubview:label];
    
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTextField.leftView = leftView;
    self.phoneTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.phoneTextField.layer.borderWidth = 0.4f;
    
    self.checkCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    self.checkCodeTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 25, 1)];
    self.checkCodeTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.checkCodeTextField.layer.borderWidth = 0.4f;
    
    UIButton *getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 120, 41)];
    [getCodeBtn setTitle:@"获取验证" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getCodeBtn setBackgroundImage:[UIImage imageNamed:@"money_btn_h"] forState:UIControlStateNormal];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [getCodeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 130, 55)];
    [rightView addSubview:getCodeBtn];
    self.checkCodeTextField.rightViewMode = UITextFieldViewModeAlways;
    self.checkCodeTextField.rightView = rightView;
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)getCode{
    NSLog(@"getCode");
}

-(void)done{
    Register2ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Register2ViewController"];
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
