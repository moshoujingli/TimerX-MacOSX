//
//  TSEventManager.h
//  TimeSaver
//
//  Created by BiXiaopeng on 16/5/24.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSEvent.h"
#import "TSUsageRecord.h"
#import "TSUsageAggregation.h"
@interface TSEventManager : NSObject
+ (instancetype)sharedManager;

- (void)saveEvent:(TSEvent *)event at:(NSTimeInterval)timestamp;

- (void)saveEventNow:(TSEvent *)event;

//return event in db
- (NSArray *)rawEventsFrom:(NSTimeInterval)from to:(NSTimeInterval)to;

- (NSArray *)usageRecordFrom:(NSTimeInterval)from to:(NSTimeInterval)to;

- (NSArray *)applicationsAggregationFrom:(NSTimeInterval)from to:(NSTimeInterval)to orderByDuration:(NSComparisonResult)order;

- (NSArray *)websitesAggregationFrom:(NSTimeInterval)from to:(NSTimeInterval)to orderByDuration:(NSComparisonResult)order;
@end
