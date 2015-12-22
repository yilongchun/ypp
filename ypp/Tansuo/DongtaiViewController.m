//
//  DongtaiViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/7.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "DongtaiViewController.h"
#import "DongtaiTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Addition.h"
#import "NSDate+TimeAgo.h"
#import "DongtaiDetailViewController.h"

@interface DongtaiViewController (){
    int page;
//    float willEndContentOffsetY;
//    float endContentOffsetY;
//    UIButton *addBtn;
//    CGRect btnFrame;
}

@property CGPoint offsetY;

@end

@implementation DongtaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
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
    
    
//    addBtn = [[UIButton alloc] initWithFrame:CGRectMake(Main_Screen_Width - 80, self.mytableview.frame.size.height - 80, 50, 50)];
//    [addBtn setTitle:@"+" forState:UIControlStateNormal];
//    UIImage *backgroundImage = [[UIImage imageNamed:@"blue_btn2"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
//    [addBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
//    [self.mytableview.window addSubview:addBtn];
    
    
    [self showHudInView:self.view];
    [self loadData];
}

-(void)loadData{
    page = 1;
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSNumber numberWithInt:page] forKey:@"page"];
    
    NSString *urlString;
    
    if ([self.type isEqualToString:@"5"]) {
        [parameters setValue:@"1" forKey:@"type"];
        urlString = [NSString stringWithFormat:@"%@%@",HOST,API_TOPICLIST_BY_USER];
        [parameters setValue:self.dongtaiUserId forKey:@"userid"];
    }else{
        [parameters setValue:self.type forKey:@"type"];
        urlString = [NSString stringWithFormat:@"%@%@",HOST,API_TOPICLIST];
        NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER];
        [parameters setValue:[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"id"]] forKey:@"userid"];
    }
    
    
    
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
    
    NSString *urlString;
    
    if ([self.type isEqualToString:@"5"]) {
        [parameters setValue:@"1" forKey:@"type"];
        urlString = [NSString stringWithFormat:@"%@%@",HOST,API_TOPICLIST_BY_USER];
        [parameters setValue:self.dongtaiUserId forKey:@"userid"];
    }else{
        [parameters setValue:self.type forKey:@"type"];
        urlString = [NSString stringWithFormat:@"%@%@",HOST,API_TOPICLIST];
        NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER];
        [parameters setValue:[NSString stringWithFormat:@"%@",[userinfo objectForKey:@"id"]] forKey:@"userid"];
    }
    
    

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
    CGFloat height = 556-18;
    NSDictionary *info = [[dataSource objectAtIndex:indexPath.row] cleanNull];
    NSString *content = [info objectForKey:@"content"];
    
    CGFloat contentWidth = Main_Screen_Width - 20;
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize textSize;
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        textSize = [content boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT)
                                         options:options
                                      attributes:attributes
                                         context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [content sizeWithFont:font
                       constrainedToSize:CGSizeMake(contentWidth, MAXFLOAT)
                           lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        
    }
    return height + textSize.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DongtaiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dongtaicell"];
    NSDictionary *info = [[dataSource objectAtIndex:indexPath.row] cleanNull];
    NSString *avatar = [info objectForKey:@"avatar"];//头像
    NSString *user_name = [info objectForKey:@"user_name"];
    NSNumber *sex = [info objectForKey:@"sex"];
    NSString *content = [info objectForKey:@"content"];
    NSString *pic = [info objectForKey:@"pic"];
    
    [cell.userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
    cell.userImage.layer.masksToBounds = YES;
    cell.userImage.layer.cornerRadius = 5;
    cell.username.text = user_name;
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
    cell.contentLabel.text = content;
    if (pic != nil && ![pic isEqualToString:@""]) {
        [cell.bigImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,pic]] placeholderImage:nil];
    }
    
    NSNumber *distance = [info objectForKey:@"distance"];
    NSString *dis = [NSString stringWithFormat:@"%.2fkm",[distance floatValue] / 1000];
    
    NSNumber *update_time = [info objectForKey:@"update_time"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[update_time doubleValue]];
    
    cell.otherLabel.text = [NSString stringWithFormat:@"%@|%@",dis,[confromTimesp timeAgo]];
    
    
    cell.btn1.tag = indexPath.row;
    cell.btn2.tag = indexPath.row;
    cell.btn3.tag = indexPath.row;
    cell.btn4.tag = indexPath.row;
    
    [cell.btn1 addTarget:self action:@selector(action1:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn2 addTarget:self action:@selector(action2:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn3 addTarget:self action:@selector(action3:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn4 addTarget:self action:@selector(action4:) forControlEvents:UIControlEventTouchUpInside];
    
    //评论数
    NSNumber *relay_count = [info objectForKey:@"reply_count"];
    [cell.btn1 setTitle:[NSString stringWithFormat:@"(%d)",[relay_count intValue]] forState:UIControlStateNormal];
    
    //点赞数
//    NSNumber *fav_count = [info objectForKey:@"fav_count"];
    NSNumber *fav_count = [info objectForKey:@"topic_fav_count"];
    [cell.btn3 setTitle:[NSString stringWithFormat:@"(%d)",[fav_count intValue]] forState:UIControlStateNormal];
    [cell.btn3 setImage:[UIImage imageNamed:@"dongtailist_heart_empty"] forState:UIControlStateNormal];
    DLog(@"%d",[fav_count intValue]);
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showDetail:indexPath.row];
}

//回复
-(void)action1:(UIButton *)btn{
    [self showDetail:btn.tag];
}
//打赏
-(void)action2:(UIButton *)btn{
    
}
//点赞
-(void)action3:(UIButton *)btn{
    
    NSDictionary *info = [dataSource objectAtIndex:btn.tag];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"]] forKey:@"userid"];
    [parameters setValue:[info objectForKey:@"topicid"] forKey:@"topicid"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_FAVTOPIC];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", operation.responseString);
        
        NSString *result = [NSString stringWithFormat:@"%@",[operation responseString]];
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == ResultCodeSuccess) {
                
                NSNumber *fav_count = [info objectForKey:@"fav_count"];
                [btn setTitle:[NSString stringWithFormat:@"(%d)",[fav_count intValue] + 1] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"dongtailist_heart_full"] forState:UIControlStateNormal];
            }else{
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
        [self showHint:@"连接失败"];
    }];

    
}
//分享
-(void)action4:(UIButton *)btn{
    
}

