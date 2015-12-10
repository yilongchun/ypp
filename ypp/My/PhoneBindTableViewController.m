//
//  PhoneBindTableViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/7.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "PhoneBindTableViewController.h"
#import "UpdatePhoneViewController.h"

@interface PhoneBindTableViewController (){
    NSDictionary *user;
}

@end

@implementation PhoneBindTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"手机绑定";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refershPhone)
                                                 name:@"refershPhone" object:nil];
    
    UIImageView *logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(30, 10, Main_Screen_Width-30, 280)];
    [logoImageView setImage:[UIImage imageNamed:@"bind_phone"]];
    logoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    UIView *headview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 300)];
    [headview addSubview:logoImageView];
    self.tableView.tableHeaderView = headview;
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSString *mobile = [user objectForKey:@"mobile"];
    if (![mobile isEqualToString:@""] && mobile.length > 7) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@****%@",[mobile substringToIndex:3],[mobile substringFromIndex:7]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UpdatePhoneViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UpdatePhoneViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
