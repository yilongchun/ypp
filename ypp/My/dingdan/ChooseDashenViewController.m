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
#import "WXApi.h"
#import "YYWebImage.h"
#import "NSDate+Addition.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"

@interface ChooseDashenViewController (){
    UILabel *topLabel;
    UILabel *timeLabel;
    NSMutableArray *dataSource;
    dispatch_source_t _timer;
    BOOL flag;
    
    int payType;//支付类型 1余额 2微信 3支付宝
    NSDictionary *youhuiInfo;//优惠信息
    NSIndexPath *selected;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getOrderPayResult:)   name:@"getOrderPayResult" object:nil];
    
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
    NSNumber *sex = [info objectForKey:@"sex"];
    DLog(@"%@",info);
    
    [cell.avatar yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholder:[UIImage imageNamed:@"gallery_default"] options:YYWebImageOptionSetImageWithFadeAnimation completion:nil];
    cell.username.text = user_name;
    cell.price.text = [NSString stringWithFormat:@"%d元",[price intValue] * [hours intValue]];
    cell.other.text = [NSString stringWithFormat:@"单价%d元/h",[price intValue]];
    if ([sex intValue] == 0) {
        [cell.sex setHidden:NO];
        [cell.sex setImage:[UIImage imageNamed:@"usercell_girl"]];
        NSNumber *byear = [info objectForKey:@"byear"];
        NSNumber *bmonth = [info objectForKey:@"bmonth"];
        NSNumber *bday = [info objectForKey:@"bday"];
        NSDate *birthday = [NSDate dateWithYear:[byear integerValue] month:[bmonth integerValue] day:[bday integerValue]];
        NSInteger age = [NSDate ageWithDateOfBirth:birthday];
        cell.age.text = [NSString stringWithFormat:@"%ld",(long)age];
    }else if ([sex intValue] == 1){
        [cell.sex setHidden:NO];
        [cell.sex setImage:[UIImage imageNamed:@"usercell_boy"]];
        NSNumber *byear = [info objectForKey:@"byear"];
        NSNumber *bmonth = [info objectForKey:@"bmonth"];
        NSNumber *bday = [info objectForKey:@"bday"];
        NSDate *birthday = [NSDate dateWithYear:[byear integerValue] month:[bmonth integerValue] day:[bday integerValue]];
        NSInteger age = [NSDate ageWithDateOfBirth:birthday];
        cell.age.text = [NSString stringWithFormat:@"%ld",(long)age];
    }else{
        [cell.sex setHidden:YES];
    }
    
//    NSNumber *distance = [info objectForKey:@"distance"];
//    NSString *dis = [NSString stringWithFormat:@"%.2fkm",[distance floatValue] / 1000];
//    cell.juli.text = [NSString stringWithFormat:@"%@",dis];
    
//    NSNumber *hotcount = [info objectForKey:@"hotcount"];
//    if (hotcount != nil) {
//        cell.hotCount.text = [NSString stringWithFormat:@"%d",[hotcount intValue]];
//    }else{
//        cell.hotCount.text = @"0";
//    }
    
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
    selected = indexPath;
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
    NSDictionary *info = [dataSource objectAtIndex:selected.row];
    NSString *avatar = [info objectForKey:@"avatar"];
    NSString *user_name = [info objectForKey:@"user_name"];
    
//    NSString *avatar = [userinfo objectForKey:@"avatar"];
    [self.userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius = 5.0;
    
//    NSString *username = [userinfo objectForKey:@"user_name"];
    self.username.text = user_name;
    
    NSNumber *price = [info objectForKey:@"price"];
    NSNumber *hours = [_dingdanInfo objectForKey:@"hours"];
    
    [self.zhifuButton setTitle:[NSString stringWithFormat:@"支付%d元",[price intValue] * [hours intValue]] forState:UIControlStateNormal];
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
    if (payType == 2) {//微信支付
        [self WeiXinPay];
    }
    if (payType == 3) {//支付宝
        [self AliPay];
    }
    [self hideMyBottomView];
}

#pragma mark - 支付宝

-(void)AliPay{
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = ALIPAY_PID;
    order.seller = ALIPAY_SELLER;
    order.tradeNO = @"123"; //订单ID（由商家自行制定）
    order.productName = @"1234"; //商品标题
    order.productDescription = @"12345"; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",0.01]; //商品价格
    order.notifyURL =  @"http://www.xxx.com"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"2016031701220292";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(ALIPAY_PRIVATE_KEY);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
}

