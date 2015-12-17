//
//  EditAddressViewController.h
//  ypp
//
//  Created by Stephen Chin on 15/12/11.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAddressViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIPickerView *myPicker;

@property int type;//0 修改个人资料 ， 1 申请游神 选择城市
@property (strong, nonatomic) NSString *column;
@property (strong, nonatomic) NSString *columnValue;

@end
