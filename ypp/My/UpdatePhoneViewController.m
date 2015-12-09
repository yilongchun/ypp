//
//  UpdatePhoneViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/7.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "UpdatePhoneViewController.h"
#import "Util.h"
#import "NSObject+Blocks.h"

@interface UpdatePhoneViewController (){
    NSDictionary *user;
    NSNumber *code;
}

@end

@implementation UpdatePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改手机绑定";
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"blue_btn2"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    
    [_getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_getCodeBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    user = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER];
    
    NSString *mobile = [user objectForKey:@"mobile"];
    if (![mobile isEqualToString:@""] && mobile.length > 7) {
        _oldPhoneTextField.text = [NSString stringWithFormat:@"%@****%@",[mobile substringToIndex:3],[mobile substringFromIndex:7]];
    }
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

- (IBAction)getCode:(id)sender {
    
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

-(void)requestSMSVerifyCode{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [self showHudInView:self.view];
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

- (IBAction)submit:(id)sender {
    
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    //验证手机号是否为空
    if (_phoneTextField.text == nil || [_phoneTextField.text isEqualToString:@""]) {
        [self showHint:@"手机号不能为空！"];
        [_phoneTextField becomeFirstResponder];
        return;
    }
    //验证验证码是否为空
    if (_codeTextField.text == nil || [_codeTextField.text isEqualToString:@""]) {
        [self showHint:@"验证码不能为空！"];
        [_codeTextField becomeFirstResponder];
        return;
    }
    
//    if (![_codeTextField.text isEqualToString:[NSString stringWithFormat:@"%d",[code intValue]]]) {
//        [self showHint:@"验证码错误，请重新输入!"];
//        return;
//    }
    
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_PASSWORD];
    if (![_passwordTextField.text isEqualToString:password]) {
        [self showHint:@"密码错误!"];
        return;
    }
    
    [self showHudInView:self.view];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER];
    [parameters setValue:[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"id"]] forKey:@"userid"];
    [parameters setValue:_phoneTextField.text forKey:@"nphone"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_UPDATEPHONE];
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
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
                [self performBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                } afterDelay:1.5];
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
                [_getCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                _getCodeBtn.userInteractionEnabled = YES;
                _getCodeBtn.enabled = YES;
            });
        }else{
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                //NSLog(@"____%@",strTime);
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [_getCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
                _getCodeBtn.userInteractionEnabled = NO;
                _getCodeBtn.enabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}
@end
