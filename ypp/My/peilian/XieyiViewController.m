//
//  XieyiViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/16.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "XieyiViewController.h"
#import "ApplyPlayerTableViewController.h"

@interface XieyiViewController ()

@end

@implementation XieyiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _mywebview.scrollView.delegate = self;
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    _mywebview.backgroundColor=[UIColor clearColor];
    for (UIView *_aView in [_mywebview subviews])
    {
        if ([_aView isKindOfClass:[UIScrollView class]])
        {
            [(UIScrollView *)_aView setShowsVerticalScrollIndicator:NO]; //右侧的滚动条
            
            for (UIView *_inScrollview in _aView.subviews)
            {
                
                if ([_inScrollview isKindOfClass:[UIImageView class]])
                {
                    _inScrollview.hidden = YES;  //上下滚动出边界时的黑色的图片
                }
            }
        }
    }
    
    _mywebview.scrollView.showsVerticalScrollIndicator = YES;
    
    self.title = @"陪练协议";
    
    [self.agreeBtn setBackgroundColor:RGBA(200,22,34,1)];
//    [self.agreeBtn setBackgroundImage:[UIImage imageNamed:@"blue_btn2"] forState:UIControlStateNormal];
    [self.agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.agreeBtn setEnabled:NO];
    
    [self loadData];
}

-(void)loadData{
    [self showHudInView:self.view];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@"1" forKey:@"type"];
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)agree:(id)sender {
    ApplyPlayerTableViewController *vc = [[ApplyPlayerTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideHud];
    DLog(@"finished");
    
}
//滑动到底部
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint contentOffsetPoint = _mywebview.scrollView.contentOffset;
    CGRect frame = _mywebview.scrollView.frame;
    if (contentOffsetPoint.y == _mywebview.scrollView.contentSize.height - frame.size.height || _mywebview.scrollView.contentSize.height < frame.size.height)
    {
//        [self.agreeBtn setEnabled:YES];
    }
}
@end
