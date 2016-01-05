//
//  DongtaiDetailViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/10.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "DongtaiDetailViewController.h"
#import "DongtaiDetailTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Addition.h"
#import "NSDate+TimeAgo.h"
#import "IQKeyboardManager.h"
#import "PinglunTableViewCell.h"
#import "PlayerViewController.h"
#import "MyInfoViewController.h"
#import "YYWebImage.h"

@interface DongtaiDetailViewController (){
    NSMutableArray *zanArr;
    NSMutableArray *pinglunArr;
    UIScrollView *zanScrollView;
    int page;
}

@property (strong, nonatomic) UIView *keyboardBackview;
@property (nonatomic, strong) UITextField *mytextfield;
@property (nonatomic, strong) UIButton *button;

@end

@implementation DongtaiDetailViewController
@synthesize info;

- (id)init{
    self = [super init];
    if(self){
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"动态详情";
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    //添加手势，点击输入框其他区域隐藏键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGr.cancelsTouchesInView =NO;
    [self.mytableview addGestureRecognizer:tapGr];
    
    //添加键盘监听器
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    self.keyboardBackview = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height - 44 - 64, Main_Screen_Width, 44)];
    self.keyboardBackview.backgroundColor = RGB(247, 247, 247);
    [self.view addSubview:self.keyboardBackview];
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 1)];
    topLine.backgroundColor = RGB(200, 200, 200);
    [self.keyboardBackview addSubview:topLine];
    self.mytextfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, Main_Screen_Width - 50 -10, 30)];
    self.mytextfield.borderStyle = UITextBorderStyleRoundedRect;
    self.mytextfield.backgroundColor = RGB(250, 250, 250);
    self.mytextfield.placeholder = @"输入评论...";
    self.mytextfield.font = [UIFont fontWithName:@"Arial" size:15.0f];
    self.mytextfield.clearButtonMode = UITextFieldViewModeAlways;
    self.mytextfield.returnKeyType = UIReturnKeyDefault;
    
    
    [self.mytextfield addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.keyboardBackview addSubview:self.mytextfield];
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(Main_Screen_Width - 50, 6, 50, 32);
    [self.button setTitle:@"发送" forState:0];
    [self.keyboardBackview  addSubview:self.button];
    self.button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.button addTarget:self action:@selector(sendMess) forControlEvents:UIControlEventTouchUpInside];
    self.button.enabled = NO;
    
    zanArr = [NSMutableArray array];
    pinglunArr = [NSMutableArray array];
    _mytableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadPinglun];
    }];
    _mytableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadPinglunMore];
    }];
    
    DLog(@"%@",info);
    
    [self loadZan];
    [self loadPinglun];
}

//加载点赞
-(void)loadZan{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[info objectForKey:@"topicid"] forKey:@"topicid"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_FAVTOPIC_LIST];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", operation.responseString);
        
        NSString *result = [NSString stringWithFormat:@"%@",[operation responseString]];
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == ResultCodeSuccess) {
                NSArray *users = [dic objectForKey:@"message"];
                zanArr = [NSMutableArray arrayWithArray:users];
                
//                [zanArr addObjectsFromArray:users];
//                [zanArr addObjectsFromArray:users];
//                [zanArr addObjectsFromArray:users];
//                [zanArr addObjectsFromArray:users];
//                [zanArr addObjectsFromArray:users];
//                [zanArr addObjectsFromArray:users];
//                [zanArr addObjectsFromArray:users];
//                [zanArr addObjectsFromArray:users];
//                [zanArr addObjectsFromArray:users];
//                [zanArr addObjectsFromArray:users];
//                [zanArr addObjectsFromArray:users];
//                [zanArr addObjectsFromArray:users];
                
                if ([zanArr count] > 0) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//                    DongtaiDetailTableViewCell *cell = [self.mytableview cellForRowAtIndexPath:indexPath];
                    [_mytableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                    int x = 10;
//                    for (NSDictionary *user in zanArr) {
//                        NSString *avatar = [user objectForKey:@"avatar"];
//                        UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(x, cell.bottomLabel.frame.origin.y + 5, 50, 50)];
//                        DLog(@"%f",cell.bottomLabel.frame.origin.y);
//                        [userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HOST,PIC_PATH,avatar]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
//                        userImage.backgroundColor = [UIColor lightGrayColor];
//                        [cell.contentView addSubview:userImage];
//                        x += 55;
//                    }
                }
            }else{
//                NSString *message = [dic objectForKey:@"message"];
//                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
}

