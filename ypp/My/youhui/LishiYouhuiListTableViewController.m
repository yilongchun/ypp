//
//  LishiYouhuiListTableViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/18.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "LishiYouhuiListTableViewController.h"
#import "YouhuijuanTableViewCell.h"
#import "NSDate+Addition.h"

@interface LishiYouhuiListTableViewController (){
    NSMutableArray *dataSource;
    int page;
}

@end

@implementation LishiYouhuiListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"历史优惠劵";
    
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
    
//    [dataSource addObject:@"1"];
//    [dataSource addObject:@"1"];
//    [dataSource addObject:@"1"];
    
    [self showHudInView:self.view];
    [self loadData];
}

-(void)loadData{
    page = 1;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_YOUHUI_LIST];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"]] forKey:@"userid"];
    [parameters setValue:@"1" forKey:@"type"];//type（0 可用的,1历史所有并分页）
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [cell.imageStatus setImage:[UIImage imageNamed:@"Invalid"]];;
//    cell.moneyLeftLabel.textColor = [UIColor lightGrayColor];
//    cell.moneyLabel.textColor = [UIColor lightGrayColor];
//    cell.youhuijuanLabel.textColor = [UIColor lightGrayColor];
//    cell.dateLabel.textColor = [UIColor lightGrayColor];
//    cell.xianzhiLabel.textColor = [UIColor lightGrayColor];
    
    cell.moneyLeftLabel.textColor = RGB(210, 210, 210);
    cell.moneyLabel.textColor = RGB(210, 210, 210);
    cell.youhuijuanLabel.textColor = RGB(210, 210, 210);
    cell.dateLabel.textColor = RGB(210, 210, 210);
    cell.xianzhiLabel.textColor = RGB(210, 210, 210);
    
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    NSNumber *end_time = [info objectForKey:@"end_time"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[end_time doubleValue]];//截止日期
    cell.dateLabel.text = [NSString stringWithFormat:@"有效期至%@",[confromTimesp dateWithFormat:@"yyyy-MM-dd"]];
    
    NSString *total_fee = [info objectForKey:@"total_fee"];//满多少
    cell.xianzhiLabel.text = [NSString stringWithFormat:@"满%@使用",total_fee];
    
    NSString *discountprice = [info objectForKey:@"discountprice"];//金额
    cell.moneyLabel.text = discountprice;
    
    return cell;
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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
