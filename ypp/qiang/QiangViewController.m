//
//  QiangViewController.m
//  ypp
//
//  Created by Stephen Chin on 16/1/15.
//  Copyright © 2016年 weyida. All rights reserved.
//

#import "QiangViewController.h"
#import "QiangTableViewCell.h"
#import "YYWebImage.h"
#import "NSDate+TimeAgo.h"
#import "NSDate+Extension.h"

@interface QiangViewController (){
    int page;
    NSMutableArray *dataSource;
}

@end

@implementation QiangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    dataSource = [NSMutableArray array];
    
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.mytableview setTableFooterView:v];
    [_mytableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _mytableview.backgroundColor = RGB(248, 248, 248);
    
    _mytableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
//    _mytableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [self loadMore];
//    }];
    
    [_mytableview.mj_header beginRefreshing];
}

-(void)loadData{
    page = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER];
    [parameters setValue:[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"id"]] forKey:@"userid"];
    
//    [parameters setValue:[NSNumber numberWithInt:page] forKey:@"page"];
//    //    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"near_close"];
//    [parameters setObject:[NSNumber numberWithInt:_type] forKey:@"type"];
//    //    [parameters setObject:[NSNumber numberWithInt:1] forKey:@"sex"];
//    //    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"price"];
//    [parameters setObject:[NSNumber numberWithFloat:31.624108] forKey:@"xpoint"];
//    [parameters setObject:[NSNumber numberWithFloat:115.415695] forKey:@"ypoint"];
//    //    [parameters setObject:@"" forKey:@"address"];
//    //    [parameters setObject:@"" forKey:@"gameid"];
//    //    [parameters setObject:@"" forKey:"distance"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_MY_YUE_LIST];
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
            if ([status intValue] == ResultCodeSuccess) {
                
                NSArray *array = [dic objectForKey:@"message"];
//
////                [dataSource removeAllObjects];
////                [dataSource addObjectsFromArray:array];
//                if(array != nil && array != NULL && [array count] != 0){
                    dataSource = [NSMutableArray arrayWithArray:array];
                    [_mytableview reloadData];
//                }
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
    
    NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER];
    [parameters setValue:[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"id"]] forKey:@"userid"];
    
//    [parameters setValue:[NSNumber numberWithInt:page] forKey:@"page"];
//    //    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"near_close"];
//    [parameters setObject:[NSNumber numberWithInt:_type] forKey:@"type"];
//    //    [parameters setObject:[NSNumber numberWithInt:1] forKey:@"sex"];
//    //    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"price"];
//    //    [parameters setObject:@"" forKey:@"address"];
//    //    [parameters setObject:@"" forKey:@"gameid"];
//    //    [parameters setObject:@"" forKey:"distance"];
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_YOUSHENLIST];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHud];
        
        //        NSLog(@"JSON: %@", operation.responseString);
        
        NSString *result = [NSString stringWithFormat:@"%@",[operation responseString]];
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == ResultCodeSuccess) {
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
    static NSString *CellIdentifier = @"qiangcell";
    QiangTableViewCell *cell = (QiangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell= (QiangTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"QiangTableViewCell" owner:self options:nil]  lastObject];
        cell.avatar.layer.masksToBounds = YES;
        cell.avatar.layer.cornerRadius = 5.0;
    }
    
    NSDictionary *info = [[dataSource objectAtIndex:indexPath.row] cleanNull];
    NSString *avatar = [info objectForKey:@"avatar"];
//    NSString *orderid = [info objectForKey:@"orderid"];
    
    NSString *begin = [info objectForKey:@"begin"];
    NSString *hours = [info objectForKey:@"hours"];
//    NSString *gamename = [info objectForKey:@"gamename"];
//    NSString *storeid = [info objectForKey:@"storeid"];
    NSString *storename = [info objectForKey:@"storename"];
