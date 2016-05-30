//
//  TXUserConfig.m
//  TimeSaver
//
//  Created by baidu on 16/5/30.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import "TXUserConfig.h"

@implementation TXUserConfig
+(instancetype)sharedConfig{
    static TXUserConfig *sharedConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfig = [[self alloc] init];
    });
    return sharedConfig;
}
-(void)requestTimeIntervalRefresh{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"request_time_change" object:nil userInfo:nil];
}
-(void)requireTimeInterval:(id) user notificateBy:(SEL) selector{
    [[NSNotificationCenter defaultCenter] addObserver:user selector:selector name:@"request_time_change" object:nil];
}
-(void)releaseTimeIntervalRequire:(id)user{
    [[NSNotificationCenter defaultCenter] removeObserver:user];
}
@end
