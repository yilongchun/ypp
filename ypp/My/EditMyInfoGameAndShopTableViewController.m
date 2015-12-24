//
//  EditMyInfoGameAndShopTableViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/11.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "EditMyInfoGameAndShopTableViewController.h"
#import "NSObject+Blocks.h"

@interface EditMyInfoGameAndShopTableViewController (){
    NSMutableArray *dataSource;
    NSMutableArray *selectedArray;
}

@end

@implementation EditMyInfoGameAndShopTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(save)];
    [rightItem setTintColor:[UIColor whiteColor]];
     self.navigationItem.rightBarButtonItem = rightItem;
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    selectedArray = [NSMutableArray array];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    [self showHudInView:self.view];
    [self loadData];
}

-(void)save{
    DLog(@"%@",selectedArray);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER];
    [parameters setValue:[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"id"]] forKey:@"userid"];
    
    NSMutableArray *idArr = [NSMutableArray array];
    NSMutableArray *nameArr = [NSMutableArray array];
    
    for (NSDictionary *info in selectedArray) {
        NSString *ids = [info objectForKey:@"id"];
        NSString *name = [info objectForKey:@"name"];
        
        [idArr addObject:ids];
        [nameArr addObject:name];
    }
    
    if (self.type == 1) {//游戏
        
        if ([selectedArray count] == 0) {
            [self showHint:@"请选择游戏"];
            return;
        }
        
        [parameters setValue:[idArr componentsJoinedByString:@","] forKey:@"oftenplaygamesid"];
        [parameters setValue:[nameArr componentsJoinedByString:@","] forKey:@"oftenplaygames"];
    }else if (self.type == 2){//门店
        
        if ([selectedArray count] == 0) {
            [self showHint:@"请选择门店"];
            return;
        }
        [parameters setValue:[idArr componentsJoinedByString:@","] forKey:@"oftengotostoreid"];
        [parameters setValue:[nameArr componentsJoinedByString:@","] forKey:@"oftengotostore"];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSString *urlString;
    
    if (self.type == 1) {//游戏
        urlString = [NSString stringWithFormat:@"%@%@",HOST,API_OFTENPLAYGAMES];
    }else if (self.type == 2) {//门店
        urlString = [NSString stringWithFormat:@"%@%@",HOST,API_STORELIST];
    }else{
        return;
    }
    
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
                
                if (self.type == 1) {
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
                    
                }else if (self.type == 2){
                    NSArray *array = [dic objectForKey:@"message"];
                    dataSource = [NSMutableArray arrayWithArray:array];
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

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
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
    
    
   
    
    if (self.type == 1) {
        NSString *oftenplaygamesid = [_userinfo objectForKey:@"oftenplaygamesid"];
        if (![oftenplaygamesid isEqualToString:@""]) {
            NSArray *gameids = [oftenplaygamesid componentsSeparatedByString:NSLocalizedString(@",", nil)];
            if ([gameids containsObject:infoid]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                if (![selectedArray containsObject:info]) {
                    [selectedArray addObject:info];
                }
                DLog(@"%@ 包含 %@",gameids,infoid);
            }else{
                DLog(@"%@ 不包含 %@",gameids,infoid);
            }
        }
    }else if(self.type == 2){
        NSString *oftengotostoreid = [_userinfo objectForKey:@"oftengotostoreid"];
        if (![oftengotostoreid isEqualToString:@""]) {
            NSArray *storeids = [oftengotostoreid componentsSeparatedByString:NSLocalizedString(@",", nil)];
            if ([storeids containsObject:infoid]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                if (![selectedArray containsObject:info]) {
                    [selectedArray addObject:info];
                }
            }
        }
    }
    
    
    if ([selectedArray containsObject:info]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedArray addObject:info];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        [selectedArray removeObject:info];
    }
}


@end
