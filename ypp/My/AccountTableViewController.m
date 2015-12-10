//
//  AccountTableViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/7.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "AccountTableViewController.h"
#import "PhoneBindTableViewController.h"
#import "AccountBindViewController.h"

@interface AccountTableViewController (){
    NSDictionary *user;
}

@end

@implementation AccountTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refershPhone)
                                                 name:@"refershPhone" object:nil];
    
    user = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER];
    
}

-(void)refershPhone{
    user = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"手机号";
        NSString *mobile = [user objectForKey:@"mobile"];
        if (![mobile isEqualToString:@""] && mobile.length > 7) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@****%@",[mobile substringToIndex:3],[mobile substringFromIndex:7]];
        }else{
            cell.detailTextLabel.text = @"未绑定";
        }
        
    }else{
        cell.textLabel.text = @"会员卡";
        
        NSString *membershipcardnumber = [user objectForKey:@"membershipcardnumber"];
        if (membershipcardnumber == nil || [membershipcardnumber isEqualToString:@""]) {
            cell.detailTextLabel.text = @"未绑定";
        }else{
            cell.detailTextLabel.text = membershipcardnumber;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        PhoneBindTableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PhoneBindTableViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        AccountBindViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountBindViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
