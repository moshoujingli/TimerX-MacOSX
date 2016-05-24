//
//  TSEvent.m
//  TimeSaver
//
//  Created by baidu on 16/5/18.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import "TSEvent.h"

@implementation TSEvent
@synthesize pageName = _pageName;
@synthesize pageDomain = _pageDomain;

-(void)setPageName:(NSString *)pageName{
    _pageName = pageName;
    _pageDomain = [NSURL URLWithString:pageName].host;
}

+(NSArray *)parseArray:(FMResultSet *)rs{
    NSMutableArray *eventResult = [[NSMutableArray alloc]initWithCapacity:200];
    TSEvent *lastEvent = nil;
    while ([rs next]) {
        NSString *bundleName = [rs stringForColumnIndex:0];
        NSString *pageName = [rs stringForColumnIndex:1];
        NSTimeInterval timeInterval = [rs doubleForColumnIndex:2];
        
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
