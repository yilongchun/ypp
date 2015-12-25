//
//  FabuyuewanViewController.m
//  ypp
//
//  Created by haidony on 15/11/13.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "FabuyuewanViewController.h"
#import "GameAndShopTableViewController.h"
#import "NSDate+Addition.h"
#import "NSDate+Extension.h"
#import "NSObject+Blocks.h"

@interface FabuyuewanViewController (){
    NSString *lineType;//线上线下
    NSString *gameid;//游戏id
    NSString *gamename;//游戏名称
    NSString *storeid;   //默认地点（选择城市下的门店）
    NSString *storename;  //默认地点（选择城市下的门店）
    NSNumber *sex;//性别
    NSString *startTime;//开始时间用于显示
    NSString *begin;//开始时间存数据库
    NSNumber *shichang;//时长
    
    
    int type;//1开始时间 2时长
    NSMutableArray *durationArr;//时长数组
    NSMutableArray *startTimeArr1;//现在 今天 明天 后天
    NSMutableArray *startTimeArr2;//小时
    NSMutableArray *startTimeArr3;//分钟
    int section;
    NSMutableArray *choosedBtn;
    
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    UIButton *btn5;
    UIButton *btn6;
    
    
}

@end

@implementation FabuyuewanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"我要约玩";
    
//    UIImage *backImage = [UIImage imageNamed:@"navi_back"];
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:backImage style:UIBarButtonItemStylePlain target:self action:@selector(back)];
//    [leftItem setTintColor:[UIColor whiteColor]];
//    self.navigationItem.leftBarButtonItem = leftItem;
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        //        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }

    if ([self.mytableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mytableview setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mytableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mytableview setLayoutMargins:UIEdgeInsetsZero];
    }
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.mytableview setTableFooterView:v];
    
    
//    536 90
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;

    UIButton *getCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, height- 60, width-20, 50)];
    [getCodeBtn setTitle:@"发布约单" forState:UIControlStateNormal];
    [getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [getCodeBtn setBackgroundImage:[UIImage imageNamed:@"blue_btn2"] forState:UIControlStateNormal];
    getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:19];
    [getCodeBtn addTarget:self action:@selector(fabu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:getCodeBtn];
    
    section = 1;
    [self initData];
    //初始化时长
    durationArr = [NSMutableArray array];
    for (int i = 1; i < 24; i++) {
        [durationArr addObject:[NSNumber numberWithInt:i]];
    }
    
    [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setValue:)
                                                 name:@"setValue" object:nil];
    
    
    choosedBtn = [NSMutableArray array];
    [self addBtn];
}

