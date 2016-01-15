//
//  ChongzhiViewController.m
//  ypp
//
//  Created by Stephen Chin on 16/1/15.
//  Copyright © 2016年 weyida. All rights reserved.
//

#import "ChongzhiViewController.h"
#import "YuETableViewCell.h"

@interface ChongzhiViewController (){
    UIButton *choosedBtn;
    int payType;
    UIButton *btn1;
    UIButton *btn2;
    UIButton *btn3;
    UIButton *btn4;
    UIButton *btn5;
    UIButton *btn6;
    
    double price;
}

@end

@implementation ChongzhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    payType = 1;
    price = 100;
    [self.payBtn setBackgroundColor:RGBA(200,22,34,1)];
    [self.payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
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
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.mytableview setTableFooterView:v];
    
    self.mytableview.separatorColor = RGB(230, 230, 230);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 180;
    }else if(section == 2){
        return 20;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 180)];
//        view.backgroundColor = [UIColor redColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 50, 20)];
//        label.backgroundColor = [UIColor grayColor];
        label.text = @"充值";
        label.font = [UIFont systemFontOfSize:16];
        [view addSubview:label];
        [self addPriceBtn:view];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, 160, 150, 15)];
        label2.text = @"此充值仅为约完吧账户充值";
        label2.font = [UIFont systemFontOfSize:12];
        label2.textColor = RGB(160, 160, 160);
        [view addSubview:label2];
        return view;
    }
    if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 20)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, 20)];
        label.text = @"支付方式";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = RGB(160, 160, 160);
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 2;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"YuETableViewCell";
        YuETableViewCell *cell = (YuETableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil){
            cell= (YuETableViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"YuETableViewCell" owner:self options:nil]  lastObject];
        }
        return cell;
    }else if(indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
           
            cell.textLabel.font = [UIFont systemFontOfSize:16];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
            cell.detailTextLabel.textColor = [UIColor blackColor];
            cell.userInteractionEnabled = NO;
        }
        cell.textLabel.text = @"支付";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",price];
        return cell;
    }else if(indexPath.section == 2){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            
            cell.textLabel.font = [UIFont systemFontOfSize:16];
        }
        if (indexPath.row == 0) {
            cell.textLabel.text = @"支付宝";
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfontgou"]];
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"微信";
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        }
        
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        
        if (indexPath.row == 0) {
            payType = 1;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfontgou"]];
            
            NSIndexPath *index2 = [NSIndexPath indexPathForRow:1 inSection:2];
            UITableViewCell *cell2 = [tableView cellForRowAtIndexPath:index2];
            cell2.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        }else if (indexPath.row == 1){
            payType = 2;
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfontgou"]];
            
            NSIndexPath *index2 = [NSIndexPath indexPathForRow:0 inSection:2];
            UITableViewCell *cell2 = [tableView cellForRowAtIndexPath:index2];
            cell2.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        }
        
    }
    
}

