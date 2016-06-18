//
//  TSEvent.m
//  TimeSaver
//
//  Created by baidu on 16/5/18.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import "TSEvent.h"

@implementation TSEvent {}
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
    if ([_bundleId isEqualToString:@"com.apple.Safari"] ||
            [_bundleId isEqualToString:@"com.google.Chrome"]){
        NSURL *pageURL = [NSURL URLWithString:pageName];
        if (pageURL==nil){
            _pageDomain = @"UNKNOWN";
        }else{
            _pageDomain = pageURL.host;
            if (_pageDomain==nil){
                NSString *scheme = pageURL.scheme;
                if (scheme!=nil) {
                    _pageDomain = scheme;
                }else{
                    if (pageName==nil){
                        _pageDomain = @"UNKNOWN";
                    }else {
                        _pageDomain=pageName;
                    }
                }
            }
        }
    }else{

    }
}
-(NSString *)description{
    return [NSString stringWithFormat:@"%@\t%@\t%f",self.bundleId,self.pageDomain,self.eventTime];
}
@end
