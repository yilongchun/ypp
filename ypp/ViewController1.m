//
//  ViewController1.m
//  ypp
//
//  Created by haidony on 15/11/4.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "ViewController1.h"
#import "UserTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface ViewController1 (){
    int page;
}

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
////        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        self.extendedLayoutIncludesOpaqueBars = YES;
//    }
    
    if ([self.mytableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mytableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mytableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mytableview setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.mytableview setTableFooterView:v];
    
    dataSource = [NSMutableArray array];
    
    _mytableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    _mytableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    
//    [self.mytableview registerClass:[UserTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    [self showHudInView:self.view];
    [self loadData];
}

-(void)loadData{
    page = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSNumber numberWithInt:page] forKey:@"page"];
//    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"near_close"];
//    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"type"];
//    [parameters setObject:[NSNumber numberWithInt:1] forKey:@"sex"];
//    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"price"];
//    [parameters setObject:@"" forKey:@"address"];
//    [parameters setObject:@"" forKey:@"gameid"];
//    [parameters setObject:@"" forKey:"distance"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_YOUSHENLIST];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHud];
        [_mytableview.mj_header endRefreshing];
        [_mytableview.mj_footer resetNoMoreData];
        NSLog(@"JSON: %@", operation.responseString);
        
        NSString *result = [NSString stringWithFormat:@"%@",[operation responseString]];
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == 200) {
                
                NSArray *array = [dic objectForKey:@"message"];
                
                [dataSource removeAllObjects];
                [dataSource addObjectsFromArray:array];
                [_mytableview reloadData];
                
            }else{
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [_mytableview.mj_header endRefreshing];
        [self hideHud];
        [self showHint:@"连接失败"];
        
    }];
}

-(void)loadMore{
    page++;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSNumber numberWithInt:page] forKey:@"page"];
    //    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"near_close"];
    //    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"type"];
    //    [parameters setObject:[NSNumber numberWithInt:1] forKey:@"sex"];
    //    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"price"];
    //    [parameters setObject:@"" forKey:@"address"];
    //    [parameters setObject:@"" forKey:@"gameid"];
    //    [parameters setObject:@"" forKey:"distance"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_YOUSHENLIST];
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
                [_mytableview.mj_footer endRefreshing];
                NSArray *array = [dic objectForKey:@"message"];
                [dataSource addObjectsFromArray:array];
                [_mytableview reloadData];
            }else{
                if ([status intValue] == ResultCodeNoData) {
                    page--;
                    [_mytableview.mj_footer endRefreshingWithNoMoreData];
                }else{
                    [_mytableview.mj_footer endRefreshing];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *info = [[dataSource objectAtIndex:indexPath.row] cleanNull];
    
    NSString *user_name = [info objectForKey:@"user_name"];
    NSString *avatar = [info objectForKey:@"avatar"];
    NSNumber *sex = [info objectForKey:@"sex"];
    cell.usernameLabel.text = user_name;
    [cell.userimage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,avatar]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
    if ([sex intValue] == 0) {
        [cell.sexImage setHidden:NO];
        [cell.sexImage setImage:[UIImage imageNamed:@"usercell_girl"]];
    }else if ([sex intValue] == 1){
        [cell.sexImage setHidden:NO];
        [cell.sexImage setImage:[UIImage imageNamed:@"usercell_boy"]];
    }else{
        [cell.sexImage setHidden:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.mytableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mytableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mytableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mytableview setLayoutMargins:UIEdgeInsetsZero];
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
