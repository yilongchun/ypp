//
//  ApplyPlayerTableViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/16.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "ApplyPlayerTableViewController.h"
#import "TextViewController.h"
#import "TagViewController.h"
#import "UIView+RGSize.h"
#import "GameAndShopTableViewController.h"
#import "EditAddressViewController.h"
#import "Util.h"
#import "NSObject+Blocks.h"


#define Image_msg @"点击更换图片，共4张，需要包含游戏名，游戏区，角色，等级等信息"

@interface ApplyPlayerTableViewController (){
    
    MBProgressHUD *HUD;
    CGPoint contentOffsetPoint;
    
    NSMutableArray *chosedImages;
    NSMutableArray *imageKeys;
    
    NSString *gameid;//游戏id
    NSString *gamename;//游戏名称
    NSString *cityid;   //陪玩城市
    NSString *cityname;   //陪玩城市
    NSString *storeid;   //默认地点（选择城市下的门店）
    NSString *storename;  //默认地点（选择城市下的门店）
    NSString *price;   //陪玩单价
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
    
    NSArray *priceArray;
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
    
    priceArray = [NSArray arrayWithObjects:@"39", @"59", @"99", @"129", @"199", nil];
    
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
    imageKeys = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setValue:)
                                                 name:@"setValue" object:nil];
    
    [self initView];
}

- (void)setValue:(NSNotification *)text{
    
    NSString *column = text.userInfo[@"column"];
    NSString *columnValue = text.userInfo[@"columnValue"];
    
    if ([column isEqualToString:@"gameid"]) {//游戏id
        gameid = columnValue;
        gameareaid = nil;
        gameareaname = nil;
    }
    if ([column isEqualToString:@"gamename"]) {//游戏名称
        gamename = columnValue;
    }
    if ([column isEqualToString:@"cityname"]) {//城市
        cityname = columnValue;
    }
    if ([column isEqualToString:@"storeid"]) {//地点id
        storeid = columnValue;
    }
    if ([column isEqualToString:@"storename"]) {//地点名称
        storename = columnValue;
    }
    if ([column isEqualToString:@"tag"]) {//标签
        tag = columnValue;
    }
    if ([column isEqualToString:@"phone"]) {//显示号码
        phone = columnValue;
    }
    if ([column isEqualToString:@"gameareaid"]) {//游戏区id
        gameareaid = columnValue;
    }
    if ([column isEqualToString:@"gameareaname"]) {//游戏区名称
        gameareaname = columnValue;
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

//联系方式
-(void)choosePhoneType{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"显示手机号码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        showphone = @"显示手机号码";
        phone = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"mobile"];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:5 inSection:0];
        NSIndexPath *indexpath2 = [NSIndexPath indexPathForRow:6 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexpath,indexpath2] withRowAnimation:UITableViewRowAnimationFade];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"不显示手机号码" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        showphone = @"不显示手机号码";
        phone = @"无";
       
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:5 inSection:0];
        NSIndexPath *indexpath2 = [NSIndexPath indexPathForRow:6 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:@[indexpath,indexpath2] withRowAnimation:UITableViewRowAnimationFade];
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

//申请陪练
-(void)save{
    
    
    
    if (gameid == nil) {
        [self showHint:@"请选择游戏"];
        return;
    }
    if (cityname == nil) {
        [self showHint:@"请选择城市"];
        return;
    }
    if (storeid == nil) {
        [self showHint:@"请选择地点"];
        return;
    }
    if (price == nil) {
        [self showHint:@"请选择单价"];
        return;
    }
    if (showphone == nil) {
        [self showHint:@"请选择联系方式"];
        return;
    }
    if (gameareaid == nil) {
        [self showHint:@"请选择游戏区"];
        return;
    }
    if (rolename == nil) {
        [self showHint:@"请填写角色"];
        return;
    }
    if (level == nil) {
        [self showHint:@"请填写等级"];
        return;
    }
    if([chosedImages count] == 0){
        [self showHint:@"请上传图片"];
        return;
    }
    
    //提示 是否确定申请游神
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.yOffset = contentOffsetPoint.y;
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    //上传图片
    for (UIImage *image in chosedImages) {
        NSData *data = UIImageJPEGRepresentation(image, 1.0);
        [self getToken:data];
    }
}