//加载评论
-(void)loadPinglun{
    [self showHudInView:self.view];
    page = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[info objectForKey:@"topicid"] forKey:@"topicid"];
    [parameters setValue:[NSNumber numberWithInt:page] forKey:@"page"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_TOPIC_REPLY_LIST];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHud];
        [_mytableview.mj_footer resetNoMoreData];
        [_mytableview.mj_header endRefreshing];
        NSLog(@"JSON: %@", operation.responseString);
        
        NSString *result = [NSString stringWithFormat:@"%@",[operation responseString]];
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == ResultCodeSuccess) {
                NSArray *arr = [dic objectForKey:@"message"];
                pinglunArr = [NSMutableArray arrayWithArray:arr];
                [self.mytableview reloadData];
                
            }else{
//                NSString *message = [dic objectForKey:@"message"];
//                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self hideHud];
        [_mytableview.mj_header endRefreshing];
        [self showHint:@"连接失败"];
    }];
}

-(void)loadPinglunMore{
    page++;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[info objectForKey:@"topicid"] forKey:@"topicid"];
    [parameters setValue:[NSNumber numberWithInt:page] forKey:@"page"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_TOPIC_REPLY_LIST];
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
                [_mytableview.mj_footer endRefreshing];
                NSArray *array = [dic objectForKey:@"message"];
                [pinglunArr addObjectsFromArray:array];
                [_mytableview reloadData];
            }else{
                if ([status intValue] == ResultCodeNoData) {
                    page--;
                    [_mytableview.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_mytableview.mj_footer endRefreshing];
                    NSString *message = [dic objectForKey:@"message"];
                    [self showHint:message];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [_mytableview.mj_footer endRefreshing];
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
}

-(void)hideKeyboard{
    [_mytextfield resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        CGFloat height = 570 - 18;
        
        NSString *content = [info objectForKey:@"content"];
        
        CGFloat contentWidth = Main_Screen_Width - 20;
        UIFont *font = [UIFont systemFontOfSize:15];
        CGSize textSize;
        if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
            textSize = [content boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT)
                                             options:options
                                          attributes:attributes
                                             context:nil].size;
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            textSize = [content sizeWithFont:font
                           constrainedToSize:CGSizeMake(contentWidth, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
            
        }
        
        if (zanArr != nil && zanArr.count > 0) {
            return height + textSize.height - 15;
        }else{
            return height + textSize.height - 62;
        }
    }else{
        
        CGFloat height = 26;
        
        NSDictionary *infoDic = [pinglunArr objectAtIndex:indexPath.row - 1];
        NSString *content = [infoDic objectForKey:@"content"];
        
        CGFloat contentWidth = Main_Screen_Width - 68 - 8;
        UIFont *font = [UIFont systemFontOfSize:15];
        CGSize textSize;
        if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
            textSize = [content boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT)
                                             options:options
                                          attributes:attributes
                                             context:nil].size;
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            textSize = [content sizeWithFont:font
                           constrainedToSize:CGSizeMake(contentWidth, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
            
        }
        
        
        if (textSize.height + height > 70) {
            return height + textSize.height;
        }else{
            return 70;
        }
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + pinglunArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        DongtaiDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dongtaiDetailcell"];
        NSString *avatar = [info objectForKey:@"avatar"];//头像
        NSString *user_name = [info objectForKey:@"user_name"];
        NSNumber *sex = [info objectForKey:@"sex"];
        NSString *content = [info objectForKey:@"content"];
        NSString *pic = [info objectForKey:@"pic"];
        
//        [cell.userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
        cell.userImage.layer.masksToBounds = YES;
        cell.userImage.layer.cornerRadius = 5;
        
        [cell.userImage yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholder:[UIImage imageNamed:@"gallery_default"] options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
//        [cell.userImage yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholder:[UIImage imageNamed:@"gallery_default"] options:YYWebImageOptionSetImageWithFadeAnimation progress:nil transform:^UIImage *(UIImage *image, NSURL *url) {
//            return [image yy_imageByRoundCornerRadius:5.0];
//        } completion:nil];
        
        
        cell.userImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserDetail3:)];
        [cell.userImage addGestureRecognizer:tap];
        
        cell.username.text = user_name;
        if ([sex intValue] == 0) {
            [cell.sexImage setHidden:NO];
            [cell.sexImage setImage:[UIImage imageNamed:@"usercell_girl"]];
            NSNumber *byear = [info objectForKey:@"byear"];
            NSNumber *bmonth = [info objectForKey:@"bmonth"];
            NSNumber *bday = [info objectForKey:@"bday"];
            NSDate *birthday = [NSDate dateWithYear:[byear integerValue] month:[bmonth integerValue] day:[bday integerValue]];
            NSInteger age = [NSDate ageWithDateOfBirth:birthday];
            cell.ageLabel.text = [NSString stringWithFormat:@"%ld",(long)age];
        }else if ([sex intValue] == 1){
            [cell.sexImage setHidden:NO];
            [cell.sexImage setImage:[UIImage imageNamed:@"usercell_boy"]];
            NSNumber *byear = [info objectForKey:@"byear"];
            NSNumber *bmonth = [info objectForKey:@"bmonth"];
            NSNumber *bday = [info objectForKey:@"bday"];
            NSDate *birthday = [NSDate dateWithYear:[byear integerValue] month:[bmonth integerValue] day:[bday integerValue]];
            NSInteger age = [NSDate ageWithDateOfBirth:birthday];
            cell.ageLabel.text = [NSString stringWithFormat:@"%ld",(long)age];
        }else{
            [cell.sexImage setHidden:YES];
        }
        cell.contentLabel.text = content;
        if (pic != nil && ![pic isEqualToString:@""]) {
//            [cell.bigImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,pic]]  placeholderImage:[UIImage imageNamed:@"dongtai_default"]];
            [cell.bigImage yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,pic]] options:YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation];
        }
        
        NSNumber *distance = [info objectForKey:@"distance"];
        NSString *dis = [NSString stringWithFormat:@"%.2fkm",[distance floatValue] / 1000];
        
        NSNumber *update_time = [info objectForKey:@"update_time"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[update_time doubleValue]];
        
        cell.otherLabel.text = [NSString stringWithFormat:@"%@|%@",dis,[confromTimesp timeAgo]];
        
        
        
        CGFloat contentWidth = Main_Screen_Width - 20;
        UIFont *font = [UIFont systemFontOfSize:15];
        CGSize textSize;
        if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
            textSize = [content boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT)
                                             options:options
                                          attributes:attributes
                                             context:nil].size;
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            textSize = [content sizeWithFont:font
                           constrainedToSize:CGSizeMake(contentWidth, MAXFLOAT)
                               lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
            
        }
        
        if (zanArr != nil && zanArr.count > 0) {
            [cell.bottomLabel setHidden:NO];
            
            if (zanScrollView == nil) {
                zanScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, cell.bottomLabel.frame.origin.y + 6 + textSize.height - 18, Main_Screen_Width, 35)];
                [cell.contentView addSubview:zanScrollView];
                
                int x = 10;
                CGFloat scrollviewWidth = 0;
                for (int i = 0 ; i < zanArr.count; i++) {
                    NSDictionary *user = [zanArr objectAtIndex:i];
                    NSString *avatar = [user objectForKey:@"avatar"];
                    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, 35, 35)];
                    [userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
                    userImage.layer.masksToBounds = YES;
                    userImage.layer.cornerRadius = 5;
                    userImage.tag = i;
                    userImage.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserDetail:)];
                    [userImage addGestureRecognizer:tap];
                    UIImageView *heartImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dongtailist_heart_full"]];
                    [heartImageView setFrame:CGRectMake(x + 28, 11, 14, 14)];
                    [zanScrollView addSubview:userImage];
                    [zanScrollView addSubview:heartImageView];
                    
                    scrollviewWidth = x+45;
                    x += 45;
                }
                zanScrollView.showsHorizontalScrollIndicator = false;
                [zanScrollView setContentSize:CGSizeMake(scrollviewWidth, 35)];
            }
        }else{
            [cell.bottomLabel setHidden:YES];
        }
        
        return cell;
    }else{
        PinglunTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"pingluncell"];
        
        NSDictionary *infoDic = [pinglunArr objectAtIndex:indexPath.row - 1];
