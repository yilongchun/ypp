//
//  ViewController5.m
//  ypp
//
//  Created by haidony on 15/11/4.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "ViewController5.h"
#import "MyInfoTableViewCell.h"
#import "MymoneyTableViewCell.h"
#import "MymoneyTableViewCell2.h"
#import "UIImageView+AFNetworking.h"
#import "AccountTableViewController.h"
#import "MyInfoViewController.h"
#import "SettingTableViewController.h"
#import "EditMyInfoViewController.h"
#import "XieyiViewController.h"
#import "HelpViewController.h"
#import "ApplyResultViewController.h"
#import "YouhuiListViewController.h"

@interface ViewController5 (){
    NSDictionary *userinfo;
}

@property int lastPosition;

@end

@implementation ViewController5

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        //        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
//    self.navigationController.hidesBarsOnSwipe = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadUser:)
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
    
//    self.mytableview.contentInset = UIEdgeInsetsMake(-1, 0, 0, 0);
    
    _mytableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadUser:nil];
    }];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"签到" style:UIBarButtonItemStylePlain target:self action:@selector(qiandao)];
    [leftItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    userinfo = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] cleanNull];
    
    [self loadUser:nil];
}

-(void)loadUser:(NSNotification *)text{
    
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
            if ([status intValue] == ResultCodeSuccess) {
                userinfo = [[dic objectForKey:@"message"] cleanNull];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGINED_USER];
                [[NSUserDefaults standardUserDefaults] setObject:userinfo forKey:LOGINED_USER];
                [_mytableview reloadData];
                
                if ([text.userInfo[@"refershPhone"] isEqualToString:@"refershPhone"]) {
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"refershPhone" object:nil];
                }
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

