//
// Created by baidu on 16/6/14.
// Copyright (c) 2016 tivo2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TSUsageRecord.h"

@interface TSUsageAggregation : NSObject
@property NSString *usageName;
@property NSString *identifier;
@property NSTimeInterval duration;
@property TSActionType actionType;
@property TSTargetType targetType;

-(instancetype)initFrom:(TSUsageAggregation *)aggregation;

@end