//添加按钮价格
-(void)addBtn{
    CGFloat width = (Main_Screen_Width - 40) / 3;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 20, 40)];
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"陪练价格";
    [label sizeToFit];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:3 inSection:0];
    UITableViewCell *cell = [self.mytableview cellForRowAtIndexPath:indexPath];
    [cell.contentView addSubview:label];
    
    btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn1 setFrame:CGRectMake(10, CGRectGetMaxY(label.frame) + 10, width, 40)];
    [btn1 setTitle:@"全部" forState:UIControlStateNormal];
    btn1.layer.borderColor = RGB(220, 220, 220).CGColor;
    btn1.layer.borderWidth = 1.0;
    btn1.layer.masksToBounds = YES;
    btn1.layer.cornerRadius = 20;
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:16];
    btn1.tag = 1;
    [btn1 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn1];
    
    btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn2 setFrame:CGRectMake(CGRectGetMaxX(btn1.frame) + 10, CGRectGetMaxY(label.frame) + 10, width, 40)];
    [btn2 setTitle:@"小清新39元" forState:UIControlStateNormal];
    btn2.layer.borderColor = RGB(220, 220, 220).CGColor;
    btn2.layer.borderWidth = 1.0;
    btn2.layer.masksToBounds = YES;
    btn2.layer.cornerRadius = 20;
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:16];
    btn2.tag = 2;
    [btn2 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn2];
    
    btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn3 setFrame:CGRectMake(CGRectGetMaxX(btn2.frame) + 10, CGRectGetMaxY(label.frame) + 10, width, 40)];
    [btn3 setTitle:@"柔情69元" forState:UIControlStateNormal];
    btn3.layer.borderColor = RGB(220, 220, 220).CGColor;
    btn3.layer.borderWidth = 1.0;
    btn3.layer.masksToBounds = YES;
    btn3.layer.cornerRadius = 20;
    [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:16];
    btn3.tag = 3;
    [btn3 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn3];
    
    btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn4 setFrame:CGRectMake(10, CGRectGetMaxY(btn1.frame) + 10, width, 40)];
    [btn4 setTitle:@"小资99元" forState:UIControlStateNormal];
    btn4.layer.borderColor = RGB(220, 220, 220).CGColor;
    btn4.layer.borderWidth = 1.0;
    btn4.layer.masksToBounds = YES;
    btn4.layer.cornerRadius = 20;
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:16];
    btn4.tag = 4;
    [btn4 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn4];
    
    btn5 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn5 setFrame:CGRectMake(CGRectGetMaxX(btn4.frame) + 10, CGRectGetMaxY(btn1.frame) + 10, width, 40)];
    [btn5 setTitle:@"优雅129元" forState:UIControlStateNormal];
    btn5.layer.borderColor = RGB(220, 220, 220).CGColor;
    btn5.layer.borderWidth = 1.0;
    btn5.layer.masksToBounds = YES;
    btn5.layer.cornerRadius = 20;
    [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn5.titleLabel.font = [UIFont systemFontOfSize:16];
    btn5.tag = 5;
    [btn5 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn5];
    
    btn6 = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn6 setFrame:CGRectMake(CGRectGetMaxX(btn5.frame) + 10, CGRectGetMaxY(btn1.frame) + 10, width, 40)];
    [btn6 setTitle:@"土豪199元" forState:UIControlStateNormal];
    btn6.layer.borderColor = RGB(220, 220, 220).CGColor;
    btn6.layer.borderWidth = 1.0;
    btn6.layer.masksToBounds = YES;
    btn6.layer.cornerRadius = 20;
    [btn6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn6.titleLabel.font = [UIFont systemFontOfSize:16];
    btn6.tag = 6;
    [btn6 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:btn6];
}

