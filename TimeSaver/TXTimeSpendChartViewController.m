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
#import "TXPieChartView.h"
#import "Masonry.h"
@interface TXTimeSpendChartViewController ()

@property (strong) TXPieChartView *appTimePieChart;
@property (strong) TXPieChartView *webTimePieChart;

@end

@implementation TXTimeSpendChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    [[TXUserConfig sharedConfig]requireTimeInterval:self notificateBy:@selector(reload)];
    __weak TXTimeSpendChartViewController *weakSelf = self;
    TXPieChartView *pieChartView = [[TXPieChartView alloc] init];
    [self.view addSubview:pieChartView];

    [pieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.height.equalTo(@200);
        make.centerX.equalTo(weakSelf.appDataArea.mas_centerX);
        make.bottom.equalTo(weakSelf.appDataArea.mas_top).with.offset(5);

    }];
    self.appTimePieChart = pieChartView;

    pieChartView = [[TXPieChartView alloc] init];
    [self.view addSubview:pieChartView];
    
    [pieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.height.equalTo(@200);
        make.centerX.equalTo(weakSelf.webDataArea.mas_centerX);
        make.bottom.equalTo(weakSelf.webDataArea.mas_top).with.offset(5);
    }];
    self.webTimePieChart = pieChartView;
    
    
}

-(void)reload{
    [self reload:@"web"];
    [self reload:@"app"];

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
        TSEvent *aggrEvent = aggrInfo[statKey];
        if([statKey isEqualToString: @"com.apple.loginwindow"]
        || [statKey isEqualToString: @"com.apple.ScreenSaver.Engine"]){
            continue;
        }
        [results addObject:[NSString stringWithFormat:@"%@\t%f",statKey,aggrEvent.end]];
    }
    if ([type isEqualToString:@"app"]) {
        [self.appDataArea setStringValue:[results componentsJoinedByString:@"\n"]];
    }else{
        [self.webDataArea setStringValue:[results componentsJoinedByString:@"\n"]];
    }

    NSArray *sorted = [aggrInfo.allValues sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        TSEvent *a = obj1;
        TSEvent *b = obj2;
        if (a.end>b.end){
            return NSOrderedAscending;
        }else if(a.end<b.end){
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    
    if ([type isEqualToString:@"app"]) {
        [self.appTimePieChart setEventList:sorted];
    }else{
        [self.webTimePieChart setEventList:sorted];
    }
    
}

@end
