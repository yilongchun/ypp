//
//  DongtaiDetailViewController.m
//  ypp
//
//  Created by Stephen Chin on 15/12/10.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "DongtaiDetailViewController.h"
#import "DongtaiDetailTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDate+Addition.h"
#import "NSDate+TimeAgo.h"
#import "IQKeyboardManager.h"

@interface DongtaiDetailViewController ()

@property (strong, nonatomic) UIView *keyboardBackview;
@property (nonatomic, strong) UITextField *mytextfield;
@property (nonatomic, strong) UIButton *button;

@end

@implementation DongtaiDetailViewController
@synthesize info;

- (id)init{
    self = [super init];
    if(self){
        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"动态详情";
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    //添加手势，点击输入框其他区域隐藏键盘
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGr.cancelsTouchesInView =NO;
    [self.mytableview addGestureRecognizer:tapGr];
    
    //添加键盘监听器
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    self.keyboardBackview = [[UIView alloc] initWithFrame:CGRectMake(0, Main_Screen_Height - 44 - 64, Main_Screen_Width, 44)];
    self.keyboardBackview.backgroundColor = RGB(247, 247, 247);
    [self.view addSubview:self.keyboardBackview];
    UILabel *topLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Main_Screen_Width, 1)];
    topLine.backgroundColor = RGB(200, 200, 200);
    [self.keyboardBackview addSubview:topLine];
    self.mytextfield = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, Main_Screen_Width - 50 -10, 30)];
    self.mytextfield.borderStyle = UITextBorderStyleRoundedRect;
    self.mytextfield.backgroundColor = RGB(250, 250, 250);
    self.mytextfield.placeholder = @"输入评论...";
    self.mytextfield.font = [UIFont fontWithName:@"Arial" size:15.0f];
    self.mytextfield.clearButtonMode = UITextFieldViewModeAlways;
    self.mytextfield.returnKeyType = UIReturnKeyDefault;
    
    
    [self.mytextfield addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    [self.keyboardBackview addSubview:self.mytextfield];
    self.button = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button.frame = CGRectMake(Main_Screen_Width - 50, 6, 50, 32);
    [self.button setTitle:@"发送" forState:0];
    [self.keyboardBackview  addSubview:self.button];
    self.button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.button addTarget:self action:@selector(sendMess) forControlEvents:UIControlEventTouchUpInside];
    self.button.enabled = NO;
    
    
    DLog(@"%@",info);
}

-(void)hideKeyboard{
    [_mytextfield resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 456 - 18;

    NSString *content = [info objectForKey:@"content"];
    
    CGFloat contentWidth = Main_Screen_Width - 20;
    UIFont *font = [UIFont systemFontOfSize:15];
    CGSize textSize;
    if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
        textSize = [content boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT)
                                         options:options
                                      attributes:attributes
                                         context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        textSize = [content sizeWithFont:font
                       constrainedToSize:CGSizeMake(contentWidth, MAXFLOAT)
                           lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
        
    }
    return height + textSize.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DongtaiDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"dongtaiDetailcell"];
    NSString *avatar = [info objectForKey:@"avatar"];//头像
    NSString *user_name = [info objectForKey:@"user_name"];
    NSNumber *sex = [info objectForKey:@"sex"];
    NSString *content = [info objectForKey:@"content"];
    NSString *pic = [info objectForKey:@"pic"];
    
    [cell.userImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HOST,PIC_PATH,avatar]] placeholderImage:[UIImage imageNamed:@"gallery_default"]];
    cell.userImage.layer.masksToBounds = YES;
    cell.userImage.layer.cornerRadius = 5;
    cell.username.text = user_name;
    if ([sex intValue] == 0) {
        [cell.sexImage setHidden:NO];
        [cell.sexImage setImage:[UIImage imageNamed:@"usercell_girl"]];
        NSNumber *byear = [info objectForKey:@"byear"];
        NSNumber *bmonth = [info objectForKey:@"bmonth"];
        NSNumber *bday = [info objectForKey:@"bday"];
        NSDate *birthday = [NSDate dateWithYear:[byear integerValue] month:[bmonth integerValue] day:[bday integerValue]];
        NSInteger age = [NSDate ageWithDateOfBirth:birthday];
        cell.ageLabel.text = [NSString stringWithFormat:@"%ld",(long)age];
    }else if ([sex intValue] == 1){
        [cell.sexImage setHidden:NO];
        [cell.sexImage setImage:[UIImage imageNamed:@"usercell_boy"]];
        NSNumber *byear = [info objectForKey:@"byear"];
        NSNumber *bmonth = [info objectForKey:@"bmonth"];
        NSNumber *bday = [info objectForKey:@"bday"];
        NSDate *birthday = [NSDate dateWithYear:[byear integerValue] month:[bmonth integerValue] day:[bday integerValue]];
        NSInteger age = [NSDate ageWithDateOfBirth:birthday];
        cell.ageLabel.text = [NSString stringWithFormat:@"%ld",(long)age];
    }else{
        [cell.sexImage setHidden:YES];
    }
    cell.contentLabel.text = content;
    if (pic != nil && ![pic isEqualToString:@""]) {
        [cell.bigImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HOST,pic]]];
    }
    
    NSNumber *distance = [info objectForKey:@"distance"];
    NSString *dis = [NSString stringWithFormat:@"%.2fkm",[distance floatValue] / 1000];
    
    NSNumber *update_time = [info objectForKey:@"update_time"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[update_time doubleValue]];
    
    cell.otherLabel.text = [NSString stringWithFormat:@"%@|%@",dis,[confromTimesp timeAgo]];
    
    return cell;
}

-(void)sendMess{
    [self hideKeyboard];
    
    if ([self.mytextfield.text isEqualToString:@""]) {
        [self showHint:@"请输入内容"];
        return;
    }
    
    [self showHudInView:self.view];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:_mytextfield.text forKey:@"content"];
    [parameters setValue:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"id"]] forKey:@"userid"];
    [parameters setValue:[info objectForKey:@"id"] forKey:@"topicid"];
    [parameters setValue:[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] objectForKey:LOGINED_USER] objectForKey:@"user_name"]] forKey:@"username"];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",HOST,API_TOPICLIST];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/plain", @"text/html", nil];
    [manager POST:urlString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self hideHud];
//        [_mytableview.mj_header endRefreshing];
//        [_mytableview.mj_footer resetNoMoreData];
        NSLog(@"JSON: %@", operation.responseString);
        
        NSString *result = [NSString stringWithFormat:@"%@",[operation responseString]];
        NSError *error;
        NSDictionary *dic= [NSJSONSerialization JSONObjectWithData:[result dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
        if (dic == nil) {
            NSLog(@"json parse failed \r\n");
        }else{
            NSNumber *status = [dic objectForKey:@"status"];
            if ([status intValue] == ResultCodeSuccess) {
                
//                NSArray *array = [dic objectForKey:@"message"];
//                
//                [dataSource removeAllObjects];
//                [dataSource addObjectsFromArray:array];
//                [_mytableview reloadData];
                
                _mytextfield.text = @"";
                [_mytableview reloadData];
            }else{
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

-(void)textFieldChanged:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        self.button.enabled = NO;
    }else{
        self.button.enabled = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

//显示键盘
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];
    
    // get a rect for the textView frame
    CGRect containerFrame = _keyboardBackview.frame;
    containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    _keyboardBackview.frame = containerFrame;
    
    
    // commit animations
    [UIView commitAnimations];
}
//隐藏键盘
-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = _keyboardBackview.frame;
    containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    _keyboardBackview.frame = containerFrame;
    
    // commit animations
    [UIView commitAnimations];
}

@end
