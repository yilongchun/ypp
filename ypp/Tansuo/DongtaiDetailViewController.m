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

@property (strong, nonatomic) IBOutlet UIView *keyboardBackview;
@property (nonatomic, strong) UITextField *mytextfield;

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
    [self.keyboardBackview addSubview:self.mytextfield];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(Main_Screen_Width - 50, 6, 50, 32);
    [button setTitle:@"发送" forState:0];
    [self.keyboardBackview  addSubview:button];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [button addTarget:self action:@selector(sendMess) forControlEvents:UIControlEventTouchUpInside];
    
    
    
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
