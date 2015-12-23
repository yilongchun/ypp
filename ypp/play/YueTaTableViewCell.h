//
//  YueTaTableViewCell.h
//  ypp
//
//  Created by Stephen Chin on 15/12/23.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YueTaTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UIImageView *darenImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@end
