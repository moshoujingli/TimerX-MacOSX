//
// Created by baidu on 16/6/14.
// Copyright (c) 2016 tivo2. All rights reserved.
//

#import "TSUsageAggregation.h"


@implementation TSUsageAggregation {

}
-(instancetype)initFrom:(TSUsageAggregation *)aggregation {
    self = [super init];
    if (self!=nil){
        self.usageName = aggregation.usageName;
        self.identifier = aggregation.identifier;
        self.duration = aggregation.duration;
        self.actionType = aggregation.actionType;
        self.targetType = aggregation.targetType;
    }
    return self;
}

@end