//
//  HelpViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/16.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

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
    
    [self loadData];
}

-(void)loadData{
    [self showHudInView:self.view];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"3" forKey:@"type"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_GETURL];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"JSON: %@", operation.responseString);
        NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            [self hideHud];
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == ResultCodeSuccess) {
                NSString *url = [dic objectForKey:@"message"];
                [self.mywebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,url]]]];
                
                
            }else{
                [self hideHud];
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

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHud];
    
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
