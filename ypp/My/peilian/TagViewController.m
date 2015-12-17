//
//  XiangxueViewController.m
//  corner
//
//  Created by yons on 15-7-3.
//  Copyright (c) 2015年 hmzl. All rights reserved.
//

#import "TagViewController.h"

@interface TagViewController (){
    NSArray *array;
    CGFloat height;
    
    UIImage *grayImage;
    UIImage *yellowImage;
//    NSString *selectedString;
    UIButton *selectedBtn;
}

@end

@implementation TagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    self.title = @"标签";
    
    yellowImage = [UIImage imageNamed:@"btn_yellow"];
    yellowImage = [yellowImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15) resizingMode:UIImageResizingModeStretch];
    
    grayImage = [UIImage imageNamed:@"btn_gray"];
    grayImage = [grayImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 15, 0, 15) resizingMode:UIImageResizingModeStretch];

    
    array = @[@"小清新",@"小萝莉",@"御姐",@"女汉子",@"小鸟依人",@"野蛮女生",@"运动时尚",@"优雅文静",@"性感",@"宅",@"成熟稳重",@"儒雅",@"豪放",@"完美主义",@"工作狂",@"温柔体贴"];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    [done setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = done;
    
    [self addBtn];
}

-(void)done{
    if (_tagValue == nil || [_tagValue isEqualToString:@""]) {
        [self showHint:@"请选择标签"];
        return;
    }
    
    //添加 字典，将label的值通过key值设置传递
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:@"tag",@"column",_tagValue,@"columnValue", nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:@"setValue" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)addBtn{
    
    CGRect rect;
    CGFloat x = 0;
    CGFloat y = 50;
    CGFloat width = 0;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    int i = 0;
    for (NSString *theme in array) {
        
        UIFont *font = [UIFont boldSystemFontOfSize:14];
        CGSize textSize;
        if ([NSString instancesRespondToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
            NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle.copy};
            NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin;
            textSize = [theme boundingRectWithSize:CGSizeMake(MAXFLOAT, 28)
                                           options:options
                                        attributes:attributes
                                           context:nil].size;
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            textSize = [theme sizeWithFont:font
                         constrainedToSize:CGSizeMake(MAXFLOAT, 28)
                             lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
            
        }
        
        
        textSize.width += 30;
        
        x = width + 8;
        
        if (x + textSize.width > screenWidth) {
            x = 8;
            y += 38;
        }
        
        rect = CGRectMake(x, y, textSize.width, 28);
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([_tagValue isEqualToString:theme]) {
            selectedBtn = btn;
            [btn setBackgroundImage:yellowImage forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
            [btn setBackgroundImage:grayImage forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
        
        [btn setBackgroundImage:yellowImage forState:UIControlStateHighlighted];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:rect];
        [btn setTitle:theme forState:UIControlStateNormal];
        
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_myscrollview addSubview:btn];
        width = btn.frame.origin.x + textSize.width;
        height = btn.frame.origin.y + 40;
        i++;
    }
}

-(void)btnClick:(UIButton *)btn{
    if (selectedBtn != btn) {
        [selectedBtn setBackgroundImage:grayImage forState:UIControlStateNormal];
        [selectedBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        selectedBtn = btn;
        [selectedBtn setBackgroundImage:yellowImage forState:UIControlStateNormal];
        [selectedBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _tagValue = btn.currentTitle;
        
    }
    
    
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [_myscrollview setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, height)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
