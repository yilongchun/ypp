//
//  PrepareViewController.m
//  ypp
//
//  Created by haidony on 15/11/9.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "PrepareViewController.h"
#import "LoginViewController.h"

@interface PrepareViewController ()

@end

@implementation PrepareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(toLogin)
                                                 name:@"tologin" object:nil];
    
    self.regBtn.layer.masksToBounds = YES;
    self.regBtn.layer.cornerRadius = 8.0f;
//    UIImage *backgroundImage = [[UIImage imageNamed:@"blue_btn2"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
//    [_regBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    self.loginBtn.layer.masksToBounds = YES;
    self.loginBtn.layer.cornerRadius = 8.0f;
    self.loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginBtn.layer.borderWidth = 1.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)toLogin{
    LoginViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:vc animated:YES];
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
