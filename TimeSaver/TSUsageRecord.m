//
// Created by baidu on 16/6/14.
// Copyright (c) 2016 tivo2. All rights reserved.
//

#import "TSUsageRecord.h"

@interface TSUsageRecord()

@end


@implementation TSUsageRecord {
}
@synthesize duration = _duration;
-(NSTimeInterval)duration {
    return self.endTime - self.startTime;
}
@end