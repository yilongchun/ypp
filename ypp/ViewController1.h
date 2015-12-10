//
//  ViewController1.h
//  ypp
//
//  Created by haidony on 15/11/4.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController1 :  UIViewController{
    NSMutableArray *dataSource;
//    CGFloat lastOffsetY;
//    BOOL isDecelerating;
}

@property (strong, nonatomic) IBOutlet UITableView *mytableview;
@property int type;

@end
