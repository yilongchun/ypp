//
//  ChooseDashenViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/25.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "ChooseDashenViewController.h"
#import "NSObject+Blocks.h"
#import "DashenTableViewCell.h"
#import "NSDate+Extension.h"
#import "DingdanDetailTableViewController.h"
#import "ChooseYouhuiTableViewController.h"
#import "UIImageView+AFNetworking.h"

@interface ChooseDashenViewController (){
    UILabel *topLabel;
    UILabel *timeLabel;
    NSMutableArray *dataSource;
    dispatch_source_t _timer;
    BOOL flag;
    
    int payType;//支付类型 1余额 2微信 3支付宝
    NSDictionary *youhuiInfo;//优惠信息
}

@end

@implementation ChooseDashenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择大神";
    
    
    topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 4)];
    topLabel.backgroundColor = RGB(210,32,44);
    topLabel.alpha = 0.7;
    [self.view addSubview:topLabel];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, Main_Screen_Width, 16)];
    timeLabel.font = [UIFont systemFontOfSize:13];
    timeLabel.textColor = [UIColor darkGrayColor];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.text = @"";
    UIView *tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 36)];
    [tableFootView addSubview:timeLabel];
    self.mytableview.tableFooterView = tableFootView;
    
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"more"] style:UIBarButtonItemStyleDone target:self action:@selector(more)];
    [rightItem setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightItem;

    
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setYouhuiInfo:)   name:@"setYouhuiInfo" object:nil];
    
    [self initMyBottomView];
    
    [self loadData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
    if (flag) {
        [self startAnimation];
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (_timer != nil) {
        dispatch_source_cancel(_timer);
    }
    [self stopAnimation];
}

//开启动画
-(void)startAnimation{
    CABasicAnimation *animation = (CABasicAnimation *)[topLabel.layer animationForKey:@"loading"];
    if (animation == nil) {
        animation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
        // 动画选项设定
        animation.duration = 1.2; // 动画持续时间
        animation.repeatCount = INT_MAX; // 重复次数
        animation.autoreverses = YES; // 动画结束时执行逆动画
        // 缩放倍数
        animation.fromValue = [NSNumber numberWithFloat:0.05]; // 开始时的倍率
        animation.toValue = [NSNumber numberWithFloat:1]; // 结束时的倍率
        [topLabel.layer addAnimation:animation forKey:@"loading"];
    }
}

//关闭动画
-(void)stopAnimation{
    [topLabel.layer removeAnimationForKey:@"loading"];
}

//计算时间
-(void)jisuan{
    
    
    
    
    NSNumber *create_time = [_dingdanInfo objectForKey:@"create_time"];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[create_time doubleValue]];
    
    //    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    //    NSInteger interval = [zone secondsFromGMTForDate: startDate];
    //    NSDate *localeDate = [startDate  dateByAddingTimeInterval: interval];
    
    
    DLog(@"%@ %d",startDate,[create_time intValue]);
    DLog(@"%@ %ld",[startDate offsetSeconds:60*15],(long)[[startDate offsetSeconds:60*15] timeIntervalSince1970]);
    
    NSTimeInterval timeInterval = [[startDate offsetSeconds:60*15] timeIntervalSinceDate:[NSDate date]];
    
    
    
    if (timeInterval < 0) {//超过15分钟
        flag = NO;
        DLog(@"倒计时结束 取消订单");
        timeLabel.text = [NSString stringWithFormat:@"选择大神超时，订单已取消"];
        [self cancelDingdan:@"选择大神超时，订单已取消"];
        //调用取消订单接口
    }else{
        
        __block int timeout=timeInterval; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    DLog(@"倒计时结束 取消订单");
                    flag = NO;
                    [self cancelDingdan:@"选择大神超时，订单已取消"];
                    timeLabel.text = [NSString stringWithFormat:@"选择大神超时，订单已取消"];
                    //调用取消订单接口
//                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                DLog(@"%d",timeout);
                int minute=((int)timeout)%(3600*24)/60;
//                int seconds = timeout % 60;
//                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    flag = YES;
                    [self startAnimation];
                    //设置界面的按钮显示 根据自己需求设置
                    //NSLog(@"____%@",strTime);
//                    [UIView beginAnimations:nil context:nil];
//                    [UIView setAnimationDuration:1];
//                    [getCodeBtn setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
//                    [UIView commitAnimations];
//                    DLog(@"%d",minute);
                    
                    timeLabel.text = [NSString stringWithFormat:@"请尽快选好大神，将在%d分钟后取消订单。",minute+1];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
        
    }
    DLog(@"%f",timeInterval);
}

//取消订单
-(void)cancelDingdan:(NSString *)msg{
    [self showHudInView:self.view];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setValue:[_dingdanInfo objectForKey:@"id"] forKey:@"orderid"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_CANCELYUE];
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
                [self stopAnimation];
                if (_timer != nil) {
                    dispatch_source_cancel(_timer);
                }
                [self showHint:msg];
                timeLabel.text = [NSString stringWithFormat:@"订单已取消"];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"loadDingdanData" object:nil];
                [self performBlock:^{
                    [self.navigationController popViewControllerAnimated:YES];
                } afterDelay:1.5];
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

