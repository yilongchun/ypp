//
//  Util.m
//  ypp
//
//  Created by haidony on 15/12/5.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "Util.h"

@implementation Util

+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13，14，15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(14[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
    
    //    if (mobile.length==11 && [[mobile substringWithRange:NSMakeRange(0,1)] isEqualToString:@"1"]) {
    //        NSScanner *scan = [NSScanner scannerWithString:mobile];
    //        int val;
    //        return [scan scanInt:&val] && [scan isAtEnd];
    //    }else{
    //        return NO;
    //    }
    
}

@end
