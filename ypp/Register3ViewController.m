//
//  Register3ViewController.m
//  ypp
//
//  Created by haidony on 15/11/9.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "Register3ViewController.h"
#import "Util.h"
#import "NSObject+Blocks.h"

@interface Register3ViewController (){
    UIImage *choosedImage;
}

@end

@implementation Register3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.title = @"注册(3/3)";
    
    [self.view setBackgroundColor:RGBA(235,235,235,1)];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    self.nameTextField.leftViewMode = UITextFieldViewModeAlways;
    self.nameTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 1)];
}

-(void)save{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    
    if (choosedImage == nil) {
        [self showHint:@"请选择照片！"];
        return;
    }
    if ([_nameTextField.text isEqualToString:@""]) {
        [self showHint:@"请填写名字！"];
        return;
    }
    
    [self showHudInView:self.view];
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000*1000;
    //[fileNamesArray addObject:[NSString stringWithFormat:@"%llu.jpg",recordTime]];
    
    NSString *imagename = [NSString stringWithFormat:@"%llu.jpg",recordTime];
    NSMutableURLRequest *request = [Util postRequestWithParems:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,API_UPLOADIMG]] image:choosedImage imageName:imagename];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", operation.responseString);
        
        NSString *result = [NSString stringWithFormat:@"%@",[operation responseString]];
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == 200) {
                //保存数据
                [self saveData:imagename];
            }else{
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
            }
        }
        
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",[error localizedDescription]);
        [self hideHud];
        [self showHint:@"上传失败"];
    }];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

-(void)saveData:(NSString *)picname{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:picname forKey:@"avatar"];
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
                [self performBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [self performBlock:^{
                        [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"tologin" object:nil];
                    } afterDelay:1.5];
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

- (IBAction)chooseImage:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"用户相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker2 = [[UIImagePickerController alloc] init];
        imagePicker2.delegate = self;
        imagePicker2.allowsEditing = NO;
        imagePicker2.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker2.mediaTypes =  [[NSArray alloc] initWithObjects:@"public.image", nil];
        [[imagePicker2 navigationBar] setTintColor:[UIColor whiteColor]];
        [[imagePicker2 navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, nil]];
        [self presentViewController:imagePicker2 animated:YES completion:nil];
    }];
    [alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //检查相机模式是否可用
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            NSLog(@"sorry, no camera or camera is unavailable.");
            return;
        }
        UIImagePickerController  *imagePicker1 = [[UIImagePickerController alloc] init];
        imagePicker1.delegate = self;
        imagePicker1.allowsEditing = NO;
        imagePicker1.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker1.mediaTypes =  [[NSArray alloc] initWithObjects:@"public.image", nil];
        [self presentViewController:imagePicker1 animated:YES completion:nil];
    }];
    [alert addAction:action2];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        choosedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self.chooseBtn setImage:choosedImage forState:UIControlStateNormal];
        //        NSData* data = UIImageJPEGRepresentation(img,0.7f);
        //        DLog(@"type:%d",type);
        //[self uploadImage:data];
        
        
        
        
        
        //        NSData *fildData = UIImageJPEGRepresentation(img, 0.5);//UIImagePNGRepresentation(img); //
        //照片
        //        [self uploadImg:fildData];
        //        self.fileData = UIImageJPEGRepresentation(img, 1.0);
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
        
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // bug fixes: UIIMagePickerController使用中偷换StatusBar颜色的问题
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType ==     UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
    //    if([viewController isKindOfClass:[SettingViewController class]]){
    //        NSLog(@"返回");
    //        return;
    //    }
}

@end