#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section == 2) {
        return 2;
    }else if(section == 3){
        return 3;
    }else{
        return 2;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        MyInfoTableViewCell *cell2 = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        cell2.userImg.layer.masksToBounds = YES;
        cell2.userImg.layer.borderWidth = 1.5;
        cell2.userImg.layer.borderColor = [UIColor whiteColor].CGColor;
        cell2.userImg.layer.cornerRadius = 5.0;
        
        NSString *user_name = [userinfo objectForKey:@"user_name"];
        NSString *avatar = [userinfo objectForKey:@"avatar"];
        NSString *signature = [userinfo objectForKey:@"signature"];
        cell2.usernameLabel.text = user_name;
        cell2.userqianmingLabel.text = signature;
        [cell2.userImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HOST,PIC_PATH,avatar]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
        return cell2;
        
    }else{
        if (indexPath.section == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            
            cell.textLabel.text = @"账号绑定";
            cell.detailTextLabel.text = @"手机号、会员卡";
            cell.imageView.image = [UIImage imageNamed:@"zhanghao"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else if(indexPath.section == 2){
            if (indexPath.row == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.textLabel.text = @"我的钱包";
                cell.detailTextLabel.text = @"全部";
                cell.imageView.image = [UIImage imageNamed:@"mywallet"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }else{
                UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showYouhui)];
                UITapGestureRecognizer *tap3_2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showYouhui)];
                
                
                NSString *is_daren = [userinfo objectForKey:@"is_daren"];//0默认 1审核中 2通过 3不通过
                if ([is_daren isEqualToString:@"2"]) {//审核通过
                    MymoneyTableViewCell2 *cell4 = [tableView dequeueReusableCellWithIdentifier:@"cell4"];
                    NSNumber *money = [userinfo objectForKey:@"money"];
                    cell4.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[money floatValue]];
                    cell4.scoreLabel.text = [userinfo objectForKey:@"score"];
                    
                    cell4.moneyLabel.userInteractionEnabled = YES;
                    cell4.moneyLabel2.userInteractionEnabled = YES;
                    cell4.scoreLabel.userInteractionEnabled = YES;
                    cell4.scoreLabel2.userInteractionEnabled = YES;
                    cell4.youhuiquanLabel.userInteractionEnabled = YES;
                    cell4.youhuiquanLabel2.userInteractionEnabled = YES;
                    cell4.peilianLabel.userInteractionEnabled = YES;
                    cell4.peilianLabel2.userInteractionEnabled = YES;
                    
                    
                    [cell4.youhuiquanLabel addGestureRecognizer:tap3];
                    [cell4.youhuiquanLabel2 addGestureRecognizer:tap3_2];
                    
                    return cell4;
                }else{
                    MymoneyTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
                    NSNumber *money = [userinfo objectForKey:@"money"];
                    cell3.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[money floatValue]];
                    cell3.scoreLabel.text = [userinfo objectForKey:@"score"];
                    
                    cell3.moneyLabel.userInteractionEnabled = YES;
                    cell3.moneyLabel2.userInteractionEnabled = YES;
                    cell3.scoreLabel.userInteractionEnabled = YES;
                    cell3.scoreLabel2.userInteractionEnabled = YES;
                    cell3.youhuiquanLabel.userInteractionEnabled = YES;
                    cell3.youhuiquanLabel2.userInteractionEnabled = YES;
                    
                    
                    [cell3.youhuiquanLabel addGestureRecognizer:tap3];
                    [cell3.youhuiquanLabel2 addGestureRecognizer:tap3_2];
                    
                    return cell3;
                }
            }
        }else if(indexPath.section == 3){
            if (indexPath.row == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.textLabel.text = @"订单中心";
                cell.imageView.image = [UIImage imageNamed:@"xiaofei"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }else if(indexPath.row == 1){
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                
                cell.imageView.image = [UIImage imageNamed:@"sGod"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                
                NSString *is_daren = [userinfo objectForKey:@"is_daren"];//0默认 1审核中 2通过 3不通过
                if ([is_daren isEqualToString:@"2"]) {//审核通过
                    cell.textLabel.text = @"我是陪练";
                }else{
                    cell.textLabel.text = @"申请陪练";
                }
                
                
                return cell;
            }else{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.textLabel.text = @"即时占座";
                cell.imageView.image = [UIImage imageNamed:@"zhanzuo"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
        }else{
            if (indexPath.row == 0) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.textLabel.text = @"设置";
                cell.imageView.image = [UIImage imageNamed:@"shezhi"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }else{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.textLabel.text = @"帮助";
                cell.imageView.image = [UIImage imageNamed:@"bangzhu"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
            
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        MyInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.userid = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"];
        [self.navigationController pushViewController:vc animated:YES];
        
//        EditMyInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"EditMyInfoViewController"];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        AccountTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountTableViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = @"账号绑定";
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 1) {
            
            NSString *is_daren = [userinfo objectForKey:@"is_daren"];//0默认 1审核中 2通过 3不通过
            
            if ([is_daren isEqualToString:@"0"]) {
                XieyiViewController *vc = [[XieyiViewController alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([is_daren isEqualToString:@"1"]) {//审核中
                DLog(@"审核中");
                ApplyResultViewController *vc = [[ApplyResultViewController alloc] init];
                vc.title = @"申请陪练";
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if ([is_daren isEqualToString:@"2"]) {//审核通过
                DLog(@"审核通过");
            }
            if ([is_daren isEqualToString:@"3"]) {//审核不通过
                
            }
        }
    }
    if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            SettingTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingTableViewController"];
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = @"设置";
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            HelpViewController *vc = [[HelpViewController alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.title = @"用户帮助";
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

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //去除导航栏下方的横线
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
    self.navigationController.navigationBar.translucent = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    int currentPostion = scrollView.contentOffset.y;
//    if (currentPostion - _lastPosition > 20  && currentPostion > 0) {        //这个地方加上 currentPostion > 0 即可）
//        _lastPosition = currentPostion;
//        NSLog(@"ScrollUp now");
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//    }
//    else if ((_lastPosition - currentPostion > 20) && (currentPostion  <= scrollView.contentSize.height-scrollView.bounds.size.height-20) ) //这个地方加上后边那个即可，也不知道为什么，再减20才行
//    {
//        _lastPosition = currentPostion;
//        NSLog(@"ScrollDown now");
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        
//    }
//}

#pragma mark -

-(void)qiandao{
    NSLog(@"签到");
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[userinfo objectForKey:@"id"] forKey:@"userid"];
    
    [self showHudInView:self.view];
    NSString *str = [NSString stringWithFormat:@"%@%@",HOST,API_SIGNIN];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:str parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHud];
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"签到%@",result);
        
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == ResultCodeSuccess) {
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
                
                
            }else{
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [self hideHud];
        [self showHint:error.description];
    }];
}

/**
 *  查看优惠劵
 */
-(void)showYouhui{
    YouhuiListViewController *vc = [[YouhuiListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
