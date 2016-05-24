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

@property NSTimeInterval start;
@property NSTimeInterval end;
@property NSString *bundleName;
@property (nonatomic) NSString *pageName;
@property (nonatomic) NSString *pageDomain;

+(NSArray *)parseArray:(FMResultSet *)rs;


@end
