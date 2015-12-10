//
//  BirthdayViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/9.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "BirthdayViewController.h"
#import "Util.h"
#import "NSDate+Addition.h"
#import "NSObject+Blocks.h"

@interface BirthdayViewController ()

@end

@implementation BirthdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"出生日期";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    [rightItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.myPicker.datePickerMode = UIDatePickerModeDate;
    [self.myPicker setMaximumDate:[NSDate date]];
    
    [self.myPicker setDate:_birthday];
    
    [self.myPicker addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
    
    NSInteger age = [NSDate ageWithDateOfBirth:_birthday];
    self.agelabel.text = [NSString stringWithFormat:@"%ld岁",(long)age];
    int month = [[_birthday dateWithFormat:@"MM"] intValue];
    int day = [[_birthday dateWithFormat:@"dd"] intValue];
    NSString *astro = [Util getAstroWithMonth:month day:day];
    self.xingzuoLabel.text = [NSString stringWithFormat:@"%@座",astro];
}

-(void)valueChanged{
    int month = [[self.myPicker.date dateWithFormat:@"MM"] intValue];
    int day = [[self.myPicker.date dateWithFormat:@"dd"] intValue];
    NSString *astro = [Util getAstroWithMonth:month day:day];
    
    NSInteger age = [NSDate ageWithDateOfBirth:_myPicker.date];
    self.agelabel.text = [NSString stringWithFormat:@"%ld岁",(long)age];
    self.xingzuoLabel.text = [NSString stringWithFormat:@"%@座",astro];
}

-(void)save{
    [self showHudInView:self.view];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER];
    [parameters setValue:[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"id"]] forKey:@"userid"];
    [parameters setObject:[NSNumber numberWithInt:[[_myPicker.date dateWithFormat:@"yyyy"] intValue]] forKey:@"byear"];
    [parameters setObject:[NSNumber numberWithInt:[[_myPicker.date dateWithFormat:@"MM"] intValue]] forKey:@"bmonth"];
    [parameters setObject:[NSNumber numberWithInt:[[_myPicker.date dateWithFormat:@"dd"] intValue]] forKey:@"bday"];
    [parameters setValue:self.xingzuoLabel.text forKey:@"constellation"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_UPDATEUSER];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHud];
        
        NSLog(@"JSON: %@", operation.responseString);
        
        NSString *result = [NSString stringWithFormat:@"%@",[operation responseString]];
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == ResultCodeSuccess) {
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
                [self performBlock:^{
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"loadUser" object:nil];
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
