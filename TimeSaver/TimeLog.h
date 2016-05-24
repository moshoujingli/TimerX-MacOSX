//
//  TimeLog.h
//  TestProj
//
//  Created by baidu on 16/5/17.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeLog : NSObject
+(instancetype)getInstance;
-(void)savePage:(NSString *) pageName forApp:(NSString *)bundleId withTimeStamp:(NSTimeInterval) millis;
@end