//七牛上传图片
/**************************************/
//上传第一步
-(void)getToken:(NSData *)data{
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
            
            [imageKeys addObject:key];
            
            if ([imageKeys count] == [chosedImages count]) {
                pics = [imageKeys componentsJoinedByString:@","];
                [self saveData];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        DLog(@"上传图片 第二步 带上 token 上传文件 失败");
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
}
//保存数据
-(void)saveData{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"] forKey:@"userid"];//申请人id
    [parameters setValue:[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"user_name"] forKey:@"username"];//申请人名称
    [parameters setValue:gameid forKey:@"gameid"];//游戏id
    [parameters setValue:gamename forKey:@"gamename"];//游戏名称
    [parameters setValue:@"0" forKey:@"cityid"];
    [parameters setValue:cityname forKey:@"cityname"];//陪玩城市
    [parameters setValue:storeid forKey:@"storeid"];//陪玩地点 门店id
    [parameters setValue:storename forKey:@"storename"];//陪玩地点 门店名称
    [parameters setValue:price forKey:@"price"];//陪玩单价
    [parameters setValue:tag forKey:@"tag"];//标签
    if ([showphone isEqualToString:@"显示手机号码"]) {
        [parameters setValue:@"1" forKey:@"showphone"];//联系方式
        [parameters setValue:phone forKey:@"phone"];//电话号码
    }else{
        [parameters setValue:@"0" forKey:@"showphone"];//联系方式
        [parameters setValue:@"" forKey:@"phone"];//电话号码
    }
    
    [parameters setValue:gameareaid forKey:@"gameareaid"];//游戏id
    [parameters setValue:gameareaname forKey:@"gameareaname"];//游戏名称
    [parameters setValue:rolename forKey:@"rolename"];//角色
    [parameters setValue:danname forKey:@"danname"];//段位
    [parameters setValue:strengths forKey:@"strengths"];//擅长位置
    [parameters setValue:level forKey:@"level"];//等级
    [parameters setValue:pics forKey:@"pics"];//图片
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_DARENSUBMIT];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HUD hide:YES];
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
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"loadUser" object:nil];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } afterDelay:1.5];
            }else{
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [HUD hide:YES];
        [self showHint:@"连接失败"];
    }];
}


/**************************************/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSData* data = UIImageJPEGRepresentation(image,1.0f);
        DLog(@"%lu",(unsigned long)data.length);
        UIImage *choosedImage = [UIImage imageWithData:data];
        [chosedImages addObject:choosedImage];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:5 inSection:1];
        [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    return 50;
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
            return cell;
        }
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    }
    
    if (indexPath.section == 0) {//基本信息
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"游戏";
                cell.detailTextLabel.text = gamename;
                break;
            case 1:
                cell.textLabel.text = @"陪玩城市";
                cell.detailTextLabel.text = cityname;
                break;
            case 2:
                cell.textLabel.text = @"陪玩地点";
                cell.detailTextLabel.text = storename;
                break;
            case 3:
                cell.textLabel.text = @"陪玩单价";//39 59 99 129 199
                cell.detailTextLabel.text = price;
                break;
            case 4:
                cell.textLabel.text = @"标签(选填)";
                cell.detailTextLabel.text = tag;
                break;
            case 5:
                cell.textLabel.text = @"联系方式";//显示手机号码 不显示手机号码
                cell.detailTextLabel.text = showphone;
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
                cell.detailTextLabel.text = gameareaname;
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
            GameAndShopTableViewController *vc = [[GameAndShopTableViewController alloc] init];
            vc.type = 1;
            vc.title = @"选择游戏";
            vc.columnId = @"gameid";
            vc.columnIdValue = gameid;
            vc.column = @"gamename";
            vc.columnValue = gamename;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 1) {//城市选择
            EditAddressViewController *vc = [[EditAddressViewController alloc] init];
            vc.type = 1;
            vc.column = @"cityname";
            vc.columnValue = cityname;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2) {//地点选择
            GameAndShopTableViewController *vc = [[GameAndShopTableViewController alloc] init];
            vc.type = 2;
            vc.title = @"选择地点";
            vc.columnId = @"storeid";
            vc.columnIdValue = storeid;
            vc.column = @"storename";
            vc.columnValue = storename;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 3) {//单价弹出 选择
            [self showMyPicker];
        }
        if (indexPath.row == 4) {//标签 文本域
            TagViewController *vc = [[TagViewController alloc] init];
            vc.tagValue = tag;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 5) {//联系方式 选择
            [self choosePhoneType];
        }
        if (indexPath.row == 6) {//显示号码 文本域
            TextViewController *vc = [[TextViewController alloc] init];
            vc.title = @"显示号码";
            vc.column = @"phone";
            vc.columnValue = phone;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {//游戏区 选择
            if (gameid == nil || [gameid isEqualToString:@""]) {
                [self showHint:@"请先选择游戏"];
            }else{
                GameAndShopTableViewController *vc = [[GameAndShopTableViewController alloc] init];
                vc.type = 3;
                vc.title = @"选择游戏区";
                vc.columnId = @"gameareaid";
                vc.columnIdValue = gameareaid;
                vc.column = @"gameareaname";
                vc.columnValue = gameareaname;
                vc.gameid = gameid;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
        if (indexPath.row == 1) {//角色 文本域
            TextViewController *vc = [[TextViewController alloc] init];
            vc.title = @"角色";
            vc.column = @"rolename";
            vc.columnValue = rolename;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2) {//段位 文本域
            TextViewController *vc = [[TextViewController alloc] init];
            vc.title = @"段位(选填)";
            vc.column = @"danname";
            vc.columnValue = danname;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 3) {//擅长位置 文本域
            TextViewController *vc = [[TextViewController alloc] init];
            vc.title = @"擅长位置(选填)";
            vc.column = @"strengths";
            vc.columnValue = strengths;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 4) {//等级 文本域
            TextViewController *vc = [[TextViewController alloc] init];
            vc.title = @"等级";
            vc.column = @"level";
            vc.columnValue = level;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UIScrollViewDelegate
//滑动到底部
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    contentOffsetPoint = self.tableView.contentOffset;
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [priceArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [priceArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
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
    self.maskView.alpha = 0;
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
    price = [priceArray objectAtIndex:[self.myPicker selectedRowInComponent:0]];
    [self hideMyPicker];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:3 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
