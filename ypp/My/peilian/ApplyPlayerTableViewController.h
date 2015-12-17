//
//  ApplyPlayerTableViewController.h
//  ypp
//
//  Created by Stephen Chin on 15/12/16.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kScreen_Height      ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width       ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame       (CGRectMake(0, 0 ,kScreen_Width,kScreen_Height))

@interface ApplyPlayerTableViewController : UITableViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *myPicker;
@property (strong, nonatomic) IBOutlet UIView *pickerBgView;
@property (strong, nonatomic) UIView *maskView;

@end
