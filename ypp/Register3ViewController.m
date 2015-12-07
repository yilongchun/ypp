//
//  Register3ViewController.m
//  ypp
//
//  Created by haidony on 15/11/9.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "Register3ViewController.h"

@interface Register3ViewController ()

@end

@implementation Register3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"注册(3/3)";
    
    [self.view setBackgroundColor:RGBA(235,235,235,1)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 1)];
}

-(void)done{
    
    [self showHudInView:self.view];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_phone forKey:@"phone"];
    [parameters setObject:_password forKey:@"password"];
    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"invitecode"];
    [parameters setObject:_nameTextField.text forKey:@"name"];
    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"sex"];
    [parameters setObject:[NSNumber numberWithInt:1988] forKey:@"byear"];
    [parameters setObject:[NSNumber numberWithInt:11] forKey:@"bmonth"];
    [parameters setObject:[NSNumber numberWithInt:11] forKey:@"bday"];
    [parameters setObject:[NSNumber numberWithFloat:31.624108] forKey:@"xpoint"];
    [parameters setObject:[NSNumber numberWithFloat:115.415695] forKey:@"ypoint"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_REGISTER];
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
            }else{
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
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
