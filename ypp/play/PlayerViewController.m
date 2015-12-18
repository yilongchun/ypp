//
//  PlayerViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/14.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "PlayerViewController.h"
#import "Util.h"
#import "BirthdayViewController.h"
#import "NSDate+Addition.h"
#import "MyInfoTableViewCell2.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+TimeAgo.h"
#import "QianmingTableViewCell.h"
#import "PlayerDongtaiTableViewCell.h"
#import "PlayerTableViewCell4.h"
#import "DongtaiViewController.h"

@interface PlayerViewController (){
    NSDictionary *userinfo;
    UIButton *guanzhuBtn;
    UIButton *chatBtn;
    UIButton *yueBtn;
    
    NSDictionary *dongtaiDic;
}

@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    if ([self.mytableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mytableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mytableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mytableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.mytableview setTableFooterView:v];
    
    
    
    [self loadData];
    [self loadDongtai];
    [self loadGuanzhu];
}

-(void)loadData{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self showHudInView:self.view];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.userid forKey:@"userid"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_GETUSERINFO];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        [_mytableview.mj_header endRefreshing];
        [self hideHud];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        NSLog(@"JSON: %@", operation.responseString);
        
        NSString *result = [NSString stringWithFormat:@"%@",[operation responseString]];
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == ResultCodeSuccess) {
                userinfo = [[dic objectForKey:@"message"] cleanNull];
                NSString *username = [userinfo objectForKey:@"user_name"];
                self.title = username;
                [_mytableview reloadData];
                [self addImages];
                
                
            }else{
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        //        [_mytableview.mj_header endRefreshing];
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
}
//添加头部图片
-(void)addImages{
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    MyInfoTableViewCell2 *cell = [_mytableview cellForRowAtIndexPath:indexpath];
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]] && view.tag != 999) {
            [view removeFromSuperview];
        }
    }
    
    NSString *imgs = [userinfo objectForKey:@"imgs"];
    CGFloat x = 8;
    CGFloat width = (Main_Screen_Width - 40) / 4;
    if (![imgs isEqualToString:@""]) {
        NSArray *imageArr =[imgs componentsSeparatedByString:NSLocalizedString(@",", nil)];
        
        for (int i = 0; i < [imageArr count]; i++) {
            
            UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(x, 10, width, width)];
            [imageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HOST,PIC_PATH,[imageArr objectAtIndex:i]]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
            imageview.layer.masksToBounds = YES;
            imageview.layer.cornerRadius = 5.0;
            [cell.contentView addSubview:imageview];
            x += width + 8;
        }
    }
}
//添加底部按钮
-(void)addBottomBtn:(BOOL)flag{
    
    if (guanzhuBtn != nil) {
        [guanzhuBtn removeFromSuperview];
    }
    if (chatBtn != nil) {
        [chatBtn removeFromSuperview];
    }
    if (yueBtn != nil) {
        [yueBtn removeFromSuperview];
    }
    
    CGFloat x = 0;
    CGFloat width = 60;
    if (flag) {//已关注
        width = 120;
    }else{//未关注
        guanzhuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [guanzhuBtn setFrame:CGRectMake(0, Main_Screen_Height - 50 - 64, 60, 50)];
        guanzhuBtn.layer.borderColor = RGBA(200,22,34,1).CGColor;
        guanzhuBtn.layer.borderWidth = 1;
        [guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
        guanzhuBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [guanzhuBtn setTitleColor:RGBA(200,22,34,1) forState:UIControlStateNormal];
        [guanzhuBtn setImage:[UIImage imageNamed:@"big_add"] forState:UIControlStateNormal];
        guanzhuBtn.imageEdgeInsets = UIEdgeInsetsMake(-15, 0, 0, -27);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
        guanzhuBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
        guanzhuBtn.titleEdgeInsets = UIEdgeInsetsMake(5, -25, -22, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
        [guanzhuBtn addTarget:self action:@selector(guanzhu) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:guanzhuBtn];
        x = 59;
    }
    
    chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chatBtn setFrame:CGRectMake(x, Main_Screen_Height - 50 - 64, width, 50)];
    chatBtn.layer.borderColor = RGBA(200,22,34,1).CGColor;
    chatBtn.layer.borderWidth = 1;
    [chatBtn setTitle:@"聊天" forState:UIControlStateNormal];
    chatBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [chatBtn setTitleColor:RGBA(200,22,34,1) forState:UIControlStateNormal];
    [chatBtn setImage:[UIImage imageNamed:@"chat"] forState:UIControlStateNormal];
    chatBtn.imageEdgeInsets = UIEdgeInsetsMake(-13, 0, 0, -25);//设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    chatBtn.titleLabel.textAlignment = NSTextAlignmentCenter;//设置title的字体居中
    chatBtn.titleEdgeInsets = UIEdgeInsetsMake(3, -25, -24, 0);//设置title在button上的位置（上top，左left，下bottom，右right）
    [self.view addSubview:chatBtn];
    
    yueBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [yueBtn setFrame:CGRectMake(118, Main_Screen_Height - 50 - 64, Main_Screen_Width - 118, 50)];
    yueBtn.layer.borderColor = RGBA(200,22,34,1).CGColor;
    yueBtn.layer.borderWidth = 1;
    [yueBtn setTitle:@"约TA" forState:UIControlStateNormal];
    yueBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [yueBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yueBtn setBackgroundColor:RGBA(200,22,34,1)];
    [self.view addSubview:yueBtn];
}
//加载最新一条动态
-(void)loadDongtai{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.userid forKey:@"userid"];
    [parameters setValue:[NSNumber numberWithInt:0] forKey:@"type"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_TOPICLIST_BY_USER];
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
                NSArray *arr = [dic objectForKey:@"message"];
                if ([arr count] > 0) {
                    dongtaiDic = [arr objectAtIndex:0];
                    NSIndexSet *sets = [NSIndexSet indexSetWithIndex:1];
                    [_mytableview reloadSections:sets withRowAnimation:UITableViewRowAnimationFade];
                }
            }else{
//                NSString *message = [dic objectForKey:@"message"];
//                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
}

