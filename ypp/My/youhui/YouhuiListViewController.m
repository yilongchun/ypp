//
//  YouhuiListViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/18.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "YouhuiListViewController.h"
#import "LishiYouhuiListTableViewController.h"
#import "YouhuijuanTableViewCell.h"
#import "NSDate+Addition.h"

@interface YouhuiListViewController (){
    NSMutableArray *dataSource;
    int page;
}

@end

@implementation YouhuiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的优惠劵";
    
    dataSource = [NSMutableArray array];
    
    
    //请输入正确的兑换码
    UIImage *backgroundImage = [[UIImage imageNamed:@"blue_btn2"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    [_duiBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [_duiBtn addTarget:self action:@selector(duihuan) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    if ([self.mytableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mytableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mytableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mytableview setLayoutMargins:UIEdgeInsetsZero];
    }
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.mytableview setTableFooterView:v];
    
    _mytableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
//    [dataSource addObject:@"1"];
//    [dataSource addObject:@"1"];
//    [dataSource addObject:@"1"];
    
    [self showHudInView:self.view];
    [self loadData];
    
}

/**
 * 兑换
 */
-(void)duihuan{
    [[IQKeyboardManager sharedManager] resignFirstResponder];
    [self showHint:@"请输入正确的兑换码"];
    return;
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
        [_mytableview.mj_header endRefreshing];
        [_mytableview.mj_footer resetNoMoreData];
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
                    _mytableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                        [self loadMore];
                    }];
                }
                [_mytableview reloadData];
            }else{
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [_mytableview.mj_header endRefreshing];
        [_mytableview.mj_footer resetNoMoreData];
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
        [_mytableview.mj_footer endRefreshing];
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
                [_mytableview reloadData];
            }else{
                if ([status intValue] == ResultCodeNoData) {
                    page--;
                    [_mytableview.mj_footer endRefreshingWithNoMoreData];
                }else{
                    NSString *message = [dic objectForKey:@"message"];
                    [self showHint:message];
                }
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [_mytableview.mj_footer endRefreshing];
        [self hideHud];
        [self showHint:@"连接失败"];
    }];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [dataSource count]) {
        return 30;
    }
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSource count] + 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (indexPath.row == [dataSource count]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text = @"历史优惠劵";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        
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
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == [dataSource count]) {
        LishiYouhuiListTableViewController *vc = [[LishiYouhuiListTableViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
