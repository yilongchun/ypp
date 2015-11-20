//
//  MainTabBarController.m
//  ypp
//
//  Created by haidony on 15/11/4.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "MainTabBarController.h"
#import "JYSlideSegmentController.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "ViewController4.h"
#import "ViewController5.h"

#import "FabuyuewanViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController{
    UIBarButtonItem *bwhdButtonItem1;
    UIBarButtonItem *ggtzButtonItem2;
    UIBarButtonItem *bwrzButtonItem3;
    UIBarButtonItem *bwhdButtonItem4;
    UIBarButtonItem *ggtzButtonItem5;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //去除阴影线
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithWhite:1 alpha:1]];
    
    self.delegate = self;
    
    self.tabBar.superview.backgroundColor = [UIColor whiteColor];
    
    UIImage *img1 = [UIImage imageNamed:@"t2.png"];
    UIImage *img1_h = [UIImage imageNamed:@"t2h.png"];
    
    UIImage *img2 = [UIImage imageNamed:@"t0.png"];
    UIImage *img2_h = [UIImage imageNamed:@"t0h"];
    
    UIImage *img3 = [UIImage imageNamed:@"yue.png"];
    UIImage *img3_h = [UIImage imageNamed:@"yue"];
    
    UIImage *img4 = [UIImage imageNamed:@"t3.png"];
    UIImage *img4_h = [UIImage imageNamed:@"t3h"];
    
    UIImage *img5 = [UIImage imageNamed:@"t4.png"];
    UIImage *img5_h = [UIImage imageNamed:@"t4h"];
    
    
    
    ViewController2 *vc2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController2"];
    vc2.title = @"探索";
    ViewController3 *vc3 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController3"];
    ViewController4 *vc4 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController4"];
    vc4.title = @"消息";
    ViewController5 *vc5 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController5"];
    vc5.title = @"我的";
    
    CGFloat offset = 7.0;
    CGFloat offset2 = 3.0;
    
    
    NSMutableArray *vcs = [NSMutableArray array];
    
    ViewController1 *vc1_1 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
    vc1_1.title = @"智能";
    [vcs addObject:vc1_1];
    
    ViewController1 *vc1_2 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
    vc1_2.title = @"热度";
    [vcs addObject:vc1_2];
    
    ViewController1 *vc1_3 = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
    vc1_3.title = @"新人";
    [vcs addObject:vc1_3];
    
    JYSlideSegmentController *slideSegmentController = [[JYSlideSegmentController alloc] initWithViewControllers:vcs];
    slideSegmentController.title = @"游神";
    slideSegmentController.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
    slideSegmentController.indicatorColor = NAVIGATION_BAR_COLOR;
    
    
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1){
        img1 = [img1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        img1_h = [img1_h imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        img2 = [img2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        img2_h = [img2_h imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        img3 = [img3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        img3_h = [img3_h imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        img4 = [img4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        img4_h = [img4_h imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        img5 = [img5 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        img5_h = [img5_h imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        
        
        UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:nil image:img1 selectedImage:img1_h];
        [item1 setTag:0];
        slideSegmentController.tabBarItem = item1;
        slideSegmentController.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
//        vc1.tabBarItem = item1;
//        vc1.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
        
        UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:nil image:img2 selectedImage:img2_h];
        [item2 setTag:1];
        vc2.tabBarItem = item2;
        vc2.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
        
        UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:nil image:img3 selectedImage:img3_h];
        [item3 setTag:2];
        vc3.tabBarItem = item3;
        vc3.tabBarItem.imageInsets = UIEdgeInsetsMake(-offset2, 0, offset2, 0);
        
        UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:nil image:img4 selectedImage:img4_h];
        [item4 setTag:3];
        vc4.tabBarItem = item4;
        vc4.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
        
        UITabBarItem *item5 = [[UITabBarItem alloc] initWithTitle:nil image:img5 selectedImage:img5_h];
        [item5 setTag:4];
        vc5.tabBarItem = item5;
        vc5.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
    }else{
        UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:nil image:img1 tag:0];
        slideSegmentController.tabBarItem = item1;
        slideSegmentController.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
//        vc1.tabBarItem = item1;
//        vc1.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
        
        UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:nil image:img2 tag:1];
        vc2.tabBarItem = item2;
        vc2.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
        
        UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:nil image:img3 tag:2];
        vc3.tabBarItem = item3;
        vc3.tabBarItem.imageInsets = UIEdgeInsetsMake(-offset2, 0, offset2, 0);
        
        UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:nil image:img4 tag:3];
        vc4.tabBarItem = item4;
        vc4.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
        
        UITabBarItem *item5 = [[UITabBarItem alloc] initWithTitle:nil image:img5 tag:4];
        vc5.tabBarItem = item5;
        vc5.tabBarItem.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
    }
    
    
    
    
    UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:slideSegmentController];
//    UINavigationController *nc1 = [[UINavigationController alloc] initWithRootViewController:vc1];
    UINavigationController *nc2 = [[UINavigationController alloc] initWithRootViewController:vc2];
    UINavigationController *nc4 = [[UINavigationController alloc] initWithRootViewController:vc4];
    UINavigationController *nc5 = [[UINavigationController alloc] initWithRootViewController:vc5];
    
    
    
    nc1.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor] , NSFontAttributeName : [UIFont boldSystemFontOfSize:19]};
    
    nc2.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor] , NSFontAttributeName : [UIFont boldSystemFontOfSize:19]};
    
    nc4.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor] , NSFontAttributeName : [UIFont boldSystemFontOfSize:19]};
    
    nc5.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor] , NSFontAttributeName : [UIFont boldSystemFontOfSize:19]};
    
    //    把导航控制器加入到数组
    NSMutableArray *viewArr_ = [NSMutableArray arrayWithObjects:nc1,nc2,vc3,nc4,nc5, nil];
    
    
    self.viewControllers = viewArr_;
    self.selectedIndex = 0;
    
//    CGFloat offset = 7.0;
//    for (UITabBarItem *item in self.tabBar.items) {
//        item.imageInsets = UIEdgeInsetsMake(offset, 0, -offset, 0);
//    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"%ld",(long)item.tag);
    if (item.tag == 2) {
        //发布约玩
        FabuyuewanViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FabuyuewanViewController"];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
        nc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor] , NSFontAttributeName : [UIFont boldSystemFontOfSize:19]};
        nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:nc animated:YES completion:^{
            
        }];
        
        
        
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.5f;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromRight;
//        transition.delegate = self;
//        [nc.view.layer addAnimation:transition forKey:nil];
//        [self.view addSubview:nc.view];
        
        
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    NSLog(@"shouldSelectViewController:%@\t%@",tabBarController,viewController);
    if ([viewController isKindOfClass:[ViewController3 class]]) {
        return NO;
    }else{
        return YES;
    }
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    NSLog(@"didSelectViewController:%@\t%@",tabBarController,viewController);
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