-(void)addPriceBtn:(UIView *)view{
    CGFloat width = (Main_Screen_Width - 40) / 3;
    btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn1.backgroundColor = [UIColor whiteColor];
    [btn1 setFrame:CGRectMake(10, 46, width, 40)];
    [btn1 setTitle:@"30元" forState:UIControlStateNormal];
    btn1.layer.borderColor = RGB(220, 220, 220).CGColor;
    btn1.layer.borderWidth = 1.0;
    btn1.layer.masksToBounds = YES;
    btn1.layer.cornerRadius = 20;
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:16];
    btn1.tag = 1;
    [btn1 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn1];
    
    btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn2.backgroundColor = [UIColor whiteColor];
    [btn2 setFrame:CGRectMake(CGRectGetMaxX(btn1.frame) + 10, btn1.frame.origin.y, width, 40)];
    [btn2 setTitle:@"50元" forState:UIControlStateNormal];
    btn2.layer.borderColor = RGB(220, 220, 220).CGColor;
    btn2.layer.borderWidth = 1.0;
    btn2.layer.masksToBounds = YES;
    btn2.layer.cornerRadius = 20;
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:16];
    btn2.tag = 2;
    [btn2 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn2];
    
    btn3 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn3.backgroundColor = [UIColor whiteColor];
    [btn3 setFrame:CGRectMake(CGRectGetMaxX(btn2.frame) + 10, btn1.frame.origin.y, width, 40)];
    [btn3 setTitle:@"100元" forState:UIControlStateNormal];
    btn3.layer.borderColor = RGB(220, 220, 220).CGColor;
    [btn3 setBackgroundColor:RGBA(200,22,34,1)];
    [btn3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn3.layer.borderWidth = 0;
    btn3.layer.masksToBounds = YES;
    btn3.layer.cornerRadius = 20;
    btn3.titleLabel.font = [UIFont systemFontOfSize:16];
    btn3.tag = 3;
    [btn3 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn3];
    choosedBtn = btn3;
    
    btn4 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn4.backgroundColor = [UIColor whiteColor];
    [btn4 setFrame:CGRectMake(10, CGRectGetMaxY(btn1.frame) + 10, width, 40)];
    [btn4 setTitle:@"200元" forState:UIControlStateNormal];
    btn4.layer.borderColor = RGB(220, 220, 220).CGColor;
    btn4.layer.borderWidth = 1.0;
    btn4.layer.masksToBounds = YES;
    btn4.layer.cornerRadius = 20;
    [btn4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:16];
    btn4.tag = 4;
    [btn4 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn4];
    
    btn5 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn5.backgroundColor = [UIColor whiteColor];
    [btn5 setFrame:CGRectMake(CGRectGetMaxX(btn4.frame) + 10, CGRectGetMaxY(btn1.frame) + 10, width, 40)];
    [btn5 setTitle:@"500元" forState:UIControlStateNormal];
    btn5.layer.borderColor = RGB(220, 220, 220).CGColor;
    btn5.layer.borderWidth = 1.0;
    btn5.layer.masksToBounds = YES;
    btn5.layer.cornerRadius = 20;
    [btn5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn5.titleLabel.font = [UIFont systemFontOfSize:16];
    btn5.tag = 5;
    [btn5 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn5];
    
    btn6 = [UIButton buttonWithType:UIButtonTypeSystem];
    btn6.backgroundColor = [UIColor whiteColor];
    [btn6 setFrame:CGRectMake(CGRectGetMaxX(btn5.frame) + 10, CGRectGetMaxY(btn1.frame) + 10, width, 40)];
    [btn6 setTitle:@"1000元" forState:UIControlStateNormal];
    btn6.layer.borderColor = RGB(220, 220, 220).CGColor;
    btn6.layer.borderWidth = 1.0;
    btn6.layer.masksToBounds = YES;
    btn6.layer.cornerRadius = 20;
    [btn6 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn6.titleLabel.font = [UIFont systemFontOfSize:16];
    btn6.tag = 6;
    [btn6 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn6];
}

//点击按钮
-(void)clickBtn:(UIButton *)sender{
    DLog(@"%ld",(long)sender.tag);
    
    
    
    if (choosedBtn != nil) {
        [choosedBtn setBackgroundColor:[UIColor whiteColor]];
        [choosedBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        choosedBtn.layer.borderWidth = 1;
        choosedBtn = nil;
    }
    [sender setBackgroundColor:RGBA(200,22,34,1)];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sender.layer.borderWidth = 0;
    choosedBtn = sender;
    
    if (choosedBtn.tag == 1) {
        price = 30;
    }else if (choosedBtn.tag == 2){
        price = 50;
    }else if (choosedBtn.tag == 3){
        price = 100;
    }else if (choosedBtn.tag == 4){
        price = 200;
    }else if (choosedBtn.tag == 5){
        price = 500;
    }else if (choosedBtn.tag == 6){
        price = 1000;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    [_mytableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (IBAction)pay:(id)sender {
    DLog(@"%.2f",price);
    DLog(@"%d",payType);
}
@end
