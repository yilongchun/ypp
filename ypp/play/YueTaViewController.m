//
//  YueTaViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/23.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "YueTaViewController.h"
#import "YueTaTableViewCell.h"

@interface YueTaViewController (){
    UIButton *applyBtn;
}

@end

@implementation YueTaViewController

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
//    UIButton *applyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [applyBtn setTitle:@"提交订单" forState:UIControlStateNormal];
//    [applyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [applyBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
//    UIImage *backgroundImage = [[UIImage imageNamed:@"blue_btn2"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
//    [applyBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
//    [applyBtn setFrame:CGRectMake(15, 10, Main_Screen_Width - 30, 50)];
//    [applyBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
//    UIView *tableFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 70)];
//    [tableFootView addSubview:applyBtn];
//    tableFootView.backgroundColor = [UIColor whiteColor];
//    [self.mytableview setTableFooterView:tableFootView];

}

-(void)save{
    
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
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 3;
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
        return cell;
    }else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        }
        switch (indexPath.row) {
            case 0:{
                cell.textLabel.text = @"陪练地点";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = @"请选择";
            }
                break;
            case 1:{
                cell.textLabel.text = @"开始时间";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = @"请选择陪练时间";
            }
                break;
            case 2:{
                cell.textLabel.text = @"陪练时长";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = @"请选择陪练时长";
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
        }
        switch (indexPath.row) {
            case 0:{
                cell.textLabel.text = @"陪练费用";
                
            }
                break;
            case 1:{
                cell.textLabel.text = @"优惠费用";
                
            }
                break;
            case 2:{
                cell.textLabel.text = @"总共";
                
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
}

@end
