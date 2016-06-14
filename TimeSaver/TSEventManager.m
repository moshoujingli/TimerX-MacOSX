//
//  TSEventManager.m
//  TimeSaver
//
//  Created by BiXiaopeng on 16/5/24.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import "TSEventManager.h"

@interface TSEventManager ()
@property(strong) FMDatabase *db;
@end

@implementation TSEventManager
+ (instancetype)sharedManager {
    static TSEventManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        //init db file
        NSString *homePath = NSHomeDirectory();
        NSString *dbDirPath = [homePath stringByAppendingPathComponent:@"TimerX"];
        NSString *timeLineDBFile = [dbDirPath stringByAppendingPathComponent:@"main.db"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir;

        if (![fileManager fileExistsAtPath:dbDirPath isDirectory:&isDir]) {
            if (![fileManager createDirectoryAtPath:dbDirPath withIntermediateDirectories:YES attributes:nil error:NULL]) {
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

- (void)saveEvent:(TSEvent *)event at:(NSTimeInterval)timestamp {
    [self.db executeUpdate:@"insert into `app_time_line` (bundle,page,time_millis) values (?,?,?) ", event.bundleId, event.pageName, @(timestamp)];
    event.eventTime = timestamp;
    NSLog(@"%@", [event description]);
}

- (void)saveEventNow:(TSEvent *)event {
    [self saveEvent:event at:CFAbsoluteTimeGetCurrent()];
}

- (NSArray *)rawEventsFrom:(NSTimeInterval)from to:(NSTimeInterval)to {
    if (to>CFAbsoluteTimeGetCurrent()){
        to = CFAbsoluteTimeGetCurrent();
    }
    NSLog(@"%@ %@", [NSDate dateWithTimeIntervalSinceReferenceDate:from].description, [NSDate dateWithTimeIntervalSinceReferenceDate:to].description);
    FMResultSet *rs = [self.db executeQuery:@"select bundle,page,time_millis from app_time_line where time_millis between ? and ? order by time_millis asc", @(from), @(to)];
    NSArray *events = [TSEventManager parseArray:rs];
    return events;
}
- (NSArray *)usageRecordFrom:(NSTimeInterval)from to:(NSTimeInterval)to {
    NSArray *rawEvents = [self rawEventsFrom:from to:to];
    FMResultSet *rs = [self.db executeQuery:@"select bundle,page,time_millis from app_time_line where time_millis <= ? order by time_millis desc limit 1", @(from)];
    NSArray *events = [TSEventManager parseArray:rs];
    NSArray *eventsAttachedStartEvent = nil;

    if ([events count] > 0) {
        TSEvent *fakeFirst = events.firstObject;
        fakeFirst.eventTime = from;
        NSMutableArray *eventResult = [[NSMutableArray alloc] initWithCapacity:[rawEvents count] + 1];
        [eventResult addObject:fakeFirst];
        [eventResult addObjectsFromArray:rawEvents];
        eventsAttachedStartEvent = eventResult;
    } else {
        eventsAttachedStartEvent = rawEvents;
    }
    NSMutableArray *timeUsageArray = [[NSMutableArray alloc] initWithCapacity:eventsAttachedStartEvent.count];
    TSUsageRecord *lastRecord = nil;
    for (TSEvent *event in eventsAttachedStartEvent) {
        if (lastRecord!=nil){
            lastRecord.endTime = event.eventTime;
            [timeUsageArray addObject:lastRecord];
        }
        lastRecord = [[TSUsageRecord alloc]init];
        lastRecord.startTime = event.eventTime;
        lastRecord.actionType = [self getActionTypeForStartEvent:event];
        lastRecord.targetType = [self getTargetTypeForStartEvent:event];
        lastRecord.usageName = lastRecord.actionType==WEB_PAGE?event.pageDomain:event.bundleId;
        lastRecord.identifier = lastRecord.usageName;
    }
    lastRecord.endTime = to;
    [timeUsageArray addObject:lastRecord];
    return timeUsageArray;
}

-(TSActionType)getActionTypeForStartEvent:(TSEvent *)event{
    if (event.bundleId!=nil && event.pageName!=nil){
        return WEB_PAGE;
    }else{
        return APP;
    }
}

-(TSTargetType)getTargetTypeForStartEvent:(TSEvent *)event{
    return WORK;
}

- (NSArray *)applicationsAggregationFrom:(NSTimeInterval)from to:(NSTimeInterval)to orderByDuration:(NSComparisonResult)order {
    return [self aggregationFor:APP From:from to:to orderByDuration:order];
}

- (NSArray *)websitesAggregationFrom:(NSTimeInterval)from to:(NSTimeInterval)to orderByDuration:(NSComparisonResult)order {
    return [self aggregationFor:WEB_PAGE From:from to:to orderByDuration:order];
}

- (NSArray *)aggregationFor:(TSActionType)type From:(NSTimeInterval)from to:(NSTimeInterval)to orderByDuration:(NSComparisonResult)order {
    NSArray *usageRecords = [self usageRecordFrom:from to:to];
    NSMutableDictionary *appDict = [[NSMutableDictionary alloc] initWithCapacity:usageRecords.count/10];
    for (TSUsageRecord *record in usageRecords) {
        if (record.actionType!=type){
            continue;
        }
        TSUsageAggregation *aggregation = appDict[record.identifier];
        if (aggregation==nil){
            aggregation = [[TSUsageAggregation alloc]init];
            aggregation.usageName = record.usageName;
            aggregation.identifier = record.identifier;
            aggregation.duration = record.duration;
            aggregation.actionType = record.actionType;
            aggregation.targetType = record.targetType;
        }
        aggregation.duration +=record.duration;
        appDict[record.identifier]  = aggregation;
    }

    return [appDict.allValues sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        TSUsageAggregation *a = obj1;
        TSUsageAggregation *b = obj2;
        if (a.duration>b.duration){
            return NSOrderedAscending*order;
        }else if(a.duration<b.duration){
            return NSOrderedDescending*order;
        }
        return NSOrderedSame;
    }];
}

+ (NSArray *)parseArray:(FMResultSet *)rs {
    NSMutableArray *eventResult = [[NSMutableArray alloc] initWithCapacity:200];
    while ([rs next]) {
        NSString *bundleId = [rs stringForColumn:@"bundle"];
        NSString *pageName = [rs stringForColumn:@"page"];
        NSTimeInterval timeInterval = [rs doubleForColumn:@"time_millis"];
        TSEvent *event = [[TSEvent alloc] init];
        event.bundleId = bundleId;
        event.pageName = pageName;
        event.eventTime = timeInterval;
        [eventResult addObject:event];
    }
    return eventResult;
}
@end