-(void)showDetail:(NSInteger)index{
    NSDictionary *info = [[dataSource objectAtIndex:index] cleanNull];
    DongtaiDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DongtaiDetailViewController"];
    vc.info = info;
    [self.navigationController pushViewController:vc animated:YES];
}


//- (void)viewDidAppear:(BOOL)animated
//{
//    btnFrame = addBtn.frame;
//}
////将要开始拖拽，手指已经放在view上并准备拖动的那一刻
//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{    //将要停止前的坐标
//    
//    willEndContentOffsetY = scrollView.contentOffset.y;
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    
//    endContentOffsetY = scrollView.contentOffset.y;
//    
//    if (endContentOffsetY < willEndContentOffsetY || endContentOffsetY==0) { //从下往上移动，或移到顶部
//        
//        [UIView beginAnimations:nil context:nil];
//        
//        addBtn.frame = btnFrame;
//        
//        [UIView commitAnimations];
//        
//    } else if (endContentOffsetY > willEndContentOffsetY) {//从上往下移动
//        
//        [UIView beginAnimations:nil context:nil];
//        
//        CGRect tmppingFrame = addBtn.frame;
//        tmppingFrame.origin.x = -tmppingFrame.size.width;
//        addBtn.frame = tmppingFrame;
//        
//        [UIView commitAnimations];
//    }
//}

@end
