//
//  WebViewController.h
//  ypp
//
//  Created by Stephen Chin on 15/12/21.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *mywebview;
@property (strong, nonatomic) NSString *url;

@end
