//
//  ApplyPlayerTableViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/16.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "ApplyPlayerTableViewController.h"
#import "TextViewController.h"

#define Image_msg @"点击更换图片，共4张，需要包含游戏名，游戏区，角色，等级等信息"

@interface ApplyPlayerTableViewController (){
    NSMutableArray *chosedImages;
    
    NSString *gameid;//游戏id
    NSString *gamename;//游戏名称
    NSString *cityid;   //陪玩城市
    NSString *cityname;   //陪玩城市
    NSString *storeid;   //默认地点（选择城市下的门店）
    NSString *storename;  //默认地点（选择城市下的门店）
    NSNumber *pirce;   //陪玩单价
    NSString *tag;  //标签
    NSString *showphone;  //是否显示联系方式   0 1
    NSString *phone;  //如果是，联系方式 手机号码
    
    //申请证明----------------------------
    NSString *gameareaid;    //游戏区（和游戏有关，字典表）
    NSString *gameareaname;  //游戏区（和游戏有关，字典表）
    NSString *rolename; //角色 文字描述
    NSString *danname; //段位 文字描述
    NSString *strengths;   //擅长位置 文字描述
    NSString *level; //等级 文字描述
    NSString *pics; //4张图片（游戏名、游戏区、角色、等级  ） ，逗号隔开
}

@end

@implementation ApplyPlayerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
//    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
//    [self.tableView setTableFooterView:v];
    
    self.title = @"申请陪练";
    
    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [applyBtn setTitle:@"申请审核" forState:UIControlStateNormal];
    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    UIImage *backgroundImage = [[UIImage imageNamed:@"blue_btn2"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    [applyBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [applyBtn setFrame:CGRectMake(15, 10, Main_Screen_Width - 30, 50)];
    [applyBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIView *tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 70)];
    [tableFootView addSubview:applyBtn];
    tableFootView.backgroundColor = [UIColor whiteColor];
    [self.tableView setTableFooterView:tableFootView];
    
    chosedImages = [NSMutableArray array];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setValue:)
                                                 name:@"setValue" object:nil];
    
}

- (void)setValue:(NSNotification *)text{
    NSLog(@"column:%@",text.userInfo[@"column"]);
    NSLog(@"columnValue:%@",text.userInfo[@"columnValue"]);
    NSLog(@"－－－－－接收到通知------");
    
    NSString *column = text.userInfo[@"column"];
    NSString *columnValue = text.userInfo[@"columnValue"];
    if ([column isEqualToString:@"tag"]) {//标签
        tag = columnValue;
    }
    if ([column isEqualToString:@"phone"]) {//显示号码
        phone = columnValue;
    }
    if ([column isEqualToString:@"rolename"]) {//角色
        rolename = columnValue;
    }
    if ([column isEqualToString:@"danname"]) {//段位
        danname = columnValue;
    }
    if ([column isEqualToString:@"strengths"]) {//擅长位置
        strengths = columnValue;
    }
    if ([column isEqualToString:@"level"]) {//等级
        level = columnValue;
    }
    [self.tableView reloadData];
}

//添加照片
-(void)addImgs{
    [self showImagePicker];
}

