//
//  Util.h
//  ypp
//
//  Created by haidony on 15/12/5.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject

//验证手机号
+(BOOL) isValidateMobile:(NSString *)mobile;

//上传图片
+ (NSMutableURLRequest *)postRequestWithParems:(NSURL *)url image: (UIImage *)image imageName: (NSString *)imagename;

//获得星座
+(NSString *)getAstroWithMonth:(int)m day:(int)d;

//验证身份证
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
@end
