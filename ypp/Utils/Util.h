//
//  Util.h
//  ypp
//
//  Created by haidony on 15/12/5.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

+(BOOL) isValidateMobile:(NSString *)mobile;

+ (NSMutableURLRequest *)postRequestWithParems:(NSURL *)url image: (UIImage *)image imageName: (NSString *)imagename;

+(NSString *)getAstroWithMonth:(int)m day:(int)d;

@end
