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

+(instancetype)enterEventWithBundle:(NSString *)bundleId withPage:(NSString *)pageURL{
    TSEvent *event = [[TSEvent alloc]init];
    event.bundleId = bundleId;
    event.pageName = pageURL;
    return event;
}
-(void)setPageName:(NSString *)pageName{
    _pageName = pageName;
    _pageDomain = [NSURL URLWithString:pageName].host;
    if (_pageDomain==nil){
        _pageDomain = [NSURL URLWithString:pageName].scheme;
    }
}
-(NSString *)description{
    return [NSString stringWithFormat:@"%@\t%@\t%f",self.bundleId,self.pageDomain,self.eventTime];
}
@end