//更多
-(void)more{
    //取消订单
    //订单详情
    //取消
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self cancelDingdan:@"订单已取消"];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"订单详情" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        DingdanDetailTableViewController *vc = [[DingdanDetailTableViewController alloc] init];
        vc.info = _dingdanInfo;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)loadData{

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[NSNumber numberWithInt:1] forKey:@"page"];
//    [parameters setValue:_type forKey:@"type"];
    [parameters setValue:[_dingdanInfo objectForKey:@"id"] forKey:@"orderid"];
    
    //大神列表
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_GET_VIP_LIST];
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
                
                NSArray *array = [dic objectForKey:@"message"];
                dataSource = [NSMutableArray arrayWithArray:array];
                [self.mytableview reloadData];
                
            }else{
//                NSString *message = [dic objectForKey:@"message"];
//                [self showHint:message];
            }
            if (dataSource == nil || [dataSource count] == 0) {
                timeLabel.text = @"等待更多大神";
                flag = YES;
//                [self startAnimation];
            }else{
//                [self jisuan];
            }
        }
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
    
    static NSString *CellIdentifier = @"dashencell";
    DashenTableViewCell *cell = (DashenTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell= (DashenTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"DashenTableViewCell" owner:self options:nil]  lastObject];
    }
    
    NSDictionary *info = [dataSource objectAtIndex:indexPath.row];
    NSString *avatar = [info objectForKey:@"avatar"];
    NSString *user_name = [info objectForKey:@"user_name"];
    NSNumber *price = [info objectForKey:@"price"];
    NSNumber *hours = [_dingdanInfo objectForKey:@"hours"];
    
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
    [self showMyBottomView];
}

#pragma mark - my bottom view

-(void)initMyBottomView{
    self.myMaskView = [[UIView alloc] initWithFrame:kScreen_Frame];
    self.myMaskView.backgroundColor = [UIColor blackColor];
    self.myMaskView.alpha = 0.3;
    [self.myMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyBottomView)]];
    self.myBottomView.width = Main_Screen_Width;
    
    UITapGestureRecognizer *youhuiTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseYouhuijuan)];
    [self.chooseYouhui addGestureRecognizer:youhuiTap];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePayType:)];
    [self.yue addGestureRecognizer:tap];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePayType:)];
    [self.weixin addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePayType:)];
    [self.zhifubao addGestureRecognizer:tap3];
    
    payType = 1;
}

-(void)setPayInfo{
//    NSString *avatar = [userinfo objectForKey:@"avatar"];
//    [self.userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius = 5.0;
    
//    NSString *username = [userinfo objectForKey:@"user_name"];
//    self.username.text = username;
    
//    [self.zhifuButton setTitle:[NSString stringWithFormat:@"支付%.2f元",[total doubleValue]] forState:UIControlStateNormal];
}

#pragma mark - private method
- (void)showMyBottomView {
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [self setPayInfo];
    
    [self.view addSubview:self.myMaskView];
    [self.view addSubview:self.myBottomView];
    self.myMaskView.alpha = 0;
    self.myBottomView.top = self.view.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.myMaskView.alpha = 0.5;
        self.myBottomView.bottom = self.view.height;
    }];
}

- (void)hideMyBottomView {
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.myMaskView.alpha = 0;
        self.myBottomView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.myMaskView removeFromSuperview];
        [self.myBottomView removeFromSuperview];
    }];
}

//选择优惠劵
-(void)chooseYouhuijuan{
    ChooseYouhuiTableViewController *vc = [[ChooseYouhuiTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

-(void)setYouhuiInfo:(NSNotification *)text{
    DLog(@"%@",text.object);
    youhuiInfo = text.object;
    
    if (youhuiInfo != nil) {
//        NSNumber *total_fee = [youhuiInfo objectForKey:@"youhui_total_fee"];//满多少
////        NSString *price = [_youshenInfo objectForKey:@"price"];
////        NSNumber *total_price = [NSNumber numberWithDouble:[price doubleValue] * [shichang doubleValue]];
//        if ([total_price doubleValue] >= [total_fee doubleValue]) {
            NSNumber *discountprice = [youhuiInfo objectForKey:@"discountprice"];//金额
    self.youhuiNum.text = [NSString stringWithFormat:@"-%d元",[discountprice intValue]];
//            cell.detailTextLabel.text = [NSString stringWithFormat:@"-%d元",[discountprice intValue]];
//            cell.detailTextLabel.textColor = [UIColor blackColor];
//        }else{
//            cell.detailTextLabel.text = @"使用优惠劵";
//            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
//            youhuiInfo = nil;
//            discountprice = nil;
//            [self showHint:@"该优惠劵不满足使用条件"];
//        }
    }
        else{
            self.youhuiNum.text = @"不使用优惠劵";
//        cell.detailTextLabel.text = @"使用优惠劵";
//        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    
}

//支付类型
-(void)choosePayType:(UITapGestureRecognizer *)recognizer{
    if (recognizer.view.tag == 1) {
        [self.yueRightImage setImage:[UIImage imageNamed:@"iconfontgou"]];
        [self.weixinRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        [self.zhifubaoRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        payType = 1;
    }
    if (recognizer.view.tag == 2) {
        [self.yueRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        [self.weixinRightImage setImage:[UIImage imageNamed:@"iconfontgou"]];
        [self.zhifubaoRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        payType = 2;
    }
    if (recognizer.view.tag == 3) {
        [self.yueRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        [self.weixinRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        [self.zhifubaoRightImage setImage:[UIImage imageNamed:@"iconfontgou"]];
        payType = 3;
    }
}

- (IBAction)mycancel:(id)sender {
    [self hideMyBottomView];
}

- (IBAction)myensure:(id)sender {
    [self hideMyBottomView];
}

@end
