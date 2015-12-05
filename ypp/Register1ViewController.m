//
//  Register1ViewController.m
//  ypp
//
//  Created by haidony on 15/11/9.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "Register1ViewController.h"
#import "Register2ViewController.h"
#import "Util.h"

@interface Register1ViewController (){
    NSTimer *timer;
    NSDate *fireTime;
    
    UIButton *getCodeBtn;
}

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
    
    getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, 7, 140, 41)];
    [getCodeBtn setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getCodeBtn setBackgroundImage:[UIImage imageNamed:@"money_btn_h"] forState:UIControlStateNormal];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [getCodeBtn addTarget:self action:@selector(getCode) forControlEvents:UIControlEventTouchUpInside];
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 55)];
    [rightView addSubview:getCodeBtn];
    self.checkCodeTextField.rightViewMode = UITextFieldViewModeAlways;
    self.checkCodeTextField.rightView = rightView;
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)getCode{
    //验证手机号是否为空
    if (_phoneTextField.text == nil || [_phoneTextField.text isEqualToString:@""]) {
        [self showHint:@"手机号不能为空！"];
        [_phoneTextField becomeFirstResponder];
        return;
    }
    //验证手机号码格式
    else{
        BOOL isPhone = [Util isValidateMobile:_phoneTextField.text];
        if (isPhone) {
            [self requestSMSVerifyCode];
        }
        else{
            [self showHint:@"请输入正确格式的手机号！"];
            [_phoneTextField becomeFirstResponder];
            return;
        }
    }
}
//发送手机验证码
-(void)requestSMSVerifyCode{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [self showHudInView:self.view hint:@""];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_phoneTextField.text forKey:@"phone"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_SENDCODE];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHud];
        [self startTimer];
        [self showHint:@"验证码已发送"];
        NSLog(@"JSON: %@", operation.responseString);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"验证码发送失败"];
        
    }];
}

-(void)done{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    //验证手机号是否为空
    if (_phoneTextField.text == nil || [_phoneTextField.text isEqualToString:@""]) {
        [self showHint:@"手机号不能为空！"];
        [_phoneTextField becomeFirstResponder];
        return;
    }
    //验证验证码是否为空
    if (_checkCodeTextField.text == nil || [_checkCodeTextField.text isEqualToString:@""]) {
        [self showHint:@"验证码不能为空！"];
        [_checkCodeTextField becomeFirstResponder];
        return;
    }
    
    Register2ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Register2ViewController"];
    vc.phone = _phoneTextField.text;
    [self.navigationController pushViewController:vc
                                         animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 倒计时
- (void)startTimer{
    
    fireTime = [NSDate dateWithTimeIntervalSinceNow:61];//60秒后时间
    if (timer != nil) {
        if ([timer isValid]) {
            [timer invalidate];
        }
        timer = nil;
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
}

- (void)timerFireMethod:(NSTimer *)timerBasis{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];//当前时间
    unsigned int unitFlags = NSCalendarUnitSecond;
    NSDateComponents *d = [calendar components:unitFlags fromDate:today toDate:fireTime options:0];//计算时间差
    //    DLog(@"d:%@",d);
    if ([d second] > 0) {
        getCodeBtn.enabled = NO;
        [getCodeBtn invalidateIntrinsicContentSize];
        getCodeBtn.alpha = 0.3;
        [getCodeBtn setTitle:[NSString stringWithFormat:@"%ld秒后重新发送", (long)[d second]] forState:UIControlStateDisabled];
    }else{
        [timerBasis invalidate];
        getCodeBtn.enabled = YES;
        getCodeBtn.alpha = 1.0;
        [getCodeBtn setTitle:@"点击获取验证码" forState:UIControlStateNormal];
        getCodeBtn.enabled = YES;
    }
}

@end
