//
//  DBUtil.m
//  ypp
//
//  Created by Stephen Chin on 15/12/30.
//  Copyright © 2015年 weyida. All rights reserved.
//

#import "DBUtil.h"
#import "FMDB.h"



@implementation DBUtil

+(void)createTable:(FMDatabase *)db
{
    if ([db open]) {
        if (![db tableExists :@"userinfo"]) {
            if ([db executeUpdate:@"create table userinfo (userid text, username text, userimage text)"]) {
                NSLog(@"create table success");
            }else{
                NSLog(@"fail to create table");
            }
        }else {
             NSLog(@"table is already exist");
        }
    }else{
        NSLog(@"fail to open");
    }
}

+ (void)clearTableData:(FMDatabase *)db
{
    if ([db executeUpdate:@"DELETE FROM userinfo"]) {
        NSLog(@"clear successed");
    }else{
        NSLog(@"fail to clear");
    }
}

+(void)queryUserInfoFromDB:(NSDictionary *)userinfo{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"ypp.db"];
    FMDatabase *db     = [FMDatabase databaseWithPath:dbPath];
    [self createTable:db];
    
    if (userinfo != nil && [userinfo objectForKey:@"userid"] != nil) {
        NSString *userid = [userinfo objectForKey:@"userid"];
        if ([db executeUpdate:@"DELETE FROM userinfo where userid = ?", userid]) {
            DLog(@"删除成功");
        }else{
            DLog(@"删除失败");
        }
        NSString *username = [userinfo objectForKey:@"username"];
        NSString *userimage = [userinfo objectForKey:@"userimage"];
        if ([db executeUpdate:@"INSERT INTO userinfo (userid, username, userimage) VALUES (?, ?, ?)", userid,username,userimage]) {
            DLog(@"插入成功");
        }else{
            DLog(@"插入失败");
        }
        
        //    NSLog(@"%d: %@", [db lastErrorCode], [db lastErrorMessage]);
        FMResultSet *rs = [db executeQuery:@"SELECT userid, username, userimage FROM userinfo where userid = ?",userid];
        if ([rs next]) {
            NSString *userid = [rs stringForColumn:@"userid"];
            NSString *username = [rs stringForColumn:@"username"];
            NSString *userimage = [rs stringForColumn:@"userimage"];
            DLog(@"查询一个 %@ %@ %@",userid,username,userimage);
        }
        
        rs = [db executeQuery:@"SELECT userid, username, userimage FROM userinfo"];
        while ([rs next]) {
            NSString *userid = [rs stringForColumn:@"userid"];
            NSString *username = [rs stringForColumn:@"username"];
            NSString *userimage = [rs stringForColumn:@"userimage"];
            DLog(@"查询所有 %@ %@ %@",userid,username,userimage);
        }
        [rs close];
        //    NSLog(@"%d: %@", [db lastErrorCode], [db lastErrorMessage]);
        [db close];
    }
    
    
    
}

+(NSDictionary *)queryUserFromDbById:(NSString *)userid{
    NSString *docsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dbPath   = [docsPath stringByAppendingPathComponent:@"ypp.db"];
    FMDatabase *db     = [FMDatabase databaseWithPath:dbPath];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:@"SELECT userid, username, userimage FROM userinfo where userid = ?",userid];
        if ([rs next]) {
            NSString *userid = [rs stringForColumn:@"userid"];
            NSString *username = [rs stringForColumn:@"username"];
            NSString *userimage = [rs stringForColumn:@"userimage"];
            DLog(@"查询一个 %@ %@ %@",userid,username,userimage);
            NSMutableDictionary *userinfo = [NSMutableDictionary dictionary];
            [userinfo setValue:userid forKey:@"userid"];
            [userinfo setValue:username forKey:@"username"];
            [userinfo setValue:userimage forKey:@"userimage"];
            return userinfo;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}


@end
