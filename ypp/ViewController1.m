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
#import "NSDate+Addition.h"
#import "NSDate+TimeAgo.h"
#import "PlayerViewController.h"
#import "MyInfoViewController.h"
#import "YYWebImage.h"

@interface ViewController1 (){
    int page;
}

@property (nonatomic) UIEdgeInsets originalInsets;

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
//    if(self.mytableview){
//        if (self.navigationController.navigationBar.isOpaque){
//            float topInset = self.navigationController.navigationBar.frame.size.height;
//            
//            self.mytableview.contentInset = UIEdgeInsetsMake(topInset + self.mytableview.contentInset.top,
//                                                                         self.mytableview.contentInset.left,
//                                                                         self.mytableview.contentInset.bottom,
//                                                                         self.mytableview.contentInset.right);
//        }
//        self.originalInsets = self.mytableview.contentInset;
//    }
    
    
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
    
    [_mytableview.mj_header beginRefreshing];
//    [self showHudInView:self.view];
//    [self loadData];
}

-(void)loadData{
    page = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSNumber numberWithInt:page] forKey:@"page"];
//    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"near_close"];
    [parameters setObject:[NSNumber numberWithInt:_type] forKey:@"type"];
//    [parameters setObject:[NSNumber numberWithInt:1] forKey:@"sex"];
//    [parameters setObject:[NSNumber numberWithInt:0] forKey:@"price"];
    [parameters setObject:[NSNumber numberWithFloat:31.624108] forKey:@"xpoint"];
    [parameters setObject:[NSNumber numberWithFloat:115.415695] forKey:@"ypoint"];
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
            if ([status intValue] == ResultCodeSuccess) {
                
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
    [parameters setObject:[NSNumber numberWithInt:_type] forKey:@"type"];
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
    return 85;
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
//    [cell.userimage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
    
    [cell.userimage yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholder:[UIImage imageNamed:@"gallery_default"] options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    
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
    
    
    
    cell.userimage.layer.masksToBounds = YES;
    cell.userimage.layer.cornerRadius = 5.0;
    if ([sex intValue] == 0) {
        [cell.sexImage setHidden:NO];
        [cell.sexImage setImage:[UIImage imageNamed:@"usercell_girl"]];
        NSNumber *byear = [info objectForKey:@"byear"];
        NSNumber *bmonth = [info objectForKey:@"bmonth"];
        NSNumber *bday = [info objectForKey:@"bday"];
        NSDate *birthday = [NSDate dateWithYear:[byear integerValue] month:[bmonth integerValue] day:[bday integerValue]];
        NSInteger age = [NSDate ageWithDateOfBirth:birthday];
        cell.ageLabel.text = [NSString stringWithFormat:@"%ld",(long)age];
    }else if ([sex intValue] == 1){
        [cell.sexImage setHidden:NO];
        [cell.sexImage setImage:[UIImage imageNamed:@"usercell_boy"]];
        NSNumber *byear = [info objectForKey:@"byear"];
        NSNumber *bmonth = [info objectForKey:@"bmonth"];
        NSNumber *bday = [info objectForKey:@"bday"];
        NSDate *birthday = [NSDate dateWithYear:[byear integerValue] month:[bmonth integerValue] day:[bday integerValue]];
        NSInteger age = [NSDate ageWithDateOfBirth:birthday];
        cell.ageLabel.text = [NSString stringWithFormat:@"%ld",(long)age];
    }else{
        [cell.sexImage setHidden:YES];
    }
    
    NSNumber *distance = [info objectForKey:@"distance"];
    NSString *dis = [NSString stringWithFormat:@"%.2fkm",[distance floatValue] / 1000];
    NSNumber *update_time = [info objectForKey:@"update_time"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[update_time doubleValue]];
    cell.otherInfo.text = [NSString stringWithFormat:@"%@|%@",dis,[confromTimesp timeAgo]];
    
    NSNumber *hotcount = [info objectForKey:@"hotcount"];
    if (hotcount != nil) {
        cell.numLabel.text = [NSString stringWithFormat:@"%d",[hotcount intValue]];
    }else{
        cell.numLabel.text = @"0";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *info = [[dataSource objectAtIndex:indexPath.row] cleanNull];
    NSString *userid = [info objectForKey:@"userid"];
    NSString *loginedUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"];
    
    if ([userid isEqualToString:loginedUserId]) {//是自己
        MyInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyInfoViewController"];
        vc.userid = userid;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        PlayerViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
        vc.hidesBottomBarWhenPushed = YES;
        vc.userid = [info objectForKey:@"userid"];
        vc.title = [info objectForKey:@"user_name"];
        vc.youshenInfo = info;
        [self.navigationController pushViewController:vc animated:YES];
    }
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

//#pragma mark
//#pragma Navigation hide Scroll
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    isDecelerating = YES;
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    isDecelerating = NO;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if(self.mytableview != scrollView)
//        return;
//    if(scrollView.frame.size.height >= scrollView.contentSize.height)
//        return;
//    if(scrollView.contentOffset.y >= -self.navigationController.navigationBar.frame.size.height && scrollView.contentOffset.y <= 0){
//        DLog(@"1");
////        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y + [UIApplication sharedApplication].statusBarFrame.size.height,
////                                                   self.originalInsets.left,
////                                                   self.originalInsets.bottom, self.originalInsets.right);
//    }
//    else if(scrollView.contentOffset.y >= scrollView.contentInset.top){
//        DLog(@"2");
//        scrollView.contentInset = UIEdgeInsetsZero;
//    }
//    
//    
//    if(lastOffsetY < scrollView.contentOffset.y && scrollView.contentOffset.y >= -self.navigationController.navigationBar.frame.size.height){//moving up
//        
//        if(self.navigationController.navigationBar.frame.size.height + self.navigationController.navigationBar.frame.origin.y  > 0){//not yet hidden
//            
//            float newY = self.navigationController.navigationBar.frame.origin.y - (scrollView.contentOffset.y - lastOffsetY);
//            if(newY < -self.navigationController.navigationBar.frame.size.height){
//                newY = -self.navigationController.navigationBar.frame.size.height;
////                self.navigationController.navigationBar.frame = CGRectMake(self.navigationController.navigationBar.frame.origin.x,
////                                                                           newY,
////                                                                           self.navigationController.navigationBar.frame.size.width,
////                                                                           self.navigationController.navigationBar.frame.size.height);
//                DLog(@"3");
//            }
//            
//            
//        }
//    }else
//        if(self.navigationController.navigationBar.frame.origin.y < [UIApplication sharedApplication].statusBarFrame.size.height  &&
//           (self.mytableview.contentSize.height > self.mytableview.contentOffset.y + self.mytableview.frame.size.height)){//not yet shown
//            
//            float newY = self.navigationController.navigationBar.frame.origin.y + (lastOffsetY - scrollView.contentOffset.y);
//            if(newY > [UIApplication sharedApplication].statusBarFrame.size.height)
//            {
////                newY = [UIApplication sharedApplication].statusBarFrame.size.height;
////                self.navigationController.navigationBar.frame = CGRectMake(self.navigationController.navigationBar.frame.origin.x,
////                                                                           newY,
////                                                                           self.navigationController.navigationBar.frame.size.width,
////                                                                           self.navigationController.navigationBar.frame.size.height);
//                DLog(@"4");
//            }
//            
//        }
//    
//    lastOffsetY = scrollView.contentOffset.y;
//}

@end
