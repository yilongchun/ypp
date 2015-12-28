//
//  MyBottomView.h
//  ypp
//
//  Created by Stephen Chin on 15/12/28.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBottomView : UIView

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIView *chooseYouhui;
@property (weak, nonatomic) IBOutlet UILabel *youhuiNum;
@property (weak, nonatomic) IBOutlet UIView *yue;
@property (weak, nonatomic) IBOutlet UIView *weixin;
@property (weak, nonatomic) IBOutlet UIView *zhifubao;
@property (weak, nonatomic) IBOutlet UIImageView *yueRightImage;
@property (weak, nonatomic) IBOutlet UIImageView *weixinRightImage;
@property (weak, nonatomic) IBOutlet UIImageView *zhifubaoRightImage;
@property (weak, nonatomic) IBOutlet UIButton *zhifuButton;
- (IBAction)submit:(id)sender;

@end
