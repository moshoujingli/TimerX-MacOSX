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

+(instancetype)enterEventWithBundle:(NSString *)bundleName withPage:(NSString *)pageURL{
    TSEvent *event = [[TSEvent alloc]init];
    event.bundleName = bundleName;
    event.pageName = pageURL;
    event.type = ENTER;
    return event;
}

+(instancetype)aggrEventWithBundle:(NSString *)bundleName{
    TSEvent *event = [[TSEvent alloc]init];
    event.bundleName = bundleName;
    event.type = AGGR;
    event.start=0;
    event.end=0;
    return event;
}
+(instancetype)aggrEventWithPageDomain:(NSString *)domainName{
    TSEvent *event = [[TSEvent alloc]init];
    event.pageDomain = domainName;
    event.type = AGGR;
    event.start=0;
    event.end=0;
    return event;
}
-(void)setPageName:(NSString *)pageName{
    _pageName = pageName;
    _pageDomain = [NSURL URLWithString:pageName].host;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"%@\t%@\t%f",self.bundleName,self.pageDomain,self.start];
}
@end
