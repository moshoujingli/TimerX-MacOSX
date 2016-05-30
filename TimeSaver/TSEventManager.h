//
//  TSEventManager.h
//  TimeSaver
//
//  Created by BiXiaopeng on 16/5/24.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSEvent.h"

@interface TSEventManager : NSObject
+(instancetype)sharedManager;
-(void)event:(TSEvent *)event at:(NSTimeInterval)timestamp;
-(void)eventNow:(TSEvent *)event;
//return event in db
-(NSArray *)rawEventsFrom:(NSTimeInterval) from to:(NSTimeInterval) to;
//return event in db,with a fake event (start),the fake event has the pre apps info
-(NSArray *)eventsFrom:(NSTimeInterval) from to:(NSTimeInterval) to;
-(NSDictionary *)appsFrom:(NSTimeInterval) from to:(NSTimeInterval) to;
-(NSDictionary *)websitesFrom:(NSTimeInterval) from to:(NSTimeInterval) to;
@end
