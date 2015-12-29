//
//  LoginViewController.m
//  ypp
//
//  Created by haidony on 15/11/9.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgetPasswordViewController.h"
#import "MainTabBarController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"登录";
    
    [self.view setBackgroundColor:RGBA(200,22,34,1)];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    self.phoneTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 1)];
    self.phoneTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.phoneTextField.layer.borderWidth = 0.4f;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 1)];
    self.passwordTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.passwordTextField.layer.borderWidth = 0.4f;
    
    
    UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(toForgetPassword)];
    [self.forgetPasswordLabel addGestureRecognizer:click];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    self.phoneTextField.text = @"18771790556";
    self.passwordTextField.text = @"123456";
}

-(void)toForgetPassword{
    ForgetPasswordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)done{
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    if (_phoneTextField.text.length == 0) {
        [self showHint:@"请输入账号"];
        return;
    }
    if (_passwordTextField.text.length == 0) {
        [self showHint:@"请输入密码"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_phoneTextField.text forKey:@"phone"];
    [parameters setValue:_passwordTextField.text forKey:@"password"];
//    [parameters setValue:[NSNumber numberWithFloat:31.624108] forKey:@"xpoint"];
//    [parameters setValue:[NSNumber numberWithFloat:115.415695] forKey:@"ypoint"];
    
    [self showHudInView:self.view];
    NSString *str = [NSString stringWithFormat:@"%@%@",HOST,API_LOGIN];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHud];
        //NSLog(@"JSON: %@", responseObject);
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"登录%@",result);
        
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == ResultCodeSuccess) {
                
                NSDictionary *info = [[dic objectForKey:@"message"] cleanNull];
                
                [[NSUserDefaults standardUserDefaults] setObject:_phoneTextField.text forKey:LOGINED_PHONE];
                [[NSUserDefaults standardUserDefaults] setObject:_passwordTextField.text forKey:LOGINED_PASSWORD];
                [[NSUserDefaults standardUserDefaults] setObject:info forKey:LOGINED_USER];
                
                NSLog(@"info:\t%@",info);
                
                    MainTabBarController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
                    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                
                    //UIModalTransitionStyleCoverVertical 从下往上
                    //UIModalTransitionStyleFlipHorizontal 翻转
                    //UIModalTransitionStyleCrossDissolve 渐变
                    //UIModalTransitionStylePartialCurl 翻书
                    [self presentViewController:vc animated:YES completion:^{
                        [self removeFromParentViewController];
                    }];
            }else{
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self hideHud];
        [self showHint:error.description];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.navigationController.navigationBar.translucent = NO;
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
