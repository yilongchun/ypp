//
//  YouhuijuanTableViewCell.h
//  ypp
//
//  Created by Stephen Chin on 15/12/18.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouhuijuanTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageStatus;
@property (weak, nonatomic) IBOutlet UILabel *moneyLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *youhuijuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *xianzhiLabel;

@end
