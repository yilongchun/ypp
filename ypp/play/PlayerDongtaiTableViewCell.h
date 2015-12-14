//
//  PlayerDongtaiTableViewCell.h
//  ypp
//
//  Created by Stephen Chin on 15/12/14.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerDongtaiTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *otherLabel;


@end
