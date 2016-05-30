//
//  TSMacStatesObserver.h
//  TimeSaver
//
//  Created by BiXiaopeng on 16/5/24.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSMacStatesObserver : NSObject
+(instancetype)sharedObserver;
-(void)startObserve;
-(void)stopObserve;
@end
