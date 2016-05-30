//
//  TSEvent.h
//  TimeSaver
//
//  Created by baidu on 16/5/18.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

typedef enum : NSUInteger {
    ENTER,
    EXIT,
    AGGR
} TSEventType;

@interface TSEvent : NSObject

@property NSTimeInterval start;
@property NSTimeInterval end;
@property NSString *bundleName;
@property (nonatomic) NSString *pageName;
@property (nonatomic) NSString *pageDomain;
@property TSEventType type;


+(instancetype)enterEventWithBundle:(NSString *)bundleName withPage:(NSString *)pageURL;
+(instancetype)aggrEventWithBundle:(NSString *)bundleName;
+(instancetype)aggrEventWithPageDomain:(NSString *)domainName;

@end