//查询关注状态
-(void)loadGuanzhu{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"] forKey:@"fuserid"];
    [parameters setValue:self.userid forKey:@"fduserid"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_IS_FOCUSUSER];
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
                [self addBottomBtn:YES];
            }else{
                [self addBottomBtn:NO];
//                NSString *message = [dic objectForKey:@"message"];
//                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self showHint:@"连接失败"];
    }];
}

//关注用户
-(void)guanzhu{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"] forKey:@"fuserid"];
    [parameters setValue:[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"user_name"] forKey:@"fusername"];
    [parameters setValue:self.userid forKey:@"fduserid"];
    [parameters setValue:[userinfo objectForKey:@"user_name"] forKey:@"fdusername"];
    
    [self showHudInView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_FOCUSUSER];
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
                [self showHint:@"关注成功"];
                [self loadGuanzhu];
            }else{
//                NSString *message = [dic objectForKey:@"message"];
//                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        NSString *imgs = [userinfo objectForKey:@"imgs"];
        
        if (userinfo != nil && ![imgs isEqualToString:@""]) {
            CGFloat width = (Main_Screen_Width - 40) / 4;
            return 44 + width + 10;
        }else{
            return 44;
        }
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            CGFloat width = [UIScreen mainScreen].bounds.size.width - 90 - 15;
            NSString *content;
            NSString *defaultValue = @"未填写";
            
            NSString *signature = [userinfo objectForKey:@"signature"];
            content = [signature isEqualToString:@""] ? defaultValue : signature;//个性签名
            
            UIFont *font = [UIFont systemFontOfSize:15];
            CGSize leftTextSize;
            CGSize textSize;
            if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
                NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
                
                textSize = [content boundingRectWithSize:CGSizeMake(width - leftTextSize.width, MAXFLOAT)
                                                 options:options
                                              attributes:attributes
                                                 context:nil].size;
            }
            if (textSize.height + 12 +13 > 55) {
                return textSize.height + 12 + 13;
            }else{
                return 55;
            }
        }else if (indexPath.row == 1){
            return 148;
        }
    }
    
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        if (dongtaiDic == nil) {
            return 1;
        }
        return 2;
    }else if (section == 2) {
        return 4;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MyInfoTableViewCell2 *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        
        
        NSNumber *sex = [userinfo objectForKey:@"sex"];
        if (userinfo != nil && [sex intValue] == 0) {
            [cell2.sexImage setHidden:NO];
            [cell2.sexImage setImage:[UIImage imageNamed:@"usercell_girl"]];
            NSNumber *byear = [userinfo objectForKey:@"byear"];
            NSNumber *bmonth = [userinfo objectForKey:@"bmonth"];
            NSNumber *bday = [userinfo objectForKey:@"bday"];
            NSDate *birthday = [NSDate dateWithYear:[byear integerValue] month:[bmonth integerValue] day:[bday integerValue]];
            NSInteger age = [NSDate ageWithDateOfBirth:birthday];
            cell2.age.text = [NSString stringWithFormat:@"%ld",(long)age];
            
            NSString *astro = [Util getAstroWithMonth:[bmonth intValue] day:[bday intValue]];
            cell2.xingzuo.text = [NSString stringWithFormat:@"%@座",astro];;
        }else if (userinfo != nil && [sex intValue] == 1){
            [cell2.sexImage setHidden:NO];
            [cell2.sexImage setImage:[UIImage imageNamed:@"usercell_boy"]];
            NSNumber *byear = [userinfo objectForKey:@"byear"];
            NSNumber *bmonth = [userinfo objectForKey:@"bmonth"];
            NSNumber *bday = [userinfo objectForKey:@"bday"];
            NSDate *birthday = [NSDate dateWithYear:[byear integerValue] month:[bmonth integerValue] day:[bday integerValue]];
            NSInteger age = [NSDate ageWithDateOfBirth:birthday];
            cell2.age.text = [NSString stringWithFormat:@"%ld",(long)age];
            
            NSString *astro = [Util getAstroWithMonth:[bmonth intValue] day:[bday intValue]];
            cell2.xingzuo.text = [NSString stringWithFormat:@"%@座",astro];;
        }else{
            [cell2.sexImage setHidden:YES];
        }
        
        if (userinfo != nil) {
            NSNumber *distance = [userinfo objectForKey:@"distance"];
            NSString *dis = [NSString stringWithFormat:@"%.2fkm",[distance floatValue] / 1000];
            NSNumber *update_time = [userinfo objectForKey:@"update_time"];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[update_time doubleValue]];
            cell2.otherLabel.text = [NSString stringWithFormat:@"%@|%@",dis,[confromTimesp timeAgo]];
        }
        return cell2;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            QianmingTableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            NSString *signature = [userinfo objectForKey:@"signature"];
            if ([signature isEqualToString:@""]) {
                cell1.contentLabel.text = @"未填写";
            }else{
                cell1.contentLabel.text = signature;
            }
            cell1.contentLabel.numberOfLines = 0;
            cell1.contentLabel.textAlignment = NSTextAlignmentLeft;
            
            return cell1;
        }else if (indexPath.row == 1){
            PlayerDongtaiTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
            cell3.userImg.layer.masksToBounds = YES;
            cell3.userImg.layer.cornerRadius = 5;
            
            
            NSString *topic_count = [userinfo objectForKey:@"topic_count"];
            cell3.numLabel.text = topic_count;
            
            NSString *content = [dongtaiDic objectForKey:@"content"];
            
            NSString *pic = [dongtaiDic objectForKey:@"pic"];
            
            [cell3.userImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HOST,PIC_PATH,pic]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
            cell3.contentLabel.text = content;
            
            NSNumber *create_time = [dongtaiDic objectForKey:@"create_time"];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[create_time doubleValue]];
            cell3.otherLabel.text = [NSString stringWithFormat:@"%@",[confromTimesp timeAgo]];

            
            
            return cell3;
        }
    }
    if (indexPath.section == 2) {
        PlayerTableViewCell4 *cell4 = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
        
        switch (indexPath.row) {
            case 0:{
                cell4.leftLabel.text = @"行业";
                NSString *industry = [userinfo objectForKey:@"industry"];
                cell4.rightLabel.text = industry;
            }
                break;
            case 1:{
                cell4.leftLabel.text = @"公司";
                NSString *company = [userinfo objectForKey:@"company"];
                cell4.rightLabel.text = company;
            }
                break;
            case 2:{
                cell4.leftLabel.text = @"学校";
                NSString *school = [userinfo objectForKey:@"school"];
                cell4.rightLabel.text = school;
            }
                break;
            case 3:{
                cell4.leftLabel.text = @"城市";
                NSString *city = [userinfo objectForKey:@"city"];
                cell4.rightLabel.text = city;
            }
            default:
                break;
        }
        return cell4;
        
        
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            
            DongtaiViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DongtaiViewController"];
            vc.title = self.title;
            vc.type = @"5";
            vc.dongtaiUserId = [userinfo objectForKey:@"id"];
            [self.navigationController pushViewController:vc animated:YES];
        }
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

@end