//    NSString *price = [info objectForKey:@"price"];
    NSString *vipprice = [info objectForKey:@"vipprice"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(qiang:)];
    cell.orderStatus.tag = indexPath.row;
    [cell.orderStatus addGestureRecognizer:tap];
    
    if (![avatar isEqualToString:@""]) {
        [cell.avatar yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholder:[UIImage imageNamed:@"gallery_default"] options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    }
    
    cell.address.text = storename;
    
    NSNumber *totalPrice = [NSNumber numberWithDouble:[vipprice doubleValue] * [hours intValue]];
    
    cell.price.text = [NSString stringWithFormat:@"%d",[totalPrice intValue]];
    cell.dateLabel.text = begin;
    
    NSNumber *order_create_time = [info objectForKey:@"order_create_time"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[order_create_time doubleValue]];
    cell.orderTime.text = [NSString stringWithFormat:@"%@",[confromTimesp timeAgo]];
    
    NSDate *beginDate = [NSDate dateWithString:begin format:@"yyyy-MM-dd hh:mm"];
    NSDate *endDate = [beginDate offsetHours:[hours intValue]];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ %@~%@",[beginDate stringWithFormat:@"MM月dd日"],[beginDate stringWithFormat:@"hh:mm"],[endDate stringWithFormat:@"hh:mm"]];
    
    NSString *vipuserid = [info objectForKey:@"vipuserid"];//订单选定的游神id
    NSString *revipids = [info objectForKey:@"revipids"];//应约的游神id数组
    if (vipuserid != nil && ![vipuserid isEqualToString:@""]) {//已经选择了游神
        NSString *vipid = [[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] cleanNull] objectForKey:@"id"];
        
        if ([vipuserid isEqualToString:vipid]) {//抢单成功
            cell.orderStatus.image = [UIImage imageNamed:@"qiangdanchenggong"];
        }else{//已被抢
            cell.orderStatus.image = [UIImage imageNamed:@"beiqiang"];
        }
    }else{
        if (revipids != nil && ![revipids isEqualToString:@""]) {
            NSString *vipid = [[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] cleanNull] objectForKey:@"id"];
            
            NSArray *vipids = [revipids componentsSeparatedByString:@","];
            if ([vipids containsObject:vipid]) {//已抢待筛选
                cell.orderStatus.image = [UIImage imageNamed:@"yiqiang"];
            }else{
                cell.orderStatus.image = [UIImage imageNamed:@"qiang"];
            }
        }else{//待抢
            cell.orderStatus.image = [UIImage imageNamed:@"qiang"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    NSDictionary *info = [[dataSource objectAtIndex:indexPath.row] cleanNull];
//    NSString *userid = [info objectForKey:@"userid"];
//    NSString *loginedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"];
//    
//    if ([userid isEqualToString:loginedUserId]) {//是自己
//        MyInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
//        vc.userid = userid;
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
//        PlayerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
//        vc.hidesBottomBarWhenPushed = YES;
//        vc.userid = [info objectForKey:@"userid"];
//        vc.title = [info objectForKey:@"user_name"];
//        vc.youshenInfo = info;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark

-(void)qiang:(UITapGestureRecognizer *)recognizer{
    NSDictionary *info = [[dataSource objectAtIndex:recognizer.view.tag] cleanNull];
    NSString *orderid = [info objectForKey:@"orderid"];
    NSString *vipid = [[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] cleanNull] objectForKey:@"id"];
    
    
    NSString *vipuserid = [info objectForKey:@"vipuserid"];//订单选定的游神id
    NSString *revipids = [info objectForKey:@"revipids"];//应约的游神id数组
    if (vipuserid != nil && ![vipuserid isEqualToString:@""]) {//已经选择了游神
        NSString *vipid = [[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] cleanNull] objectForKey:@"id"];
        
        if ([vipuserid isEqualToString:vipid]) {//抢单成功
            
        }else{//已被抢
            
        }
    }else{
        if (revipids != nil && ![revipids isEqualToString:@""]) {
            NSString *vipid = [[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] cleanNull] objectForKey:@"id"];
            
            NSArray *vipids = [revipids componentsSeparatedByString:@","];
            if ([vipids containsObject:vipid]) {//已抢待筛选
                
            }else{//待抢
                [self qiang:orderid vipid:vipid];
            }
        }else{//待抢
            [self qiang:orderid vipid:vipid];
        }
    }
}

/**
 *  抢单
 */
-(void)qiang:(NSString *)orderid vipid:(NSString *)vipid{
    
    [self showHudInView:self.view];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:vipid forKey:@"vipid"];
    [parameters setValue:orderid forKey:@"orderid"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_JOIN_ORDER];
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
                
                [self loadData];
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

@end
