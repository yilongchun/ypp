//
//  MyAccountViewController.m
//  ypp
//
//  Created by Stephen Chin on 16/1/15.
//  Copyright © 2016年 weyida. All rights reserved.
//

#import "MyAccountViewController.h"
#import "ChongzhiViewController.h"

@interface MyAccountViewController ()

@end

@implementation MyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"blue_btn2"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    [_chongzhiBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    
    _tixianBtn.layer.borderColor = RGB(240, 240, 240).CGColor;
    _tixianBtn.layer.borderWidth = 1.0f;
    _tixianBtn.layer.masksToBounds = YES;
    _tixianBtn.layer.cornerRadius = 5.0f;
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

- (IBAction)pay:(id)sender {
    ChongzhiViewController *vc = [[ChongzhiViewController alloc] init];
    vc.title = @"我的账户";
    [self.navigationController pushViewController:vc animated:YES];
}
@end
