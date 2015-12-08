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
    NSNumber *code;
}

@end

@implementation Register1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    
//    backItem.title = @"返回";
    
    self.title = @"注册(1/3)";
    
    [self.view setBackgroundColor:RGBA(235,235,235,1)];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor] , NSFontAttributeName : [UIFont boldSystemFontOfSize:19]};
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 40, 55)];
    label.text = @"中国";
    label.font = [UIFont boldSystemFontOfSize:18];
//    label.textColor = RGBA(200,22,34,1);
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
    [getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"blue_btn2"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    [getCodeBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
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
        
        NSLog(@"JSON: %@", operation.responseString);
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == 200) {
                [self startTime];
                code = [dic objectForKey:@"code"];
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
            }else{
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
            }
        }
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
    
    if (![_checkCodeTextField.text isEqualToString:[NSString stringWithFormat:@"%d",[code intValue]]]) {
        [self showHint:@"验证码错误，请重新输入!"];
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
-(void)startTime{
    __block int timeout=30; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                getCodeBtn.userInteractionEnabled = YES;
                getCodeBtn.enabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [getCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                getCodeBtn.userInteractionEnabled = NO;
                getCodeBtn.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

@end
