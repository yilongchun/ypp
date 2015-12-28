//
//  YueTaViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/23.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "YueTaViewController.h"
#import "YueTaTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "GameAndShopTableViewController.h"
#import "NSDate+Addition.h"
#import "NSDate+Extension.h"
#import "ChooseYouhuiTableViewController.h"
#import "NSObject+Blocks.h"

@interface YueTaViewController (){
    UIButton *applyBtn;
    
    NSString *lineType;//线上线下
    NSString *storeid;   //默认地点（选择城市下的门店）
    NSString *storename;  //默认地点（选择城市下的门店）
    
    NSString *startTime;//开始时间显示
    NSString *begin;//开始时间存数据库
    NSNumber *shichang;//时长
    NSNumber *total;//总共
    
    int type;//1开始时间 2时长
    NSMutableArray *durationArr;//时长数组
    NSMutableArray *startTimeArr1;//现在 今天 明天 后天
    NSMutableArray *startTimeArr2;//小时
    NSMutableArray *startTimeArr3;//分钟
    int picksection;
    
    NSDictionary *youhuiInfo;//优惠信息
    NSNumber *discountprice;//优惠金额
}

@end

@implementation YueTaViewController
@synthesize userinfo;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"约TA";
    
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
    
    picksection = 1;
    [self initData];
    //初始化时长
    durationArr = [NSMutableArray array];
    for (int i = 1; i < 24; i++) {
        [durationArr addObject:[NSNumber numberWithInt:i]];
    }
    
    [self initView];
    [self initMyBottomView];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setValue:)
                                                 name:@"setValue" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setYouhuiInfo:)   name:@"setYouhuiInfo" object:nil];

}

-(void)dealloc{
    [[NSNotificationCenter  defaultCenter] removeObserver:self  name:@"setYouhuiInfo" object:nil];
}

-(void)initData{
    //初始化开始时间
    startTimeArr1 = [NSMutableArray arrayWithObjects:@"现在",@"今天",@"明天",@"后天", nil];
    startTimeArr2 = [NSMutableArray array];
    startTimeArr3 = [NSMutableArray array];
    
    for (int i = 1; i < 24; i++) {
        [startTimeArr2 addObject:[NSNumber numberWithInt:i]];
    }
    for (int i = 0; i < 4; i++) {
        [startTimeArr3 addObject:[NSNumber numberWithInt:i * 15]];
    }
    
}

/**
 * 选择线上线下
 */
-(void)chooseLineUpAndDown{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"线上" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        lineType = @"线上";
        [self.mytableview reloadData];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"线下" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        lineType = @"线下";
        [self.mytableview reloadData];
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)setYouhuiInfo:(NSNotification *)text{
    DLog(@"%@",text.object);
    youhuiInfo = text.object;
    if (youhuiInfo == nil) {
        discountprice = nil;
    }
    [self.mytableview reloadData];
}

- (void)setValue:(NSNotification *)text{
    
    NSString *column = text.userInfo[@"column"];
    NSString *columnValue = text.userInfo[@"columnValue"];
    
    if ([column isEqualToString:@"storeid"]) {//地点id
        storeid = columnValue;
    }
    if ([column isEqualToString:@"storename"]) {//地点名称
        storename = columnValue;
    }
    
    [self.mytableview reloadData];
}

/**
 *  提交订单
 */
