//
//  QiangTableViewCell.h
//  ypp
//
//  Created by Stephen Chin on 16/1/22.
//  Copyright © 2016年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QiangTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderTime;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIImageView *orderStatus;
@end
