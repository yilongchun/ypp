//
//  YueTaViewController.h
//  ypp
//
//  Created by Stephen Chin on 15/12/23.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+RGSize.h"

#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame       (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))

@interface YueTaViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITableView *mytableview;
@property (strong, nonatomic) NSDictionary *userinfo;
@property (strong, nonatomic) NSDictionary *youshenInfo;

@property (strong, nonatomic) IBOutlet UIPickerView *myPicker;
@property (strong, nonatomic) IBOutlet UIView *pickerBgView;
@property (strong, nonatomic) UIView *maskView;

@property (strong, nonatomic) IBOutlet UIView *myBottomView;
@property (strong, nonatomic) UIView *myMaskView;

@end
