//
//  QiangViewController.m
//  ypp
//
//  Created by Stephen Chin on 16/1/15.
//  Copyright © 2016年 weyida. All rights reserved.
//

#import "QiangViewController.h"
#import "QiangTableViewCell.h"

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
    _mytableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMore];
    }];
    
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
                
//                NSArray *array = [dic objectForKey:@"message"];
//                
////                [dataSource removeAllObjects];
////                [dataSource addObjectsFromArray:array];
//                if(array != nil && array != NULL && [array count] != 0){
//                    dataSource = [NSMutableArray arrayWithArray:array];
//                    [_mytableview reloadData];
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"qiangcell";
    QiangTableViewCell *cell = (QiangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell= (QiangTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"QiangTableViewCell" owner:self options:nil]  lastObject];
    }
    
    
    
    
//    NSDictionary *info = [[dataSource objectAtIndex:indexPath.row] cleanNull];
//    
//    NSString *user_name = [info objectForKey:@"user_name"];
//    NSString *avatar = [info objectForKey:@"avatar"];
//    NSNumber *sex = [info objectForKey:@"sex"];
//    cell.usernameLabel.text = user_name;
//    //    [cell.userimage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
//    
//    [cell.userimage yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholder:[UIImage imageNamed:@"gallery_default"] options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    
    //    [cell.userimage yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholder:[UIImage imageNamed:@"gallery_default"] options:YYWebImageOptionSetImageWithFadeAnimation progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    //        float progress = (float)receivedSize / expectedSize;
    //        DLog(@"%f",progress);
    //    } transform:^UIImage *(UIImage *image, NSURL *url) {
    //        image = [image yy_imageByResizeToSize:CGSizeMake(100, 100) contentMode:UIViewContentModeCenter];
    //        return [image yy_imageByRoundCornerRadius:10];
    //    } completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
    //        if (from == YYWebImageFromDiskCache) {
    //            NSLog(@"load from disk cache");
    //        }
    //    }];
    //    [cell.userimage yy_setImageWithURL:url options:YYWebImageOptionProgressiveBlur ｜ YYWebImageOptionSetImageWithFadeAnimation];
    
    
    
//    cell.userimage.layer.masksToBounds = YES;
//    cell.userimage.layer.cornerRadius = 5.0;
//    if ([sex intValue] == 0) {
//        [cell.sexImage setHidden:NO];
//        [cell.sexImage setImage:[UIImage imageNamed:@"usercell_girl"]];
//        NSNumber *byear = [info objectForKey:@"byear"];
//        NSNumber *bmonth = [info objectForKey:@"bmonth"];
//        NSNumber *bday = [info objectForKey:@"bday"];
//        NSDate *birthday = [NSDate dateWithYear:[byear integerValue] month:[bmonth integerValue] day:[bday integerValue]];
//        NSInteger age = [NSDate ageWithDateOfBirth:birthday];
//        cell.ageLabel.text = [NSString stringWithFormat:@"%ld",(long)age];
//    }else if ([sex intValue] == 1){
//        [cell.sexImage setHidden:NO];
//        [cell.sexImage setImage:[UIImage imageNamed:@"usercell_boy"]];
//        NSNumber *byear = [info objectForKey:@"byear"];
//        NSNumber *bmonth = [info objectForKey:@"bmonth"];
//        NSNumber *bday = [info objectForKey:@"bday"];
//        NSDate *birthday = [NSDate dateWithYear:[byear integerValue] month:[bmonth integerValue] day:[bday integerValue]];
//        NSInteger age = [NSDate ageWithDateOfBirth:birthday];
//        cell.ageLabel.text = [NSString stringWithFormat:@"%ld",(long)age];
//    }else{
//        [cell.sexImage setHidden:YES];
//    }
//    
//    NSNumber *distance = [info objectForKey:@"distance"];
//    NSString *dis = [NSString stringWithFormat:@"%.2fkm",[distance floatValue] / 1000];
//    NSNumber *update_time = [info objectForKey:@"update_time"];
//    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[update_time doubleValue]];
//    cell.otherInfo.text = [NSString stringWithFormat:@"%@|%@",dis,[confromTimesp timeAgo]];
//    
//    NSNumber *hotcount = [info objectForKey:@"hotcount"];
//    if (hotcount != nil) {
//        cell.numLabel.text = [NSString stringWithFormat:@"%d",[hotcount intValue]];
//    }else{
//        cell.numLabel.text = @"0";
//    }
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

@end
