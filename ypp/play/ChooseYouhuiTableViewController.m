//
//  ChooseYouhuiTableViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/24.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "ChooseYouhuiTableViewController.h"
#import "YouhuijuanTableViewCell.h"
#import "NSDate+Addition.h"

@interface ChooseYouhuiTableViewController (){
    NSMutableArray *dataSource;
    int page;
}

@end

@implementation ChooseYouhuiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的优惠劵";
    
    dataSource = [NSMutableArray array];
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
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:v];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"不使用" style:UIBarButtonItemStyleDone target:self action:@selector(nouse)];
    [rightItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self.tableView.mj_header beginRefreshing];
}

//不使用优惠劵
-(void)nouse{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setYouhuiInfo" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData{
    page = 1;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_YOUHUI_LIST];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"]] forKey:@"userid"];
    [parameters setValue:@"0" forKey:@"type"];//type（0 可用的,1历史所有并分页）
    [parameters setValue:[NSNumber numberWithInt:page] forKey:@"page"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer resetNoMoreData];
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
                
                NSArray *message = [dic objectForKey:@"message"];
                if ([message count] > 0) {
                    dataSource = [NSMutableArray arrayWithArray:message];
                    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [self loadMore];
                    }];
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
        [self.tableView.mj_footer resetNoMoreData];
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
}

-(void)loadMore{
    page++;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"]] forKey:@"userid"];
    [parameters setValue:@"0" forKey:@"type"];//type（0 可用的,1历史所有并分页）
    [parameters setValue:[NSNumber numberWithInt:page] forKey:@"page"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_YOUHUI_LIST];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHud];
        [self.tableView.mj_footer endRefreshing];
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
                [dataSource addObjectsFromArray:array];
                [self.tableView reloadData];
            }else{
                if ([status intValue] == ResultCodeNoData) {
                    page--;
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }else{
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

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        
    static NSString *CellIdentifier = @"youhuijuancell";
    YouhuijuanTableViewCell *cell = (YouhuijuanTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell= (YouhuijuanTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"YouhuijuanTableViewCell" owner:self options:nil]  lastObject];
    }
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    NSNumber *end_time = [info objectForKey:@"end_time"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[end_time doubleValue]];//截止日期
    cell.dateLabel.text = [NSString stringWithFormat:@"有效期至%@",[confromTimesp dateWithFormat:@"yyyy-MM-dd"]];
    
    NSString *total_fee = [info objectForKey:@"youhui_total_fee"];//满多少
    cell.xianzhiLabel.text = [NSString stringWithFormat:@"满%@使用",total_fee];
    
    NSString *discountprice = [info objectForKey:@"discountprice"];//金额
    cell.moneyLabel.text = discountprice;
    return cell;
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setYouhuiInfo" object:info];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
