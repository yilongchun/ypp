//
//  ViewController2.m
//  ypp
//
//  Created by haidony on 15/11/4.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "ViewController2.h"
#import "JYSlideSegmentController.h"
#import "DongtaiViewController.h"
#import "FabudongtaiViewController.h"

@interface ViewController2 (){
    JYSlideSegmentController *slideSegmentController;
    
    CGRect btnFrame;
    UIButton *addBtn;
}

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    [self.mytableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
    [self.mytableview setTableFooterView:v];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showAddBtn)
                                                 name:@"showAddBtn" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(hideAddBtn)
                                                 name:@"hideAddBtn" object:nil];
    
}

-(void)showAddBtn{
    [UIView beginAnimations:nil context:nil];
    addBtn.frame = btnFrame;
    [UIView commitAnimations];
}

-(void)hideAddBtn{
    [UIView beginAnimations:nil context:nil];
    CGRect tmppingFrame = addBtn.frame;
    tmppingFrame.origin.y = 1000;
    addBtn.frame = tmppingFrame;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 3;
    }else{
        return 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.textLabel.text = @"动态";
        cell.imageView.image = [UIImage imageNamed:@"dongtai"];
    }else if(indexPath.section == 1){
        if (indexPath.row == 0) {
            cell.textLabel.text = @"附近活动";
            cell.imageView.image = [UIImage imageNamed:@"huodong"];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"附近群组";
            cell.imageView.image = [UIImage imageNamed:@"IMG_1550_10"];
        }else if (indexPath.row == 2){
            cell.textLabel.text = @"附近的人";
            cell.imageView.image = [UIImage imageNamed:@"IMG_1550_08"];
        }
    }else{
        cell.textLabel.text = @"游戏";
        cell.imageView.image = [UIImage imageNamed:@"IMG_1550_06"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        NSMutableArray *vcs = [NSMutableArray array];
        
        DongtaiViewController *vc1_1 = [self.storyboard instantiateViewControllerWithIdentifier:@"DongtaiViewController"];
        vc1_1.title = @"精华";
        vc1_1.type = @"1";
        [vcs addObject:vc1_1];
        
        DongtaiViewController *vc1_2 = [self.storyboard instantiateViewControllerWithIdentifier:@"DongtaiViewController"];
        vc1_2.title = @"附近";
        vc1_2.type = @"2";
        [vcs addObject:vc1_2];
        
        DongtaiViewController *vc1_3 = [self.storyboard instantiateViewControllerWithIdentifier:@"DongtaiViewController"];
        vc1_3.title = @"关注";
        vc1_3.type = @"3";
        [vcs addObject:vc1_3]
        ;
        DongtaiViewController *vc1_4 = [self.storyboard instantiateViewControllerWithIdentifier:@"DongtaiViewController"];
        vc1_4.title = @"我的";
        vc1_4.type = @"4";
        [vcs addObject:vc1_4];
        
        
        slideSegmentController = [[JYSlideSegmentController alloc] initWithViewControllers:vcs];
        slideSegmentController.title = @"动态";
        slideSegmentController.indicatorInsets = UIEdgeInsetsMake(0, 8, 0, 8);
        slideSegmentController.indicatorColor = RGBA(200,22,34,1);
        slideSegmentController.hidesBottomBarWhenPushed = YES;
        
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"消息" style:UIBarButtonItemStylePlain target:self action:@selector(msg)];
        [rightItem setTintColor:[UIColor whiteColor]];
        
        UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(fabu)];
        [rightItem2 setTintColor:[UIColor whiteColor]];
        slideSegmentController.navigationItem.rightBarButtonItems = @[rightItem2,rightItem];
        
        addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:[UIImage imageNamed:@"createGroup"] forState:UIControlStateNormal];
        [addBtn setFrame:CGRectMake(Main_Screen_Width - 80, Main_Screen_Height - 140, 60, 60)];
        [slideSegmentController.view addSubview:addBtn];
        btnFrame = addBtn.frame;
        [self.navigationController pushViewController:slideSegmentController animated:YES];
        
        
        
    }
}

-(void)msg{
    DLog(@"");
}

-(void)fabu{
    FabudongtaiViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FabudongtaiViewController"];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    nc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor] , NSFontAttributeName : [UIFont boldSystemFontOfSize:19]};
    [slideSegmentController presentViewController:nc animated:YES completion:nil];
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