//点击按钮
-(void)clickBtn:(UIButton *)sender{
    DLog(@"%ld",(long)sender.tag);
    
    if (sender.tag == 1) {//全部
        
        [btn1 setBackgroundColor:RGB(52, 196, 51)];
        [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn1.layer.borderWidth = 0;
        
        [btn2 setBackgroundColor:[UIColor whiteColor]];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn2.layer.borderWidth = 1;
        
        [btn3 setBackgroundColor:[UIColor whiteColor]];
        [btn3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn3.layer.borderWidth = 1;
        
        [btn4 setBackgroundColor:[UIColor whiteColor]];
        [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn4.layer.borderWidth = 1;
        
        [btn5 setBackgroundColor:[UIColor whiteColor]];
        [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn5.layer.borderWidth = 1;
        
        [btn6 setBackgroundColor:[UIColor whiteColor]];
        [btn6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn6.layer.borderWidth = 1;
        
        [choosedBtn removeAllObjects];
        [choosedBtn addObject:btn1];
    }else{
        
        if ([choosedBtn containsObject:btn1]) {
            [btn1 setBackgroundColor:[UIColor whiteColor]];
            [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn1.layer.borderWidth = 1;
            [choosedBtn removeObject:btn1];
        }
        
        if ([choosedBtn containsObject:sender]) {
            [sender setBackgroundColor:[UIColor whiteColor]];
            [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            sender.layer.borderWidth = 1;
            [choosedBtn removeObject:sender];
        }else{
            [sender setBackgroundColor:RGB(52, 196, 51)];
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            sender.layer.borderWidth = 0;
            [choosedBtn addObject:sender];
        }
    }
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

- (void)setValue:(NSNotification *)text{
    
    NSString *column = text.userInfo[@"column"];
    NSString *columnValue = text.userInfo[@"columnValue"];
    
    if ([column isEqualToString:@"gameid"]) {//游戏id
        gameid = columnValue;
    }
    if ([column isEqualToString:@"gamename"]) {//游戏名称
        gamename = columnValue;
    }
    if ([column isEqualToString:@"storeid"]) {//地点id
        storeid = columnValue;
    }
    if ([column isEqualToString:@"storename"]) {//地点名称
        storename = columnValue;
    }
    
    [self.mytableview reloadData];
}

//发布约玩
-(void)fabu{
    NSLog(@"发布约玩 %@",choosedBtn);
    
    if (lineType == nil || [lineType isEqualToString:@""]) {
        [self showHint:@"请选择线上线下"];
        return;
    }
    if (gamename == nil || [gamename isEqualToString:@""]) {
        [self showHint:@"请选择游戏"];
        return;
    }
    if (sex == nil) {
        [self showHint:@"请选择性别"];
        return;
    }
    if([choosedBtn count] == 0){
        [self showHint:@"请选择价格"];
        return;
    }
    if ([lineType isEqualToString:@"线下"]) {
        if (storename == nil || [storename isEqualToString:@""]) {
            [self showHint:@"请选择地点"];
            return;
        }
    }
    
    if (begin == nil || [begin isEqualToString:@""]) {
        [self showHint:@"请选择开始时间"];
        return;
    }
    if (shichang == nil) {
        [self showHint:@"请选择时长"];
        return;
    }
    
    [self showHudInView:self.view];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"] forKey:@"userid"];
    if ([lineType isEqualToString:@"线上"]) {
        [parameters setValue:@"1" forKey:@"isline"];//线下0 ，线上1
    }else{
        [parameters setValue:@"0" forKey:@"isline"];//线下0 ，线上1
    }
    [parameters setValue:gameid forKey:@"gameid"];
    [parameters setValue:gamename forKey:@"gamename"];
    [parameters setValue:sex forKey:@"sex"];//游神性别
    
    NSMutableArray *priceArr = [NSMutableArray array];
    
    if ([choosedBtn containsObject:btn1]) {
        
        [parameters setValue:@"" forKey:@"price"];//陪玩单价
    }else{
        if ([choosedBtn containsObject:btn2]) {
            [priceArr addObject:@"39"];
        }
        if ([choosedBtn containsObject:btn3]) {
            [priceArr addObject:@"69"];
        }
        if ([choosedBtn containsObject:btn4]) {
            [priceArr addObject:@"99"];
        }
        if ([choosedBtn containsObject:btn5]) {
            [priceArr addObject:@"129"];
        }
        if ([choosedBtn containsObject:btn6]) {
            [priceArr addObject:@"199"];
        }
        [parameters setValue:[priceArr componentsJoinedByString:@","] forKey:@"price"];//陪玩单价
    }
    
//    for (int i = 0; i < choosedBtn.count; i++) {
//        [priceArr addObject:[(UIButton *)[choosedBtn objectAtIndex:i] currentTitle]];
//    }
    
    [parameters setValue:storeid forKey:@"storeid"];
    if ([lineType isEqualToString:@"线下"]) {
     [parameters setValue:storename forKey:@"storename"];//陪玩地点（线下）
    }
    [parameters setValue:begin forKey:@"begin"];//开始时间
    [parameters setValue:shichang forKey:@"hours"];//陪玩时长
    DLog(@"%@",parameters);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_YUE];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 150;
    }
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (lineType != nil && [lineType isEqualToString:@"线下"]) {
        return 7;
    }
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {//换成选项 线上 线下
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        }
        cell.textLabel.text = @"线上线下";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (lineType != nil) {
            cell.detailTextLabel.text = lineType;
            cell.detailTextLabel.textColor = [UIColor blackColor];
        }else{
            cell.detailTextLabel.text = @"请选择";
        }
        return cell;
    }else if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        }
        cell.textLabel.text = @"游戏类别";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (gameid != nil) {
            cell.detailTextLabel.text = gamename;
            cell.detailTextLabel.textColor = [UIColor blackColor];
        }else{
            cell.detailTextLabel.text = @"选择游戏";
        }
        return cell;
    }else if (indexPath.row == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
        }
        
        cell.textLabel.text = @"陪练性别";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (sex != nil) {
            if ([sex intValue] == 1) {
                cell.detailTextLabel.text = @"男";
            }else if ([sex intValue] == 0) {
                cell.detailTextLabel.text = @"女";
            }else if ([sex intValue] == 2) {
                cell.detailTextLabel.text = @"不限";
            }
            cell.detailTextLabel.textColor = [UIColor blackColor];
        }else{
            cell.detailTextLabel.text = @"请选择";
        }
        return cell;
    }
    else if(indexPath.row == 3){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    if (lineType != nil && [lineType isEqualToString:@"线下"]) {
        if (indexPath.row == 4){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
            }
            
            cell.textLabel.text = @"陪练地点";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (storeid != nil) {
                cell.detailTextLabel.text = storename;
                cell.detailTextLabel.textColor = [UIColor blackColor];
            }else{
                cell.detailTextLabel.text = @"选择陪练地点";
            }
            return cell;
        }
        if (indexPath.row == 5){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
            }
            
            cell.textLabel.text = @"开始时间";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (startTime != nil) {
                cell.detailTextLabel.text = startTime;
                cell.detailTextLabel.textColor = [UIColor blackColor];
            }else{
                cell.detailTextLabel.text = @"选择陪练时间";
            }
            return cell;
        }else if (indexPath.row == 6){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
            }
            cell.textLabel.text = @"陪练时长";
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (shichang != nil) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d小时",[shichang intValue]];
                cell.detailTextLabel.textColor = [UIColor blackColor];
            }else{
                cell.detailTextLabel.text = @"选择陪练时长";
            }
            return cell;
        }
    }else{
        if (indexPath.row == 4){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
            }
            
            cell.textLabel.text = @"开始时间";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (startTime != nil) {
                cell.detailTextLabel.text = startTime;
                cell.detailTextLabel.textColor = [UIColor blackColor];
            }else{
                cell.detailTextLabel.text = @"选择陪练时间";
            }
            return cell;
        }else if (indexPath.row == 5){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
                cell.textLabel.font = [UIFont systemFontOfSize:16];
                cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
            }
            cell.textLabel.text = @"陪练时长";
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (shichang != nil) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d小时",[shichang intValue]];
                cell.detailTextLabel.textColor = [UIColor blackColor];
            }else{
                cell.detailTextLabel.text = @"选择陪练时长";
            }
            return cell;
        }
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
    if (indexPath.row == 0) {//线上线下
        [self chooseLineUpAndDown];
    }else if (indexPath.row == 1){//游戏
        GameAndShopTableViewController *vc = [[GameAndShopTableViewController alloc] init];
        vc.type = 1;
        vc.title = @"选择游戏";
        vc.columnId = @"gameid";
        vc.columnIdValue = gameid;
        vc.column = @"gamename";
        vc.columnValue = gamename;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2){//选择性别
        [self chooseSex];
    }
    
    if (lineType != nil && [lineType isEqualToString:@"线下"]) {
        if (indexPath.row == 4){//选择地点
            GameAndShopTableViewController *vc = [[GameAndShopTableViewController alloc] init];
            vc.type = 2;
            vc.title = @"选择地点";
            vc.columnId = @"storeid";
            vc.columnIdValue = storeid;
            vc.column = @"storename";
            vc.columnValue = storename;
            [self.navigationController pushViewController:vc animated:YES];
        }else if (indexPath.row == 5){//选择时间
            type = 1;
            [self.myPicker reloadAllComponents];
            [self showMyPicker];
        }else if (indexPath.row == 6){//选择时长
            type = 2;
            [self.myPicker reloadAllComponents];
            [self showMyPicker];
        }
    }else{
        if (indexPath.row == 4){//选择时间
            type = 1;
            [self.myPicker reloadAllComponents];
            [self showMyPicker];
        }else if (indexPath.row == 5){//选择时长
            type = 2;
            [self.myPicker reloadAllComponents];
            [self showMyPicker];
        }
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

/**
 *  选择性别
 */
-(void)chooseSex{
    UIAlertController *sexAlert = [UIAlertController alertControllerWithTitle:@"请选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sex = [NSNumber numberWithInt:1];
        [self.mytableview reloadData];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sex = [NSNumber numberWithInt:0];
        [self.mytableview reloadData];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"不限" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sex = [NSNumber numberWithInt:2];
        [self.mytableview reloadData];
    }];
    [sexAlert addAction:action1];
    [sexAlert addAction:action2];
    [sexAlert addAction:action3];
    [self presentViewController:sexAlert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (type == 1) {
//        if ([pickerView selectedRowInComponent:0] == 0) {
//            return 1;
//        }
        return section;
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
            section = 1;
            [self.myPicker reloadAllComponents];
        }else{
            [self initData];
            section = 3;
            [self.myPicker reloadAllComponents];
        }
    }
}

#pragma mark - init view
- (void)initView {
    self.maskView = [[UIView alloc] initWithFrame:Application_Frame];
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
        DLog(@"%@",begin);
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
