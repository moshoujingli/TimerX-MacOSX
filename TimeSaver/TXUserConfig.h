//
//  TXUserConfig.h
//  TimeSaver
//
//  Created by baidu on 16/5/30.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXUserConfig : NSObject
@property NSInteger currentUserFunctionTab;
@property NSDate *startDateOverUI;
@property NSDate *endDateOverUI;
+(instancetype)sharedConfig;
-(void)requestTimeIntervalRefresh;
-(void)requireTimeInterval:(id) user notificateBy:(SEL) selector;
-(void)releaseTimeIntervalRequire:(id)user;
@end
