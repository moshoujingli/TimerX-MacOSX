//
//  TSEvent.h
//  TimeSaver
//
//  Created by baidu on 16/5/18.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface TSEvent : NSObject
@property NSTimeInterval eventTime;
@property NSString *bundleId;
@property(nonatomic) NSString *pageName;
@property(nonatomic) NSString *pageDomain;
+ (instancetype)enterEventWithBundle:(NSString *)bundleId withPage:(NSString *)pageURL;
@end
