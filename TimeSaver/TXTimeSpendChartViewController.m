//
//  TXTimeSpendChartViewController.m
//  TimeSaver
//
//  Created by baidu on 16/5/30.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import "TXTimeSpendChartViewController.h"
#import "TXUserConfig.h"
#import "TSEventManager.h"

@interface TXTimeSpendChartViewController ()

@end

@implementation TXTimeSpendChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [[TXUserConfig sharedConfig]requireTimeInterval:self notificateBy:@selector(reload)];
}

-(void)reload{
    [self reload:@"app"];
    [self reload:@"web"];
}
-(void)reload:(NSString *)type{
    TXUserConfig * sharedConfig = [TXUserConfig sharedConfig];
    NSTimeInterval startMillis = [sharedConfig.startDateOverUI timeIntervalSinceReferenceDate];
    NSTimeInterval endMillis = [sharedConfig.endDateOverUI timeIntervalSinceReferenceDate];
    
    TSEventManager *sharedManager = [TSEventManager sharedManager];
    NSDictionary *aggrInfo = nil;
    if ([type isEqualToString:@"app"]) {
        aggrInfo =[sharedManager appsFrom:startMillis to:endMillis];
    }else{
        aggrInfo =[sharedManager websitesFrom:startMillis to:endMillis];
    }
    
    NSArray *statKeys = [aggrInfo allKeys];
    NSMutableArray *results = [[NSMutableArray alloc]initWithCapacity:statKeys.count];
    for (NSString *statKey in statKeys) {
        TSEvent *aggrEvent = [aggrInfo objectForKey:statKey];
        [results addObject:[NSString stringWithFormat:@"%@\t%f",statKey,aggrEvent.end]];
    }
    if ([type isEqualToString:@"app"]) {
        [self.appDataArea setStringValue:[results componentsJoinedByString:@"\n"]];
    }else{
        [self.webDataArea setStringValue:[results componentsJoinedByString:@"\n"]];
    }
    
}

@end
