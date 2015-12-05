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
    
    [self.view setBackgroundColor:NAVIGATION_BAR_COLOR];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor] , NSFontAttributeName : [UIFont boldSystemFontOfSize:19]};
    
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
}

-(void)toForgetPassword{
    ForgetPasswordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)done{
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
//    if (self.account.text.length == 0) {
//        [self showHintInCenter:@"请输入账号"];
//        return;
//    }
//    if (self.password.text.length == 0) {
//        [self showHintInCenter:@"请输入密码"];
//        return;
//    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"18771790556" forKey:@"phone"];
    [parameters setValue:@"fanwe" forKey:@"password"];
    [parameters setValue:[NSNumber numberWithFloat:31.624108] forKey:@"xpoint"];
    [parameters setValue:[NSNumber numberWithFloat:115.415695] forKey:@"ypoint"];
    
    
    
    [self showHudInView:self.view hint:@"加载中"];
    NSString *str = [NSString stringWithFormat:@"%@%@",HOST,API_LOGIN];
//    NSURL *url = [NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    [request setTimeoutInterval:30.0];
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    //方法一：
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    //注意：默认的Response为json数据
    //    [manager setResponseSerializer:[AFXMLParserResponseSerializer new]];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//使用这个将得到的是NSData
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];//使用这个将得到的是JSON
    
    
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain; charset=utf-8"];
    //    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    
    //SEND YOUR REQUEST
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",result);
//        NSString *str = [responseObject objectForKey:@"KEY 1"];
//        NSArray *arr = [responseObject objectForKey:@"KEY 2"];
//        NSDictionary *dic = [responseObject objectForKey:@"KEY 3"];
        
        //...
        [self hideHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self hideHud];
        [self showHint:error.description];
    }];
    
    
    
    
    
    
    MainTabBarController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabBarController"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    //UIModalTransitionStyleCoverVertical 从下往上
    //UIModalTransitionStyleFlipHorizontal 翻转
    //UIModalTransitionStyleCrossDissolve 渐变
    //UIModalTransitionStylePartialCurl 翻书
    [self presentViewController:vc animated:YES completion:^{
        [self removeFromParentViewController];
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
