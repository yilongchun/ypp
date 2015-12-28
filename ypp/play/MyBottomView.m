//
//  MyBottomView.m
//  ypp
//
//  Created by Stephen Chin on 15/12/28.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "MyBottomView.h"

@implementation MyBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        DLog(@"123");
        
//        NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MyBottomView" owner:nil options:nil];
//        MyBottomView *cv =[nibView objectAtIndex:0];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [self.yue addGestureRecognizer:tap];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [self.weixin addGestureRecognizer:tap2];
        UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)];
        [self.zhifubao addGestureRecognizer:tap3];
        
        
//        self = cv;
    }
    return self;
}

- (void)awakeFromNib
{
    [[NSBundle mainBundle] loadNibNamed:@"MyBottomView" owner:self options:nil];
    [self addSubview:self.contentView];
}


-(void)click:(UITapGestureRecognizer *)recognizer{
    if (recognizer.view.tag == 1) {
        [self.yueRightImage setImage:[UIImage imageNamed:@"iconfontgou"]];
        [self.weixinRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        [self.zhifubaoRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
    }
    if (recognizer.view.tag == 2) {
        [self.yueRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        [self.weixinRightImage setImage:[UIImage imageNamed:@"iconfontgou"]];
        [self.zhifubaoRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
    }
    if (recognizer.view.tag == 3) {
        [self.yueRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        [self.weixinRightImage setImage:[UIImage imageNamed:@"iconfontgouEmpty"]];
        [self.zhifubaoRightImage setImage:[UIImage imageNamed:@"iconfontgou"]];
    }
}

- (IBAction)submit:(id)sender {
    
}



@end
