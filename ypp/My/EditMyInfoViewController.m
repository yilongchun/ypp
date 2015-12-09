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

@interface EditMyInfoViewController (){
    NSDictionary *userinfo;
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
    
    userinfo = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] cleanNull];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
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
                cell2.detailTextLabel.text = @"未填写";
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
                cell2.detailTextLabel.text = @"未填写";
            }
                break;
            case 6:{
                cell2.textLabel.text = @"行业";
                cell2.detailTextLabel.text = @"未填写";
            }
                break;
            case 7:{
                cell2.textLabel.text = @"公司";
                cell2.detailTextLabel.text = @"未填写";
            }
                break;
            case 8:{
                cell2.textLabel.text = @"学校";
                cell2.detailTextLabel.text = @"未填写";
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


@end
