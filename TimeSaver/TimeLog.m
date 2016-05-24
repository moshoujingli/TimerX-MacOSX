//
//  TimeLog.m
//  TestProj
//
//  Created by baidu on 16/5/17.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "TimeLog.h"
#import <FMDB/FMDB.h>
@interface TimeLog()
@property (strong,nonatomic) FMDatabase* db;
@end


@implementation TimeLog

+(instancetype)getInstance{
    static TimeLog *sharedTimeLog = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTimeLog = [[self alloc] init];
    });
    return sharedTimeLog;
}

-(instancetype)init{
    self = [super init];
    if (self!=nil) {
        NSString* homePath = NSHomeDirectory();
        NSString* dbDirPath = [homePath stringByAppendingString:@"StatX"];
        NSString* timeLineDBFile = [dbDirPath stringByAppendingString:@"time_line.db"];
        NSFileManager *fileManager= [NSFileManager defaultManager];
        BOOL isDir;

        if(![fileManager fileExistsAtPath:dbDirPath isDirectory:&isDir]){
            if(![fileManager createDirectoryAtPath:dbDirPath withIntermediateDirectories:YES attributes:nil error:NULL]){
                NSLog(@"Error: Create folder failed %@", dbDirPath);
                exit(254);
            }
        }
        self.db = [FMDatabase databaseWithPath:timeLineDBFile];
        if (![self.db open]) {
            exit(255);
        }
        [self.db executeUpdate:@"CREATE table if not exists 'app_time_line'(`bundle` VARCHAR(45) NULL, `page` VARCHAR(45) NULL, `time_millis` DOUBLE NULL );"];
    }
    return self;
}

-(void)savePage:(NSString *)pageName forApp:(NSString *)bundleId withTimeStamp:(NSTimeInterval)millis{
    [self.db executeUpdate:@"insert into `app_time_line` (bundle,page,time_millis) values (?,?,?) ",bundleId,pageName,[NSNumber numberWithDouble:millis]];
    NSLog(@"%@ %@ %f",pageName,bundleId,millis);
}

@end

