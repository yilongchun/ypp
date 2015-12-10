//
//  UserStatusTableViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/10.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "UserStatusTableViewController.h"

@interface UserStatusTableViewController (){
    NSDictionary *userinfo;
}

@end

@implementation UserStatusTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"隐身模式";
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    [self loadUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadUser{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"]] forKey:@"userid"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_GETUSERINFO];
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
            if ([status intValue] == 200) {
                userinfo = [[dic objectForKey:@"message"] cleanNull];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:LOGINED_USER];
                [[NSUserDefaults standardUserDefaults] setObject:userinfo forKey:LOGINED_USER];
                [self.tableView reloadData];
            }else{
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self showHint:@"连接失败"];
    }];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        [cell.detailTextLabel setTextColor:[UIColor darkGrayColor]];
    }
    
    NSString *status = [userinfo objectForKey:@"status"];
    
    switch (indexPath.row) {
        case 0:{
            cell.textLabel.text = @"对所有人可见";
            [cell.textLabel setTextColor:RGB(98, 194, 237)];
            cell.detailTextLabel.text = @"对所有人显示距离";
            if (status != nil && [status intValue] == 0) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
            break;
        case 1:{
            cell.textLabel.text = @"对好友可见";
            [cell.textLabel setTextColor:RGB(241, 175, 97)];
            cell.detailTextLabel.text = @"不出现在附近列表，减少陌生人消息";
            if (status != nil && [status intValue] == 1) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
            break;
        case 2:{
            cell.textLabel.text = @"对所有人隐身";
            cell.detailTextLabel.text = @"隐身模式，关闭距离";
            if (status != nil && [status intValue] == 2) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
        }
            break;
        default:
            break;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *status = [userinfo objectForKey:@"status"];
    
    if (indexPath.row == 0) {
        if (status != nil && [status intValue] != 0) {
            [self setStatus:@"0"];
        }
    }
    if (indexPath.row == 1) {
        if (status != nil && [status intValue] != 1) {
            [self setStatus:@"1"];
        }
    }
    if (indexPath.row == 2) {
        if (status != nil && [status intValue] != 2) {
            [self setStatus:@"2"];
        }
    }
}

-(void)setStatus:(NSString *)status{
    
    [self showHudInView:self.view];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"]] forKey:@"userid"];
    [parameters setValue:status forKey:@"status"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_UPDATESTATUS];
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
                [self loadUser];
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

@end
