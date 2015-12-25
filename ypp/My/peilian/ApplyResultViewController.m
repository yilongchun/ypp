//
//  ApplyResultViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/17.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "ApplyResultViewController.h"
#import "ApplyPlayerTableViewController.h"

@interface ApplyResultViewController ()

@end

@implementation ApplyResultViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //0默认 1审核中 2通过 3不通过
    if ([_resultCode isEqualToString:@"1"]) {
        _resultLabel.text = @"审核中";
        _msg1.text = @"请耐心等待结果，在此期间请认真阅读陪练帮助";
        _msg2.text = @"我们将在1-3天审核您的申请";
    }
    if ([_resultCode isEqualToString:@"3"]) {
        _resultLabel.text = @"审核未通过";
        _msg1.text = @"审核未通过，请重新提交申请";
        _msg2.text = @"请点击右上角重新申请";
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"重新申请" style:UIBarButtonItemStyleDone target:self action:@selector(reApply)];
        [rightItem setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

-(void)reApply{
    [self.navigationController popViewControllerAnimated:NO];
    NSNotification *notification2 =[NSNotification notificationWithName:@"toApply" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
