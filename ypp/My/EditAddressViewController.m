//
//  EditAddressViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/11.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "EditAddressViewController.h"
#import "NSObject+Blocks.h"

@interface EditAddressViewController (){
    NSDictionary *pickerDic;
    NSArray *provinceArray;
    NSArray *cityArray;
    NSArray *townArray;
    NSArray *selectedArray;
}

@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择城市";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    [rightItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self initData];
}

-(void)initData{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    provinceArray = [pickerDic allKeys];
    selectedArray = [pickerDic objectForKey:[[pickerDic allKeys] objectAtIndex:0]];
    if (selectedArray.count > 0) {
        cityArray = [[selectedArray objectAtIndex:0] allKeys];
    }
    if (cityArray.count > 0) {
        townArray = [[selectedArray objectAtIndex:0] objectForKey:[cityArray objectAtIndex:0]];
    }
}

//-(void)save{
//    DLog(@"%@",[provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]]);
//    DLog(@"%@",[cityArray objectAtIndex:[self.myPicker selectedRowInComponent:1]]);
//    DLog(@"%@",[townArray objectAtIndex:[self.myPicker selectedRowInComponent:2]]);
//    
//    NSString *province = [provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]];
//    NSString *city = [cityArray objectAtIndex:[self.myPicker selectedRowInComponent:1]];
//    NSString *town = [townArray objectAtIndex:[self.myPicker selectedRowInComponent:2]];
//    NSString *value = [NSString stringWithFormat:@"%@%@%@",province,city,town];
////    [self updateUserInfo:@"diqu" value:value];
//    
//    
//}

-(void)save{
    [self showHudInView:self.view];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER];
    [parameters setValue:[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"id"]] forKey:@"userid"];
    
    NSString *province = [provinceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]];
    NSString *city = [cityArray objectAtIndex:[self.myPicker selectedRowInComponent:1]];
    NSString *town = [townArray objectAtIndex:[self.myPicker selectedRowInComponent:2]];
    NSString *value = [NSString stringWithFormat:@"%@ %@ %@",province,city,town];
    
    [parameters setValue:value forKey:@"city"];
    
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

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return provinceArray.count;
    } else if (component == 1) {
        return cityArray.count;
    } else {
        return townArray.count;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [cityArray objectAtIndex:row];
    } else {
        return [townArray objectAtIndex:row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        selectedArray = [pickerDic objectForKey:[provinceArray objectAtIndex:row]];
        if (selectedArray.count > 0) {
            cityArray = [[selectedArray objectAtIndex:0] allKeys];
        } else {
            cityArray = nil;
        }
        if (cityArray.count > 0) {
            townArray = [[selectedArray objectAtIndex:0] objectForKey:[cityArray objectAtIndex:0]];
        } else {
            townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (selectedArray.count > 0 && cityArray.count > 0) {
            townArray = [[selectedArray objectAtIndex:0] objectForKey:[cityArray objectAtIndex:row]];
        } else {
            townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    [pickerView reloadComponent:2];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