-(void)showImagePicker{
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

//删除照片
-(void)deleteImgs:(UITapGestureRecognizer *)recognizer{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除照片吗?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [chosedImages removeObjectAtIndex:recognizer.view.tag];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:5 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

//申请陪练
-(void)save{
    
    [self showHudInView:self.view];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"] forKey:@"userid"];//申请人id
    [parameters setValue:[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"user_name"] forKey:@"username"];//申请人名称
    
//    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_DARENSUBMIT];
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
//    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        NSLog(@"JSON: %@", operation.responseString);
//        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSError *error;
//        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
//        if (dic == nil) {
//            [self hideHud];
//            NSLog(@"json parse failed \r\n");
//        }else{
//            NSNumber *status = [dic objectForKey:@"status"];
//            if ([status intValue] == ResultCodeSuccess) {
//                
//            }else{
//                [self hideHud];
//                NSString *message = [dic objectForKey:@"message"];
//                [self showHint:message];
//            }
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"发生错误！%@",error);
//        [self hideHud];
//        [self showHint:@"连接失败"];
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSData* data = UIImageJPEGRepresentation(image,0.2f);
        DLog(@"%lu",(unsigned long)data.length);
        UIImage *choosedImage = [UIImage imageWithData:data];
        [chosedImages addObject:choosedImage];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:5 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
//        [self uploadImage];
        
        
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

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Main_Screen_Width-10, 40)];
    if (section == 0) {
        label.text = @"基本信息";
    }else if (section == 1){
        label.text = @"申请证明";
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 40)];
    view.backgroundColor = RGB(240, 240, 240);
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if (indexPath.row == 5) {
            CGFloat width = (Main_Screen_Width - 40) / 4;
            
            UIFont *font = [UIFont systemFontOfSize:13];
            CGSize textSize;
            if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
                NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
                
                textSize = [Image_msg boundingRectWithSize:CGSizeMake(Main_Screen_Width - 16, MAXFLOAT)
                                                 options:options
                                              attributes:attributes
                                                 context:nil].size;
            }
            return width + 20 + textSize.height + 10;
        }
    }
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    }
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        if (indexPath.row == 5) {
            CGFloat x = 8;
            CGFloat width = (Main_Screen_Width - 40) / 4;
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(8, 10 + width + 8, Main_Screen_Width - 16, 1)];
                label.text = Image_msg;
                label.font = [UIFont systemFontOfSize:13];
                label.numberOfLines = 0;
                [label sizeToFit];
                [cell.contentView addSubview:label];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            for (UIView *view in cell.contentView.subviews) {
                if ([view isKindOfClass:[UIImageView class]] || [view isKindOfClass:[UIButton class]]) {
                    [view removeFromSuperview];
                }
            }
            
            
            
            
            if ([chosedImages count] == 0) {
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 10, width, width)];
                [btn setBackgroundImage:[UIImage imageNamed:@"compose_pic_add"] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"compose_pic_add_highlighted"] forState:UIControlStateHighlighted];
                [btn addTarget:self action:@selector(addImgs) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:btn];
            }else{
                
                
                for (int i = 0; i < [chosedImages count]; i++) {
                    
                    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(x, 10, width, width)];
                    [imageview setImage:[chosedImages objectAtIndex:i]];
                    imageview.layer.masksToBounds = YES;
                    imageview.layer.cornerRadius = 5.0;
                    imageview.tag = i;
                    imageview.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(deleteImgs:)];
                    [imageview addGestureRecognizer:tap];
                    
                    [cell.contentView addSubview:imageview];
                    x += width + 8;
                }
                if ([chosedImages count] < 4) {
                    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 10, width, width)];
                    [btn setBackgroundImage:[UIImage imageNamed:@"compose_pic_add"] forState:UIControlStateNormal];
                    [btn setBackgroundImage:[UIImage imageNamed:@"compose_pic_add_highlighted"] forState:UIControlStateHighlighted];
                    [btn addTarget:self action:@selector(addImgs) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:btn];
                }
            }
            
            DLog(@"%lu",(unsigned long)cell.contentView.subviews.count);
            
            return cell;
        }
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    
    if (indexPath.section == 0) {//基本信息
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"游戏";
                break;
            case 1:
                cell.textLabel.text = @"陪玩城市";
                break;
            case 2:
                cell.textLabel.text = @"陪玩地点";
                break;
            case 3:
                cell.textLabel.text = @"陪玩单价";
                break;
            case 4:
                cell.textLabel.text = @"标签(选填)";
                cell.detailTextLabel.text = tag;
                break;
            case 5:
                cell.textLabel.text = @"联系方式";//显示手机号码 不显示手机号码
                break;
            case 6:
                cell.textLabel.text = @"显示号码";
                cell.detailTextLabel.text = phone;
                break;
            default:
                break;
        }
    }else if (indexPath.section == 1){//申请证明
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"游戏区";
                break;
            case 1:
                cell.textLabel.text = @"角色";
                cell.detailTextLabel.text = rolename;
                break;
            case 2:
                cell.textLabel.text = @"段位(选填)";
                cell.detailTextLabel.text = danname;
                break;
            case 3:
                cell.textLabel.text = @"擅长位置(选填)";
                cell.detailTextLabel.text = strengths;
                break;
            case 4:
                cell.textLabel.text = @"等级";
                cell.detailTextLabel.text = level;
                break;
            case 5:{
            }
                break;
            default:
                break;
        }
    }
    return cell;
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {//游戏列表
            
        }
        if (indexPath.row == 1) {//城市选择
            
        }
        if (indexPath.row == 2) {//地点选择
            
        }
        if (indexPath.row == 3) {//单价弹出 选择
            
        }
        if (indexPath.row == 4) {//标签 文本域
            TextViewController *vc = [[TextViewController alloc] init];
            vc.title = @"标签";
            vc.column = @"tag";
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 5) {//联系方式 选择
            
        }
        if (indexPath.row == 6) {//显示号码 文本域
            TextViewController *vc = [[TextViewController alloc] init];
            vc.title = @"显示号码";
            vc.column = @"phone";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {//游戏区 选择
            
        }
        if (indexPath.row == 1) {//角色 文本域
            TextViewController *vc = [[TextViewController alloc] init];
            vc.title = @"角色";
            vc.column = @"rolename";
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2) {//段位 文本域
            TextViewController *vc = [[TextViewController alloc] init];
            vc.title = @"段位(选填)";
            vc.column = @"danname";
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 3) {//擅长位置 文本域
            TextViewController *vc = [[TextViewController alloc] init];
            vc.title = @"擅长位置(选填)";
            vc.column = @"strengths";
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 4) {//等级 文本域
            TextViewController *vc = [[TextViewController alloc] init];
            vc.title = @"等级";
            vc.column = @"level";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}



@end