//        NSString *userid = [infoDic objectForKey:@"id"];
        NSString *username = [infoDic objectForKey:@"user_name"];
        NSString *content = [infoDic objectForKey:@"content"];
        NSString *avatar = [infoDic objectForKey:@"avatar"];
        NSNumber *create_time = [info objectForKey:@"create_time"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[create_time doubleValue]];
        cell.nameLabel.text = username;
        cell.contentLabel.text = content;
//        [cell.userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
        
        [cell.userImage yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholder:[UIImage imageNamed:@"gallery_default"] options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
        
        cell.userImage.layer.masksToBounds = YES;
        cell.userImage.layer.cornerRadius = 5;
        cell.userImage.tag = indexPath.row - 1;
        cell.userImage.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserDetail2:)];
        [cell.userImage addGestureRecognizer:tap];
        
        
        
        cell.dateLabel.text = [confromTimesp dateWithFormat:@"yyyy-MM-dd hh:mm:ss"];
        return cell;
        
        
    }
    
}

#pragma mark - 
//从赞点击头像
-(void)showUserDetail:(UITapGestureRecognizer *)sender{
    
    NSDictionary *infoDic = [zanArr objectAtIndex:sender.view.tag];
    NSString *userid = [infoDic objectForKey:@"user_id"];
    [self showUserDetailByUserId:userid];
}
//从评论点击头像
-(void)showUserDetail2:(UITapGestureRecognizer *)sender{
    
    NSDictionary *infoDic = [pinglunArr objectAtIndex:sender.view.tag];
    NSString *userid = [infoDic objectForKey:@"user_id"];
    [self showUserDetailByUserId:userid];
}
//从内容点击头像
-(void)showUserDetail3:(UITapGestureRecognizer *)sender{
    
    NSString *userid = [info objectForKey:@"user_id"];
    [self showUserDetailByUserId:userid];
}
//进入用户详情界面
-(void)showUserDetailByUserId:(NSString *)userid{
    NSString *loginedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"];
    if ([userid isEqualToString:loginedUserId]) {
        MyInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
        vc.userid = userid;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        PlayerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
        vc.userid = userid;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark - 输入框

-(void)sendMess{
    [self hideKeyboard];
    
    if ([self.mytextfield.text isEqualToString:@""]) {
        [self showHint:@"请输入内容"];
        return;
    }
    
    [self showHudInView:self.view];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_mytextfield.text forKey:@"content"];
    [parameters setValue:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"]] forKey:@"userid"];
    [parameters setValue:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"user_name"]] forKey:@"username"];
    [parameters setValue:[info objectForKey:@"topicid"] forKey:@"topicid"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_INSERT_TOPIC_REPLY];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHud];
//        [_mytableview.mj_header endRefreshing];
//        [_mytableview.mj_footer resetNoMoreData];
        NSLog(@"JSON: %@", operation.responseString);
        
        NSString *result = [NSString stringWithFormat:@"%@",[operation responseString]];
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == ResultCodeSuccess) {
                
//                NSArray *array = [dic objectForKey:@"message"];
//                
//                [dataSource removeAllObjects];
//                [dataSource addObjectsFromArray:array];
//                [_mytableview reloadData];
                
                _mytextfield.text = @"";
                [self loadPinglun];
//                [_mytableview reloadData];
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

-(void)textFieldChanged:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        self.button.enabled = NO;
    }else{
        self.button.enabled = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

//显示键盘
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = _keyboardBackview.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    _keyboardBackview.frame = containerFrame;
    
    
    // commit animations
    [UIView commitAnimations];
}
//隐藏键盘
-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = _keyboardBackview.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    _keyboardBackview.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}

@end