#pragma mark - 微信支付
- (void)WeiXinPay{
    if([WXApi isWXAppInstalled]) // 判断 用户是否安装微信
    {
        
        [self showHudInView:self.view];
        
        
        NSDictionary *info = [dataSource objectAtIndex:selected.row];
        
        NSNumber *price = [info objectForKey:@"price"];
        NSNumber *hours = [_dingdanInfo objectForKey:@"hours"];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSDictionary *userinfo = [[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER];
        [param setObject:[userinfo objectForKey:@"id"] forKey:@"userId"];
        [param setObject:[_dingdanInfo objectForKey:@"id"] forKey:@"orderId"];
        [param setObject:[NSNumber numberWithInt:[price intValue] * [hours intValue]] forKey:@"orderPrice"];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,WX_PREPAY_URL];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
        [manager GET:urlString parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self hideHud];
            NSLog(@"JSON: %@", operation.responseString);
            
            NSString *result = [NSString stringWithFormat:@"%@",[operation responseString]];
            NSError *error;
            NSDictionary *dataDict= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
            if (dataDict == nil) {
                NSLog(@"json parse failed \r\n");
            }else{
                [self WXPayRequest:dataDict[@"appid"] nonceStr:dataDict[@"noncestr"] package:dataDict[@"package"] partnerId:dataDict[@"partnerid"] prepayId:dataDict[@"prepayid"] timeStamp:dataDict[@"timestamp"] sign:dataDict[@"sign"]];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"发生错误！%@",error);
            [self hideHud];
            [self showHint:@"连接失败"];
            
        }];
    }else{
        [self hideHud];
        [self alert:@"提示" msg:@"您未安装微信,请用其他支付方式!"];
    }
    
}
#pragma mark - 发起支付请求
- (void)WXPayRequest:(NSString *)appId nonceStr:(NSString *)nonceStr package:(NSString *)package partnerId:(NSString *)partnerId prepayId:(NSString *)prepayId timeStamp:(NSString *)timeStamp sign:(NSString *)sign{
    //调起微信支付
    PayReq* wxreq             = [[PayReq alloc] init];
    wxreq.openID              = WX_APP_ID;
    wxreq.partnerId           = partnerId;
    wxreq.prepayId            = prepayId;
    wxreq.nonceStr            = nonceStr;
    wxreq.timeStamp           = [timeStamp intValue];
    wxreq.package             = package;
    wxreq.sign                = sign;
    [WXApi sendReq:wxreq];
}

#pragma mark - 通知信息
- (void)getOrderPayResult:(NSNotification *)notification{
    if ([notification.object isEqualToString:@"success"])
    {
//        [HUD hide:YES];
//        [self alert:@"恭喜" msg:@"您已支付成功!"];
//        payStatusStr           = @"YES";
//        _successPayView.hidden = NO;
//        _toPayView.hidden      = YES;
//        [self creatPaySuccess];
        NSLog(@"支付成功");
        [self confirmyue];
    }
    else
    {
        NSLog(@"支付失败");
//        [HUD hide:YES];
//        [self alert:@"提示" msg:@"支付失败"];
        [self showHint:@"支付失败"];
//        [self confirmyue];
    }
}

//确认订单
-(void)confirmyue{
    [self showHudInView:self.view];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[_dingdanInfo objectForKey:@"id"] forKey:@"orderid"];
    
    NSDictionary *info = [dataSource objectAtIndex:selected.row];
    [parameters setValue:[info objectForKey:@"userid"] forKey:@"vipuserid"];//游神ID
    NSNumber *price = [info objectForKey:@"price"];
    NSNumber *hours = [_dingdanInfo objectForKey:@"hours"];
    
    NSNumber *payprice = [NSNumber numberWithInt:[price intValue] * [hours intValue]];
    
    [parameters setValue:payprice forKey:@"payprice"];//陪玩费用
    [parameters setValue:@"" forKey:@"couponid"];//优惠券id
    [parameters setValue:@"" forKey:@"coupon"];//优惠券名称
    [parameters setValue:@"" forKey:@"discountprice"];//优惠费用
    
    [parameters setValue:[NSNumber numberWithInt:[price intValue] * [hours intValue]] forKey:@"actualprice"];//支付金额
    if (payType == 2) {
        [parameters setValue:@"2" forKey:@"paymentid"];//支付类型（1支付宝、2微信）
        [parameters setValue:@"微信" forKey:@"paymentname"];//支付类型*/
    }else if (payType == 3){
        [parameters setValue:@"1" forKey:@"paymentid"];//支付类型（1支付宝、2微信）
        [parameters setValue:@"支付宝" forKey:@"paymentname"];//支付类型*/
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_CONFIRM_YUE];
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
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
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

//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
    [alter show];
}

@end
