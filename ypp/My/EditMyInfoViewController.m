//
//  EditMyInfoViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/7.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "EditMyInfoViewController.h"
#import "EditMyInfoTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "EditMyInfoTextViewController.h"
#import "Util.h"

@interface EditMyInfoViewController (){
    NSDictionary *userinfo;
    UIImage *choosedImage;
    int tag;//标识 头像1 或者 相册2
}

@end

@implementation EditMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        //        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadUser)
                                                 name:@"loadUser" object:nil];
    
    //    [self.mytableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    //    [self.mytableview registerClass:[MyInfoTableViewCell class] forCellReuseIdentifier:@"myimgcell"];
    if ([self.mytableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mytableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mytableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mytableview setLayoutMargins:UIEdgeInsetsZero];
    }
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.mytableview setTableFooterView:v];
    
    _mytableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadUser];
    }];
    
    userinfo = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] cleanNull];
}

-(void)loadUser{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"id"]] forKey:@"userid"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_GETUSERINFO];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [_mytableview.mj_header endRefreshing];
        NSLog(@"JSON: %@", operation.responseString);
        
        NSString *result = [NSString stringWithFormat:@"%@",[operation responseString]];
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == 200) {
                userinfo = [[dic objectForKey:@"message"] cleanNull];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGINED_USER];
                [[NSUserDefaults standardUserDefaults] setObject:userinfo forKey:LOGINED_USER];
                [_mytableview reloadData];
            }else{
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [_mytableview.mj_header endRefreshing];
        [self showHint:@"连接失败"];
    }];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 130;
    }else if (indexPath.row == 1){
        CGFloat width = (Main_Screen_Width - 40) / 4;
        return 10 + width +10 + 23;
    }
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 12;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        EditMyInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.userImg.layer.masksToBounds = YES;
        cell.userImg.layer.borderWidth = 1.5;
        cell.userImg.layer.borderColor = [UIColor whiteColor].CGColor;
        cell.userImg.layer.cornerRadius = 5.0;
        cell.userImg.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(updateImage)];
        [cell.userImg addGestureRecognizer:tap];
        
//        NSString *user_name = [userinfo objectForKey:@"user_name"];
        NSString *avatar = [userinfo objectForKey:@"avatar"];
//        cell2.usernameLabel.text = user_name;
//        
        [cell.userImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HOST,PIC_PATH,avatar]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
        return cell;
    }else if (indexPath.row == 1){
        UITableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        CGFloat width = (Main_Screen_Width - 40) / 4;
        if (cell3 == nil) {
            cell3 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
            cell3.selectionStyle = UITableViewCellSelectionStyleNone;
            cell3.backgroundColor = RGB(248, 248, 248);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + width + 10, Main_Screen_Width - 10, 17)];
            label.text = @"基本资料";
            label.font = [UIFont systemFontOfSize:15];
            [cell3.contentView addSubview:label];
        }
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, width, width)];
        [btn setBackgroundImage:[UIImage imageNamed:@"compose_pic_add"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"compose_pic_add_highlighted"] forState:UIControlStateHighlighted];
        [cell3.contentView addSubview:btn];
        
        
        return cell3;
    }else{
        UITableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell2 == nil) {
            cell2 = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell2"];
            cell2.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            [cell2.textLabel setFont:[UIFont systemFontOfSize:16]];
            [cell2.detailTextLabel setFont:[UIFont systemFontOfSize:16]];
        }
        switch (indexPath.row) {
            case 2:{
                cell2.textLabel.text = @"名字";
                NSString *user_name = [userinfo objectForKey:@"user_name"];
                if ([user_name isEqualToString:@""]) {
                    cell2.detailTextLabel.text = @"未填写";
                }else{
                    cell2.detailTextLabel.text = user_name;
                }
            }
                break;
            case 3:{
                cell2.textLabel.text = @"年龄";
                cell2.detailTextLabel.text = @"未填写";
            }
                break;
            case 4:{
                cell2.textLabel.text = @"星座";
                cell2.detailTextLabel.text = @"未填写";
            }
                break;
            case 5:{
                cell2.textLabel.text = @"个性签名";
                NSString *signature = [userinfo objectForKey:@"signature"];
                if ([signature isEqualToString:@""]) {
                    cell2.detailTextLabel.text = @"未填写";
                }else{
                    cell2.detailTextLabel.text = signature;
                }
            }
                break;
            case 6:{
                cell2.textLabel.text = @"行业";
                cell2.detailTextLabel.text = @"未填写";
            }
                break;
            case 7:{
                cell2.textLabel.text = @"公司";
                NSString *company = [userinfo objectForKey:@"company"];
                if ([company isEqualToString:@""]) {
                    cell2.detailTextLabel.text = @"未填写";
                }else{
                    cell2.detailTextLabel.text = company;
                }
            }
                break;
            case 8:{
                cell2.textLabel.text = @"学校";
                NSString *school = [userinfo objectForKey:@"school"];
                if ([school isEqualToString:@""]) {
                    cell2.detailTextLabel.text = @"未填写";
                }else{
                    cell2.detailTextLabel.text = school;
                }
            }
                break;
            case 9:{
                cell2.textLabel.text = @"城市";
                cell2.detailTextLabel.text = @"未填写";
            }
                break;
            case 10:{
                cell2.textLabel.text = @"常玩游戏";
                cell2.detailTextLabel.text = @"未填写";
            }
                break;
            case 11:{
                cell2.textLabel.text = @"常去门店";
                cell2.detailTextLabel.text = @"未填写";
            }
                break;
            default:
                break;
        }
        return cell2;
    }
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 2:{
            EditMyInfoTextViewController *vc = [[EditMyInfoTextViewController alloc] init];
            vc.title = @"名字";
            vc.column = @"name";
            NSString *user_name = [userinfo objectForKey:@"user_name"];
            vc.columnValue = user_name;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 5:{
            EditMyInfoTextViewController *vc = [[EditMyInfoTextViewController alloc] init];
            vc.title = @"个性签名";
            vc.column = @"signature";
            NSString *signature = [userinfo objectForKey:@"signature"];
            vc.columnValue = signature;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 7:{
            EditMyInfoTextViewController *vc = [[EditMyInfoTextViewController alloc] init];
            vc.title = @"公司";
            vc.column = @"company";
            NSString *company = [userinfo objectForKey:@"company"];
            vc.columnValue = company;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 8:{
            EditMyInfoTextViewController *vc = [[EditMyInfoTextViewController alloc] init];
            vc.title = @"学校";
            vc.column = @"school";
            NSString *school = [userinfo objectForKey:@"school"];
            vc.columnValue = school;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.navigationController.navigationBar.translucent = NO;
}

//修改头像
-(void)updateImage{
    tag = 1;
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

-(void)uploadImage{
    [self showHudInView:self.view];
    
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000*1000;
    
    NSString *imagename = [NSString stringWithFormat:@"%@_%llu.jpg",[userinfo objectForKey:@"id"],recordTime];
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

-(void)saveData:(NSString *)imagename{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"id"]] forKey:@"userid"];
    [parameters setValue:imagename forKey:@"avatar"];
    
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
            if ([status intValue] == 200) {
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"loadUser" object:nil];
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

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSData* data = UIImageJPEGRepresentation(image,0.2f);
         DLog(@"%lu",(unsigned long)data.length);
        choosedImage = [UIImage imageWithData:data];
        
        if (tag == 1) {
            [self uploadImage];
        }
        
//        [self.chooseBtn setImage:choosedImage forState:UIControlStateNormal];
        
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