-(void)save{
    
    [self showMyBottomView];
    return;
    
    if (lineType == nil) {
        [self showHint:@"请选择线上线下"];
        return;
    }
    if (storeid == nil) {
        [self showHint:@"请选择陪练地点"];
        return;
    }
    if (begin == nil) {
        [self showHint:@"请选择陪练时间"];
        return;
    }
    if (shichang == nil) {
        [self showHint:@"请选择陪练时长"];
        return;
    }
    
    [self showHudInView:self.view];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"] forKey:@"userid"];
    [parameters setValue:[_youshenInfo objectForKey:@"id"] forKey:@"vipuserid"];
    
    if ([lineType isEqualToString:@"线上"]) {
        [parameters setValue:@"1" forKey:@"isline"];//线下0 ，线上1
    }else{
        [parameters setValue:@"0" forKey:@"isline"];//线下0 ，线上1
    }
    
    
    [parameters setValue:storeid forKey:@"storied"];
    [parameters setValue:storename forKey:@"storename"];
    [parameters setValue:begin forKey:@"begin"];
    [parameters setValue:shichang forKey:@"hours"];
    NSString *price = [_youshenInfo objectForKey:@"price"];
    
    [parameters setValue:[NSNumber numberWithDouble:[price doubleValue] *  [shichang intValue]] forKey:@"payprice"];
    if (discountprice == nil) {
        [parameters setValue:[NSNumber numberWithDouble:0] forKey:@"discountprice"];
    }else{
        [parameters setValue:[NSNumber numberWithDouble:[discountprice doubleValue]] forKey:@"discountprice"];
    }
    
    [parameters setValue:[NSNumber numberWithDouble:[total doubleValue]] forKey:@"actualprice"];
    [parameters setValue:@"1" forKey:@"paymentid"];//支付方式
    DLog(@"%@",parameters);

    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_YUETA];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self hideHud];
        NSLog(@"JSON: %@", operation.responseString);
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == ResultCodeSuccess) {
                NSString *message = [dic objectForKey:@"message"];
                [self showHint:message];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - uitableview delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 2){
        return 10;
    }
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 130;
    }
    if (indexPath.section == 2 && indexPath.row == 3) {
        return 70;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 4;
    }
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"yuetacell";
        YueTaTableViewCell *cell = (YueTaTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell= (YueTaTableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"YueTaTableViewCell" owner:self options:nil]  lastObject];
        }
        NSString *avatar = [userinfo objectForKey:@"avatar"];
        [cell.userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
        cell.userImage.layer.masksToBounds = YES;
        cell.userImage.layer.cornerRadius = 5.0;
        
        NSString *username = [userinfo objectForKey:@"user_name"];
        cell.usernameLabel.text = username;
        
        NSString *is_daren = [userinfo objectForKey:@"is_daren"];//0默认 1审核中 2通过 3不通过
        if ([is_daren isEqualToString:@"2"]) {//审核通过
            [cell.darenImage setHidden:NO];
        }else{
            [cell.darenImage setHidden:YES];
        }
        
        return cell;
    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        }
        switch (indexPath.row) {
            case 0:{
                cell.textLabel.text = @"线上线下";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (lineType != nil) {
                    cell.detailTextLabel.text = lineType;
                    cell.detailTextLabel.textColor = [UIColor blackColor];
                }else{
                    cell.detailTextLabel.text = @"请选择";
                }
            }
                break;
            case 1:{
                cell.textLabel.text = @"陪练地点";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (storeid != nil) {
                    cell.detailTextLabel.text = storename;
                    cell.detailTextLabel.textColor = [UIColor blackColor];
                }else{
                    cell.detailTextLabel.text = @"选择陪练地点";
                }
            }
                break;
            case 2:{
                cell.textLabel.text = @"开始时间";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (startTime != nil) {
                    cell.detailTextLabel.text = startTime;
                    cell.detailTextLabel.textColor = [UIColor blackColor];
                }else{
                    cell.detailTextLabel.text = @"选择陪练时间";
                }
            }
                break;
            case 3:{
                cell.textLabel.text = @"陪练时长";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (shichang != nil) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%d小时",[shichang intValue]];
                    cell.detailTextLabel.textColor = [UIColor blackColor];
                }else{
                    cell.detailTextLabel.text = @"选择陪练时长";
                }
            }
                break;
            default:
                break;
        }
        return cell;
    }else if (indexPath.section == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        }
        switch (indexPath.row) {
            case 0:{
                cell.textLabel.text = @"陪练费用";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSString *price = [_youshenInfo objectForKey:@"price"];
                if (shichang == nil) {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",price];
                    cell.detailTextLabel.textColor = [UIColor blackColor];
                }else{
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元*%d",price,[shichang intValue]];
                    cell.detailTextLabel.textColor = [UIColor blackColor];
                }
            }
                break;
            case 1:{
                cell.textLabel.text = @"优惠费用";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                if (youhuiInfo != nil) {
                    NSNumber *total_fee = [youhuiInfo objectForKey:@"youhui_total_fee"];//满多少
                    NSString *price = [_youshenInfo objectForKey:@"price"];
                    NSNumber *total_price = [NSNumber numberWithDouble:[price doubleValue] * [shichang doubleValue]];
                    if ([total_price doubleValue] >= [total_fee doubleValue]) {
                        discountprice = [youhuiInfo objectForKey:@"discountprice"];//金额
                        cell.detailTextLabel.text = [NSString stringWithFormat:@"-%d元",[discountprice intValue]];
                        cell.detailTextLabel.textColor = [UIColor blackColor];
                    }else{
                        cell.detailTextLabel.text = @"使用优惠劵";
                        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                        youhuiInfo = nil;
                        discountprice = nil;
                        [self showHint:@"该优惠劵不满足使用条件"];
                    }
                }else{
                    cell.detailTextLabel.text = @"使用优惠劵";
                    cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                }
            }
                break;
            case 2:{
                cell.textLabel.text = @"总共";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                NSString *price = [_youshenInfo objectForKey:@"price"];
                if (shichang == nil) {
                    total = [NSNumber numberWithDouble:[price doubleValue]];
                    
                    if (discountprice != nil) {
                        total = [NSNumber numberWithDouble:[total doubleValue] - [discountprice doubleValue]];
                    }
                    
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",[total doubleValue]];
                    cell.detailTextLabel.textColor = [UIColor blackColor];
                }else{
                    total = [NSNumber numberWithDouble:[price doubleValue] * [shichang doubleValue]];
                    if (discountprice != nil) {
                        total = [NSNumber numberWithDouble:[total doubleValue] - [discountprice doubleValue]];
                    }
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f元",[total doubleValue]];
                    cell.detailTextLabel.textColor = [UIColor blackColor];
                }
                
            }
                break;
            case 3:{
                if (applyBtn == nil) {
                    applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    [applyBtn setTitle:@"提交订单" forState:UIControlStateNormal];
                    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [applyBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
                    UIImage *backgroundImage = [[UIImage imageNamed:@"blue_btn2"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
                    [applyBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
                    [applyBtn setFrame:CGRectMake(15, 10, Main_Screen_Width - 30, 50)];
                    [applyBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
                    [cell.contentView addSubview:applyBtn];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            default:
                break;
        }
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self chooseLineUpAndDown];
        }
        if (indexPath.row == 1) {//地点
            GameAndShopTableViewController *vc = [[GameAndShopTableViewController alloc] init];
            vc.type = 2;
            vc.title = @"选择地点";
            vc.columnId = @"storeid";
            vc.columnIdValue = storeid;
            vc.column = @"storename";
            vc.columnValue = storename;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if (indexPath.row == 2) {//开始
            type = 1;
            [self.myPicker reloadAllComponents];
            [self showMyPicker];
        }
        if (indexPath.row == 3) {//时长
            type = 2;
            [self.myPicker reloadAllComponents];
            [self showMyPicker];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 1) {//优惠劵
            ChooseYouhuiTableViewController *vc = [[ChooseYouhuiTableViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (type == 1) {
        //        if ([pickerView selectedRowInComponent:0] == 0) {
        //            return 1;
        //        }
        return picksection;
    }else if (type == 2){
        return 1;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (type == 1) {
        if (component == 0) {
            return [startTimeArr1 count];
        }
        if (component == 1) {
            return [startTimeArr2 count];
        }
        if (component == 2) {
            return [startTimeArr3 count];
        }
        return 0;
    }else if (type == 2){
        return [durationArr count];
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (type == 1) {
        if (component == 0) {
            return [startTimeArr1 objectAtIndex:row];
        }
        if (component == 1) {
            return [NSString stringWithFormat:@"%d",[[startTimeArr2 objectAtIndex:row] intValue]];
        }
        if (component == 2) {
            return [NSString stringWithFormat:@"%d",[[startTimeArr3 objectAtIndex:row] intValue]];
        }
        return @"";
    }else if (type == 2){
        NSNumber *duration = [durationArr objectAtIndex:row];
        NSString *str = [NSString stringWithFormat:@"%d小时",[duration intValue]];
        
        return str;
    }
    return @"";
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
//    if (type == 1) {
//        if (component == 0){
//            return (Main_Screen_Width - 90) / 2;
//        }
//        if (component == 1) {
//            return 60;
//        }
//        return (Main_Screen_Width - 90) / 2;
//    }
//    if (type == 2) {
//        return Main_Screen_Width;
//    }
//    return 0.0;
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (type == 1) {
        if (component == 0 && row == 0) {
            [startTimeArr2 removeAllObjects];
            [startTimeArr3 removeAllObjects];
            picksection = 1;
            [self.myPicker reloadAllComponents];
        }else{
            [self initData];
            picksection = 3;
            [self.myPicker reloadAllComponents];
        }
    }
}

#pragma mark - my bottom view

-(void)initMyBottomView{
    self.myMaskView = [[UIView alloc] initWithFrame:kScreen_Frame];
    self.myMaskView.backgroundColor = [UIColor blackColor];
    self.myMaskView.alpha = 0.3;
    [self.myMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyBottomView)]];
    self.myBottomView.width = Main_Screen_Width;
    
    
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePayType:)];
    [self.yue addGestureRecognizer:tap];
    
    
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePayType:)];
    [self.weixin addGestureRecognizer:tap2];
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePayType:)];
    [self.zhifubao addGestureRecognizer:tap3];
}

-(void)setPayInfo{
    NSString *avatar = [userinfo objectForKey:@"avatar"];
    [self.userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",QINIU_IMAGE_URL,avatar]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
    self.userImage.layer.masksToBounds = YES;
    self.userImage.layer.cornerRadius = 5.0;
    
    NSString *username = [userinfo objectForKey:@"user_name"];
    self.username.text = username;
    
    [self.zhifuButton setTitle:[NSString stringWithFormat:@"支付%.2f元",[total doubleValue]] forState:UIControlStateNormal];
}

#pragma mark - private method
- (void)showMyBottomView {
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
    [UIView animateWithDuration:0.3 animations:^{
        self.myMaskView.alpha = 0;
        self.myBottomView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.myMaskView removeFromSuperview];
        [self.myBottomView removeFromSuperview];
    }];
}

-(void)choosePayType:(UITapGestureRecognizer *)recognizer{
    if (recognizer.view.tag == 1) {
        [self.yueRightImage setImage:[UIImage imageNamed:@"iconfontgou"]];
        [self.weixinRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        [self.zhifubaoRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
    }
    if (recognizer.view.tag == 2) {
        [self.yueRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        [self.weixinRightImage setImage:[UIImage imageNamed:@"iconfontgou"]];
        [self.zhifubaoRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
    }
    if (recognizer.view.tag == 3) {
        [self.yueRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        [self.weixinRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        [self.zhifubaoRightImage setImage:[UIImage imageNamed:@"iconfontgou"]];
    }
}

- (IBAction)mycancel:(id)sender {
    [self hideMyBottomView];
}

- (IBAction)myensure:(id)sender {
    [self hideMyBottomView];
}

#pragma mark - init view
- (void)initView {
    self.maskView = [[UIView alloc] initWithFrame:kScreen_Frame];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.3;
    [self.maskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMyPicker)]];
    self.pickerBgView.width = Main_Screen_Width;
}

#pragma mark - private method
- (void)showMyPicker {
    [self.view addSubview:self.maskView];
    [self.view addSubview:self.pickerBgView];
    self.maskView.alpha = 0;
    self.pickerBgView.top = self.view.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0.3;
        self.pickerBgView.bottom = self.view.height;
    }];
}

- (void)hideMyPicker {
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 0;
        self.pickerBgView.top = self.view.height;
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        [self.pickerBgView removeFromSuperview];
    }];
}

#pragma mark - xib click

- (IBAction)cancel:(id)sender {
    [self hideMyPicker];
}

- (IBAction)ensure:(id)sender {
    if (type == 1) {
        if ([self.myPicker selectedRowInComponent:0] == 0) {
            NSString *startTime1 = [startTimeArr1 objectAtIndex:[self.myPicker selectedRowInComponent:0]];
            startTime = startTime1;
            DLog(@"%@",startTime1);
            NSString *currentDateStr = [NSDate currentDateStringWithFormat:@"yyyy-MM-dd hh:mm"];
            begin = currentDateStr;
        }else{
            NSString *startTime1 = [startTimeArr1 objectAtIndex:[self.myPicker selectedRowInComponent:0]];
            NSNumber *startTime2 = [startTimeArr2 objectAtIndex:[self.myPicker selectedRowInComponent:1]];
            NSNumber *startTime3 = [startTimeArr3 objectAtIndex:[self.myPicker selectedRowInComponent:2]];
            
            if ([self.myPicker selectedRowInComponent:0] == 1) {//今天
                startTime1 = [NSDate currentDateStringWithFormat:@"yyyy-MM-dd"];
            }
            if ([self.myPicker selectedRowInComponent:0] == 2) {//明天
                startTime1 = [NSDate stringWithDate:[[NSDate date] dateByAddingDays:1] format:@"yyyy-MM-dd"];
            }
            if ([self.myPicker selectedRowInComponent:0] == 3) {//后天
                startTime1 = [NSDate stringWithDate:[[NSDate date] dateByAddingDays:2] format:@"yyyy-MM-dd"];
            }
            DLog(@"%@",startTime1);
            DLog(@"%02d",[startTime2 intValue]);
            DLog(@"%02d",[startTime3 intValue]);
            
            startTime = [NSString stringWithFormat:@"%@ %02d:%02d",startTime1,[startTime2 intValue],[startTime3 intValue]];
            begin = startTime;
        }
        [self hideMyPicker];
        
        [self.mytableview reloadData];
    }
    if (type == 2) {
        NSNumber *duration = [durationArr objectAtIndex:[self.myPicker selectedRowInComponent:0]];
        shichang = duration;
        [self hideMyPicker];
        [self.mytableview reloadData];
    }
}

@end
