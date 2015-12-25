//
//  DingdanDetailTableViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/25.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "DingdanDetailTableViewController.h"
#import "NSDate+Extension.h"

@interface DingdanDetailTableViewController ()

@end

@implementation DingdanDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单详情";
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    
    
    
    
    
    
    
    switch (indexPath.row) {
        case 0:{
            NSString *isline = [_info objectForKey:@"isline"];
            cell.textLabel.text = @"类别";
            if ([isline isEqualToString:@"1"]) {//线上
                cell.detailTextLabel.text = @"线上";
            }else{//线下
                cell.detailTextLabel.text = @"线下";
            }
        }
            break;
        case 1:{
            cell.textLabel.text = @"性别";
            NSNumber *sex = [_info objectForKey:@"sex"];
            if ([sex intValue] == 1) {
                cell.detailTextLabel.text = @"男";
            }else if ([sex intValue] == 0) {
                cell.detailTextLabel.text = @"女";
            }else if ([sex intValue] == 2) {
                cell.detailTextLabel.text = @"不限";
            }
        }
            break;
        case 2:{
            cell.textLabel.text = @"单价";
            NSString *price = [_info objectForKey:@"price"];
            if ([price isEqualToString:@""]) {
                cell.detailTextLabel.text = @"全部";
            }else{
                NSArray *priceArr = [price componentsSeparatedByString:@","];
                NSMutableArray *displayPriceArr = [NSMutableArray array];
                for (NSString *s in priceArr) {
                    [displayPriceArr addObject:[NSString stringWithFormat:@"%@元",s]];
                }
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[displayPriceArr componentsJoinedByString:@","]];
                
            }
            
        }
            break;
        case 3:{
            NSString *begin = [_info objectForKey:@"begin"];//2015-12-26 12:00
            NSString *hours = [_info objectForKey:@"hours"];
            NSDate *beginDate = [NSDate dateWithString:begin format:@"yyyy-MM-dd hh:mm"];
            NSDate *endDate = [beginDate offsetHours:[hours intValue]];
            cell.textLabel.text = @"时间";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@~%@",[beginDate stringWithFormat:@"MM月dd日"],[beginDate stringWithFormat:@"hh:mm"],[endDate stringWithFormat:@"hh:mm"]];
        }
            break;
        case 4:{
            NSString *storename = [_info objectForKey:@"storename"];
            cell.textLabel.text = @"地点";
            cell.detailTextLabel.text = storename;
        }
            break;
        default:
            break;
    }
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
