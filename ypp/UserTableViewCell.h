//
//  UserTableViewCell.h
//  ypp
//
//  Created by haidony on 15/11/5.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *userimage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImage;
@property (weak, nonatomic) IBOutlet UILabel *otherInfo;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *hotImage;
@property (weak, nonatomic) IBOutlet UILabel *jiedanNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;

@end
