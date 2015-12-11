//
//  MyInfoViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/7.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "MyInfoViewController.h"
#import "EditMyInfoViewController.h"
#import "Util.h"
#import "BirthdayViewController.h"
#import "NSDate+Addition.h"
#import "MyInfoTableViewCell2.h"
#import "UIImageView+AFNetworking.h"

@interface MyInfoViewController (){
    NSDictionary *userinfo;
}

@end

@implementation MyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadUser)
                                                 name:@"loadUser" object:nil];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(edit)];
    [rightItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        //        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
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
    
//    _mytableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        [self loadUser];
//    }];
    
    [self loadUser];
}

-(void)loadUser{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self showHudInView:self.view];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"]] forKey:@"userid"];
    
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
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGINED_USER];
                [[NSUserDefaults standardUserDefaults] setObject:userinfo forKey:LOGINED_USER];
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

-(void)edit{
    EditMyInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditMyInfoViewController"];
    vc.userinfo = userinfo;
    [self.navigationController pushViewController:vc animated:YES];
}

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
        if (indexPath.row == 0 || indexPath.row == 5 || indexPath.row == 6) {
            CGFloat width = [UIScreen mainScreen].bounds.size.width - 15 - 10 - 33;
            NSString *content;
            NSString *defaultValue = @"未填写";
            NSString *leftString;
            
            if (indexPath.row == 0) {
                leftString = @"个性签名";
                NSString *signature = [userinfo objectForKey:@"signature"];
                content = [signature isEqualToString:@""] ? defaultValue : signature;//个性签名
            }
            if (indexPath.row == 5) {
                leftString = @"常玩游戏";
                NSString *oftenplaygames = [userinfo objectForKey:@"oftenplaygames"];
                content = [oftenplaygames isEqualToString:@""] ? defaultValue : oftenplaygames;//常玩游戏
            }
            if (indexPath.row == 6) {
                leftString = @"常去门店";
                NSString *oftengotostore = [userinfo objectForKey:@"oftengotostore"];
                content = [oftengotostore isEqualToString:@""] ? defaultValue : oftengotostore;//常去门店
            }
            
            UIFont *font = [UIFont systemFontOfSize:16];
            CGSize leftTextSize;
            CGSize textSize;
            if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
                NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
                
                leftTextSize = [leftString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                                        options:options
                                                     attributes:attributes
                                                        context:nil].size;
                textSize = [content boundingRectWithSize:CGSizeMake(width - leftTextSize.width, MAXFLOAT)
                                                 options:options
                                              attributes:attributes
                                                 context:nil].size;
            }
            if (textSize.height + 17 +17 > 55) {
                return textSize.height + 17 + 17;
            }else{
                return 55;
            }
        }
    }
    
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 7;
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
        
        
        return cell2;
    }
    if (indexPath.section == 1) {
        UITableViewCell *cell1 = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        
        switch (indexPath.row) {
            case 0:{
                cell1.textLabel.text = @"个性签名";
                NSString *signature = [userinfo objectForKey:@"signature"];
                if ([signature isEqualToString:@""]) {
                    cell1.detailTextLabel.text = @"未填写";
                }else{
                    cell1.detailTextLabel.text = signature;
                }
                cell1.detailTextLabel.numberOfLines = 0;
                cell1.detailTextLabel.textAlignment = NSTextAlignmentLeft;
            }
                break;
            case 1:{
                cell1.textLabel.text = @"行业";
                NSString *industry = [userinfo objectForKey:@"industry"];
                if ([industry isEqualToString:@""]) {
                    cell1.detailTextLabel.text = @"未填写";
                }else{
                    cell1.detailTextLabel.text = industry;
                }
            }
                break;
            case 2:{
                cell1.textLabel.text = @"公司";
                NSString *company = [userinfo objectForKey:@"company"];
                if ([company isEqualToString:@""]) {
                    cell1.detailTextLabel.text = @"未填写";
                }else{
                    cell1.detailTextLabel.text = company;
                }
            }
                break;
            case 3:{
                cell1.textLabel.text = @"学校";
                NSString *school = [userinfo objectForKey:@"school"];
                if ([school isEqualToString:@""]) {
                    cell1.detailTextLabel.text = @"未填写";
                }else{
                    cell1.detailTextLabel.text = school;
                }
            }
                break;
            case 4:{
                cell1.textLabel.text = @"城市";
                NSString *city = [userinfo objectForKey:@"city"];
                if ([city isEqualToString:@""]) {
                    cell1.detailTextLabel.text = @"未填写";
                }else{
                    cell1.detailTextLabel.text = city;
                }
            }
                break;
            case 5:{
                cell1.textLabel.text = @"常玩游戏";
                NSString *oftenplaygames = [userinfo objectForKey:@"oftenplaygames"];
                if ([oftenplaygames isEqualToString:@""]) {
                    cell1.detailTextLabel.text = @"未填写";
                }else{
                    cell1.detailTextLabel.text = oftenplaygames;
                }
                cell1.detailTextLabel.numberOfLines = 0;
                cell1.detailTextLabel.textAlignment = NSTextAlignmentLeft;
            }
                break;
            case 6:{
                cell1.textLabel.text = @"常去门店";
                NSString *oftengotostore = [userinfo objectForKey:@"oftengotostore"];
                if ([oftengotostore isEqualToString:@""]) {
                    cell1.detailTextLabel.text = @"未填写";
                }else{
                    cell1.detailTextLabel.text = oftengotostore;
                }
                cell1.detailTextLabel.numberOfLines = 0;
                cell1.detailTextLabel.textAlignment = NSTextAlignmentLeft;
            }
                break;
            default:
                break;
        }
        return cell1;
    }
    return nil;
    
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
