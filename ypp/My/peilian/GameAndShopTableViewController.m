//
//  GameAndShopTableViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/17.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "GameAndShopTableViewController.h"

@interface GameAndShopTableViewController (){
    NSMutableArray *dataSource;
    
    NSIndexPath *selectedIndexPath;
}

@end

@implementation GameAndShopTableViewController

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
    if (self.type == 1) {//游戏
        if (selectedIndexPath == nil) {
            [self showHint:@"请选择游戏"];
            return;
        }
    }else if (self.type == 2){//门店
        if (selectedIndexPath == nil) {
            [self showHint:@"请选择门店"];
            return;
        }
    }else if (self.type == 3){//游戏区
        if (selectedIndexPath == nil) {
            [self showHint:@"请选择游戏区"];
            return;
        }
    }
    
    NSDictionary *dic = [dataSource objectAtIndex:selectedIndexPath.row];
    DLog(@"%@",dic);
    
    NSString *dicId = [dic objectForKey:@"id"];
    NSString *dicName = [dic objectForKey:@"name"];
    
    _columnIdValue = dicId;
    _columnValue = dicName;
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:_columnId,@"column",_columnIdValue,@"columnValue", nil];
    NSNotification *notification =[NSNotification notificationWithName:@"setValue" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    NSDictionary *dict2 =[[NSDictionary alloc] initWithObjectsAndKeys:_column,@"column",_columnValue,@"columnValue", nil];
    NSNotification *notification2 =[NSNotification notificationWithName:@"setValue" object:nil userInfo:dict2];
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

-(void)loadData{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSString *urlString;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    if (self.type == 1) {//游戏
        urlString = [NSString stringWithFormat:@"%@%@",HOST,API_OFTENPLAYGAMES];
    }else if (self.type == 2) {//门店
        urlString = [NSString stringWithFormat:@"%@%@",HOST,API_STORELIST];
    }else if (self.type == 3) {//游戏区
        urlString = [NSString stringWithFormat:@"%@%@",HOST,API_GAMEAREAS_BY_ID];
        [parameters setValue:_gameid forKey:@"gameid"];
    }else{
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
                
                if (self.type == 1 || self.type == 3) {
                    
                    
                    
                    NSDictionary *message = [dic objectForKey:@"message"];
                    dataSource = [NSMutableArray array];
                    
                    if ([message isKindOfClass:[NSDictionary class]]) {
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
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    NSString *name = [info objectForKey:@"name"];
    cell.textLabel.text = name;
    
    
    NSString *infoid = [info objectForKey:@"id"];
    
    
    
    
    if (self.type == 1 || self.type == 3) {
        
        if (![_columnIdValue isEqualToString:@""]) {
            if ([_columnIdValue isEqualToString:infoid]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                selectedIndexPath = indexPath;
            }else{
            }
        }
    }else if(self.type == 2){
        if (![_columnIdValue isEqualToString:@""]) {
            if ([_columnIdValue isEqualToString:infoid]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                selectedIndexPath = indexPath;
            }else{
            }
        }
    }
    
    
    if (selectedIndexPath == indexPath) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (selectedIndexPath != nil) {
        UITableViewCell *oldcell = [tableView cellForRowAtIndexPath:selectedIndexPath];
        oldcell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectedIndexPath = indexPath;
    }
}

@end
