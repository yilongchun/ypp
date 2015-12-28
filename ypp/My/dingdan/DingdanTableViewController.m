//
//  DingdanTableViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/25.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "DingdanTableViewController.h"
#import "DingdanTableViewCell.h"
#import "NSDate+Extension.h"
#import "DingdanDetailTableViewController.h"
#import "ChooseDashenViewController.h"

@interface DingdanTableViewController (){
    NSMutableArray *dataSource;
    int page;
}

@end

@implementation DingdanTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    
    //    [self.mytableview registerClass:[UserTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadData)
                                                 name:@"loadDingdanData" object:nil];
    
    [self showHudInView:self.view];
    [self loadData];
}

-(void)loadData{
    page = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSNumber numberWithInt:page] forKey:@"page"];
    [parameters setValue:_type forKey:@"type"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_ORDER_LIST];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
        NSLog(@"JSON: %@", operation.responseString);
        
        NSString *result = [NSString stringWithFormat:@"%@",[operation responseString]];
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == ResultCodeSuccess) {
                
                NSArray *array = [dic objectForKey:@"message"];
                dataSource = [NSMutableArray arrayWithArray:array];
                [self.tableView reloadData];
                
            }else{
//                NSString *message = [dic objectForKey:@"message"];
                dataSource = nil;
                [self.tableView reloadData];
//                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self.tableView.mj_header endRefreshing];
        [self hideHud];
        [self showHint:@"连接失败"];
        
    }];
}

-(void)loadMore{
    page++;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSNumber numberWithInt:page] forKey:@"page"];
    [parameters setValue:_type forKey:@"type"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_ORDER_LIST];
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
                [self.tableView.mj_footer endRefreshing];
                NSArray *array = [dic objectForKey:@"message"];
                [dataSource addObjectsFromArray:array];
                [self.tableView reloadData];
            }else{
                if ([status intValue] == ResultCodeNoData) {
                    page--;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [self.tableView.mj_footer endRefreshing];
                    NSString *message = [dic objectForKey:@"message"];
                    [self showHint:message];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self.tableView.mj_footer endRefreshing];
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
    return 70;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    DingdanTableViewCell *cell = (DingdanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell= (DingdanTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"DingdanTableViewCell" owner:self options:nil]  lastObject];
    }
    NSDictionary *info = [[dataSource objectAtIndex:indexPath.row] cleanNull];
    NSString *storename = [info objectForKey:@"storename"];
    NSString *begin = [info objectForKey:@"begin"];//2015-12-26 12:00
    NSString *hours = [info objectForKey:@"hours"];
    NSString *isline = [info objectForKey:@"isline"];
    
    NSDate *beginDate = [NSDate dateWithString:begin format:@"yyyy-MM-dd hh:mm"];
    NSDate *endDate = [beginDate offsetHours:[hours intValue]];
    cell.beginDate.text = [NSString stringWithFormat:@"%@ %@~%@",[beginDate stringWithFormat:@"MM月dd日"],[beginDate stringWithFormat:@"hh:mm"],[endDate stringWithFormat:@"hh:mm"]];
    cell.address.text = storename;
    
    if ([isline isEqualToString:@"1"]) {//线上
        cell.isLine.text = @"线上";
    }else{//线下
        cell.isLine.text = @"线下";
    }
    
    DLog(@"%@",info);
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *info = [[dataSource objectAtIndex:indexPath.row] cleanNull];
    
    NSString *yuestatus = [info objectForKey:@"yuestatus"];
    
    if ([yuestatus isEqualToString:@"0"]) {//待选择
        ChooseDashenViewController *vc = [[ChooseDashenViewController alloc] init];
        vc.dingdanInfo = info;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([yuestatus isEqualToString:@"1"]) {//已完成
        
    }
    if ([yuestatus isEqualToString:@"2"]) {//已取消
        DingdanDetailTableViewController *vc = [[DingdanDetailTableViewController alloc] init];
        vc.info = info;
        [self.navigationController pushViewController:vc animated:YES];
    }
    

    
}

@end
