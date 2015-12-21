//
//  WebViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/21.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _mywebview.delegate = self;
    _mywebview.scrollView.delegate = self;
    _mywebview.backgroundColor=[UIColor clearColor];
    for (UIView *_aView in [_mywebview subviews]){
        if ([_aView isKindOfClass:[UIScrollView class]]){
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:YES]; //右侧的滚动条
            for (UIView *_inScrollview in _aView.subviews){
                if ([_inScrollview isKindOfClass:[UIImageView class]]) {
                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
    
    [self.mywebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
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
