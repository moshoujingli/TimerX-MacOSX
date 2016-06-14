//
// Created by baidu on 16/6/14.
// Copyright (c) 2016 tivo2. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    APP,
    WEB_PAGE,
    MOTION,
    NONE
} TSActionType;
typedef enum : NSUInteger {
    WORK,
    LIFE
} TSTargetType;

@interface TSUsageRecord : NSObject
@property NSString *usageName;
@property NSString *identifier;
@property TSActionType actionType;
@property TSTargetType targetType;

@property NSTimeInterval startTime;
@property NSTimeInterval endTime;
@property(readonly) NSTimeInterval duration;
@end