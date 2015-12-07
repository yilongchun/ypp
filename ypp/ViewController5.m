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
#import "UIImageView+AFNetworking.h"
#import "AccountTableViewController.h"
#import "MyInfoViewController.h"

@interface ViewController5 (){
    NSDictionary *userinfo;
}

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
    
    
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"签到" style:UIBarButtonItemStylePlain target:self action:@selector(qiandao)];
    [leftItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    userinfo = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] cleanNull];
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
        return 100;
    }
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 2;
    }else if(section == 3){
        return 3;
    }else{
        return 1;
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
        cell2.usernameLabel.text = user_name;
        
        [cell2.userImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,avatar]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
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
                MymoneyTableViewCell *cell3 = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
                
                NSNumber *money = [userinfo objectForKey:@"money"];
                cell3.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[money floatValue]];
                cell3.scoreLabel.text = [userinfo objectForKey:@"score"];
                return cell3;
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
                cell.textLabel.text = @"申请游神";
                cell.imageView.image = [UIImage imageNamed:@"sGod"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }else{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
                cell.textLabel.text = @"即时占座";
                cell.imageView.image = [UIImage imageNamed:@"zhanzuo"];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                return cell;
            }
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            cell.textLabel.text = @"设置";
            cell.imageView.image = [UIImage imageNamed:@"shezhi"];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }
        
        
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        MyInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if (indexPath.section == 1) {
        AccountTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountTableViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.title = @"账号绑定";
        [self.navigationController pushViewController:vc animated:YES];
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

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    //去除导航栏下方的横线
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc]init]];
//    self.navigationController.navigationBar.translucent = NO;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
            if ([status intValue] == 200) {
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

@end
