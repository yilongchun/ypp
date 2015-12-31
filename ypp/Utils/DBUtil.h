//
//  DBUtil.h
//  ypp
//
//  Created by Stephen Chin on 15/12/30.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBUtil : NSObject

+(void)queryUserInfoFromDB:(NSDictionary *)userinfo;

+(NSDictionary *)queryUserFromDbById:(NSString *)userid;

@end
