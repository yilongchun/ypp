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
#import "NSDate+Addition.h"

@interface Register3ViewController (){
    UIImage *choosedImage;
    NSDate *date;
    int sex;
}

@property (strong, nonatomic) IBOutlet UIDatePicker *myPicker;
@property (strong, nonatomic) IBOutlet UIView *pickerBgView;
@property (strong, nonatomic) UIView *maskView;

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
    
    self.myPicker.datePickerMode = UIDatePickerModeDate;
    [self.myPicker setMaximumDate:[NSDate date]];
    [self initView];
}

#pragma mark - init view
- (void)initView {
    
    self.maskView = [[UIView alloc] initWithFrame:kScreen_Frame];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    
    self.pickerBgView.width = kScreen_Width;
}

#pragma mark - private method
- (void)showMyPicker {
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.pickerBgView];
    self.maskView.alpha = 0.3;
    self.pickerBgView.top = self.view.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.pickerBgView.bottom = self.view.height;
    }];
}

- (void)hideMyPicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.pickerBgView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}


#pragma mark - xib click

- (IBAction)cancel:(id)sender {
    [self hideMyPicker];
}

- (IBAction)ensure:(id)sender {
    date = self.myPicker.date;
    NSString *dateS = [date dateWithFormat:@"yyyy-MM-dd"];
    [self.birthdayBtn setTitle:dateS forState:UIControlStateNormal];
    [self hideMyPicker];
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
    if ([_sexBtn.currentTitle isEqualToString:@"选择性别"]) {
        [self showHint:@"请选择性别！"];
        return;
    }
    if (date == nil) {
        [self showHint:@"请选择生日"];
        return;
    }
    
    [self showHudInView:self.view];
    
    NSData *data = UIImageJPEGRepresentation(choosedImage, 1.0);
    [self getToken:data];
}

//七牛上传图片
/**************************************/
//上传第一步
-(void)getToken:(NSData *)data{
    [self showHudInView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,PHOTO_UPTOKEN_URL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"token: %@", operation.responseString);
        NSString *token = [NSString stringWithFormat:@"%@",[operation responseString]];
        [self uploadImage:token imageData:data];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
}
//上传第二步
-(void)uploadImage:(NSString *)token imageData:(NSData *)data{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:token forKey:@"token"];
    NSString *urlString = [NSString stringWithFormat:@"%@",QINIU_UPLOAD];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"1.png" mimeType:@"image/png"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"JSON: %@", operation.responseString);
        DLog(@"上传图片 第二步 带上 token 上传文件 成功");
        NSString *result = [NSString stringWithFormat:@"%@",[operation responseString]];
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSString *key = [dic objectForKey:@"key"];
            DLog(@"key:%@",key);
            [self saveData:key];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        DLog(@"上传图片 第二步 带上 token 上传文件 失败");
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
}

-(void)saveData:(NSString *)picname{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:picname forKey:@"avatar"];
    [parameters setValue:_phone forKey:@"phone"];
    [parameters setObject:_password forKey:@"password"];
    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"invitecode"];
    [parameters setObject:_nameTextField.text forKey:@"name"];
    [parameters setObject:[NSNumber numberWithInt:sex] forKey:@"sex"];
    [parameters setObject:[NSNumber numberWithInt:[[date dateWithFormat:@"yyyy"] intValue]] forKey:@"byear"];
    [parameters setObject:[NSNumber numberWithInt:[[date dateWithFormat:@"MM"] intValue]] forKey:@"bmonth"];
    [parameters setObject:[NSNumber numberWithInt:[[date dateWithFormat:@"dd"] intValue]] forKey:@"bday"];
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
            if ([status intValue] == ResultCodeSuccess) {
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
                [self performBlock:^{
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter]
                         postNotificationName:@"tologin" object:nil];
                    
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

- (IBAction)chooseSex:(id)sender {
    
    UIAlertController *sexAlert = [UIAlertController alertControllerWithTitle:@"请选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sex = 1;
        [self.sexBtn setTitle:@"男" forState:UIControlStateNormal];
        [self.sexBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sex = 0;
        [self.sexBtn setTitle:@"女" forState:UIControlStateNormal];
        [self.sexBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }];
    [sexAlert addAction:action1];
    [sexAlert addAction:action2];
    [self presentViewController:sexAlert animated:YES completion:^{
        
    }];
    
    
}
- (IBAction)chooseBirthday:(id)sender {
    [self showMyPicker];
}
@end
