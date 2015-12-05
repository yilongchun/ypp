//
//  ViewController1.m
//  ypp
//
//  Created by haidony on 15/11/4.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "ViewController1.h"
#import "UserTableViewCell.h"

@interface ViewController1 ()

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
    
    _mytableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
//    [self.mytableview registerClass:[UserTableViewCell class] forCellReuseIdentifier:@"cell"];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.mytableview setTableFooterView:v];
    
    [self showHudInView:self.view hint:@"加载中"];
    [self loadData];
}

-(void)loadData{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//    [parameters setObject:[NSNumber numberWithInt:1] forKey:@"page"];
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
        NSLog(@"JSON: %@", operation.responseString);
        
//        NSString *result = [NSString stringWithFormat:@"%@",[operation responseString]];
//        NSError *error;
//        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
//        if (dic == nil) {
//            NSLog(@"json parse failed \r\n");
//        }else{
//            NSNumber *status = [dic objectForKey:@"status"];
//            if ([status intValue] == 200) {
//                NSDictionary *message = [[dic objectForKey:@"message"] cleanNull];
//                //                NSString *perishable_token = [message objectForKey:@"perishable_token"];
//                NSString *single_access_token = [message objectForKey:@"single_access_token"];
//                NSString *userid = [message objectForKey:@"id"];
//                [self showHint:@"注册成功"];
//                [UD setObject:message forKey:LOGINED_USER];
//                [UD setObject:userid forKey:USER_ID];
//                [UD setObject:single_access_token forKey:[NSString stringWithFormat:@"%@%@",USER_TOKEN_ID,userid]];
//                [self performSelector:@selector(toMainView) withObject:nil afterDelay:0.5];
//            }else if([status intValue] >= 600){
//                NSString *message = [dic objectForKey:@"message"];
//                [self showHint:message];
//            }
//        }
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    
    
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
