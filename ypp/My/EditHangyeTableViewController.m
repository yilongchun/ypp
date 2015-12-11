//
//  EditHangyeTableViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/11.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "EditHangyeTableViewController.h"
#import "NSObject+Blocks.h"

@interface EditHangyeTableViewController (){
    NSMutableArray *dataSource;
    NSDictionary *selectedInfo;
    NSIndexPath *oldIndexPath;
}

@end

@implementation EditHangyeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    [rightItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    
    
    [self showHudInView:self.view];
    [self loadData];
}

-(void)save{
    
    if (selectedInfo == nil) {
        [self showHint:@"请选择行业"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER];
    [parameters setValue:[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"id"]] forKey:@"userid"];
    [parameters setValue:[selectedInfo objectForKey:@"id"] forKey:@"industryid"];
    [parameters setValue:[selectedInfo objectForKey:@"name"] forKey:@"industry"];
    
    [self showHudInView:self.view];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_UPDATEUSER];
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
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
                [self performBlock:^{
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:@"loadUser" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                } afterDelay:1.5];
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

-(void)loadData{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_HANGYE];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.mj_header endRefreshing];
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
                NSDictionary *message = [dic objectForKey:@"message"];
                dataSource = [NSMutableArray array];
                
                NSArray *keys;
                int i, count;
                id key, value;
                
                keys = [message allKeys];
                count = (int)[keys count];
                for (i = 0; i < count; i++)
                {
                    key = [keys objectAtIndex: i];
                    value = [message objectForKey: key];
                    NSLog (@"Key: %@ for value: %@", key, value);
                    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:key,@"id",value,@"name", nil];
                    [dataSource addObject:info];
                    
                }
                [self.tableView reloadData];
            }else{
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self.tableView.mj_header endRefreshing];
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
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
    return [dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    NSString *name = [info objectForKey:@"name"];
    cell.textLabel.text = name;
    
    NSString *infoid = [info objectForKey:@"id"];
    NSString *industryid = [_userinfo objectForKey:@"industryid"];
    
    if (info == selectedInfo || [infoid isEqualToString:industryid]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        oldIndexPath = indexPath;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (oldIndexPath != nil) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:oldIndexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    oldIndexPath = indexPath;
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    selectedInfo = info;
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    if (cell.accessoryType == UITableViewCellAccessoryNone) {
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        [selectedArray addObject:info];
//    }else{
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        [selectedArray removeObject:info];
//    }
}

@end
