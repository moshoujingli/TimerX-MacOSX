//
//  TSEventManager.m
//  TimeSaver
//
//  Created by BiXiaopeng on 16/5/24.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import "TSEventManager.h"

@interface TSEventManager()
@property (strong)FMDatabase *db;
@end

@implementation TSEventManager
+(instancetype)sharedManager{
    static TSEventManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}
-(instancetype)init{
    self = [super init];
    if (self!=nil) {
        //init db file
        NSString* homePath = NSHomeDirectory();
        NSString* dbDirPath = [homePath stringByAppendingPathComponent:@"TimerX"];
        NSString* timeLineDBFile = [dbDirPath stringByAppendingPathComponent:@"main.db"];
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
        //init time line db
        //init event db
        //init heart beat db
    }
    return self;
}
-(void)event:(TSEvent *)event at:(NSTimeInterval)timestamp{
    [self.db executeUpdate:@"insert into `app_time_line` (bundle,page,time_millis) values (?,?,?) ",event.bundleName,event.pageName,[NSNumber numberWithDouble:timestamp]];
    if (event.type==ENTER) {
        event.start = timestamp;
    }
    NSLog(@"%@",[event description]);
}
-(void)eventNow:(TSEvent *)event{
    [self event:event at:CFAbsoluteTimeGetCurrent()];
}
-(NSArray *)rawEventsFrom:(NSTimeInterval) from to:(NSTimeInterval) to{
    NSLog(@"%@ %@",[NSDate dateWithTimeIntervalSinceReferenceDate:from].description,[NSDate dateWithTimeIntervalSinceReferenceDate:to].description);
    FMResultSet *rs = [self.db executeQuery:@"select bundle,page,time_millis from app_time_line where time_millis between ? and ? order by time_millis asc",[NSNumber numberWithDouble:from],[NSNumber numberWithDouble:to]] ;
    NSArray *events = [TSEventManager parseArray:rs];
    TSEvent *lastEvent = events.lastObject;
    NSTimeInterval nowMilli = CFAbsoluteTimeGetCurrent();
    if (nowMilli < to) {
        lastEvent.end = nowMilli;
    }else{
        lastEvent.end =  to;
    }
    return events;
}

-(NSArray *)eventsFrom:(NSTimeInterval) from to:(NSTimeInterval) to{
    NSArray *rawEvents = [self rawEventsFrom:from to:to];
    TSEvent *first = rawEvents.firstObject;
    FMResultSet *rs = [self.db executeQuery:@"select bundle,page,time_millis from app_time_line where time_millis <= ? order by time_millis desc limit 1",[NSNumber numberWithDouble:from]] ;
    NSArray *events = [TSEventManager parseArray:rs];
    if([events count]>0){
        TSEvent *fakeFirst = events.firstObject;
        fakeFirst.end = first.start;
         NSMutableArray *eventResult = [[NSMutableArray alloc]initWithCapacity:[rawEvents count]+1];
        [eventResult addObject:fakeFirst];
        [eventResult addObjectsFromArray:rawEvents];
        return eventResult;
    }else{
        return rawEvents;
    }
}
-(NSDictionary *)appsFrom:(NSTimeInterval) from to:(NSTimeInterval) to{
    NSArray *events = [self eventsFrom:from to:to];
    NSMutableDictionary *appsTimeDic = [[NSMutableDictionary alloc]initWithCapacity:80];
    for (TSEvent *event in events) {
        TSEvent *aggrEvent = [appsTimeDic objectForKey:event.bundleName];
        if (aggrEvent==nil) {
            aggrEvent = [TSEvent aggrEventWithBundle:event.bundleName];
        }
        aggrEvent.end+= event.end - event.start;
        [appsTimeDic setObject:aggrEvent forKey:event.bundleName];
    }
    return appsTimeDic;
}
-(NSDictionary *)websitesFrom:(NSTimeInterval) from to:(NSTimeInterval) to{
    NSArray *events = [self eventsFrom:from to:to];
    NSMutableDictionary *appsTimeDic = [[NSMutableDictionary alloc]initWithCapacity:20];
    for (TSEvent *event in events) {
        if (event.pageDomain==nil) {
            continue;
        }
        TSEvent *aggrEvent = [appsTimeDic objectForKey:event.pageDomain];
        if (aggrEvent==nil) {
            aggrEvent = [TSEvent aggrEventWithPageDomain:event.pageDomain];
        }
        aggrEvent.end+= event.end - event.start;
        [appsTimeDic setObject:aggrEvent forKey:event.pageDomain];
    }
    return appsTimeDic;
}

+(NSArray *)parseArray:(FMResultSet *)rs{
    NSMutableArray *eventResult = [[NSMutableArray alloc]initWithCapacity:200];
    TSEvent *lastEvent = nil;
    while ([rs next]) {
        NSString *bundleName = [rs stringForColumn:@"bundle"];
        NSString *pageName = [rs stringForColumn:@"page"];
        NSTimeInterval timeInterval = [rs doubleForColumn:@"time_millis"];
        
        if (lastEvent==nil) {
            NSLog(@"start Parse");
            lastEvent = [[TSEvent alloc]init];
            lastEvent.bundleName = bundleName;
            lastEvent.pageName = pageName;
            lastEvent.start = timeInterval;
        }else{
            TSEvent *event = [[TSEvent alloc]init];
            if ([lastEvent.bundleName isEqualToString:bundleName] && [lastEvent.pageName isEqualToString:pageName]) {
                continue;
            }
            event.bundleName = bundleName;
            event.pageName = pageName;
            event.start = timeInterval;
            lastEvent.end = timeInterval-0.01;
            lastEvent = event;
        }
        [eventResult addObject:lastEvent];
    }
    
    
    return eventResult;
    
}
@end
