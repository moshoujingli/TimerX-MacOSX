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
    NSArray *aggr = nil;
    if ([type isEqualToString:@"app"]) {
        aggr = [[TSEventManager sharedManager] applicationsAggregationFrom:startMillis to:endMillis orderByDuration:NSOrderedDescending];
    }else{
        aggr = [[TSEventManager sharedManager] websitesAggregationFrom:startMillis to:endMillis orderByDuration:NSOrderedDescending];
    }
    NSMutableArray *filtedResult = [[NSMutableArray alloc] initWithCapacity:aggr.count];
    for (TSUsageAggregation *usageAggregation in aggr) {
        if ([usageAggregation.identifier isEqualToString:@"com.apple.loginwindow"] ||
                [usageAggregation.identifier isEqualToString:@"com.apple.ScreenSaver.Engine"] ){
            continue;
        }
        [filtedResult addObject:usageAggregation];
    }

    if ([type isEqualToString:@"app"]) {
        [self.appTimePieChart setEventList:filtedResult];
    }else{
        [self.webTimePieChart setEventList:filtedResult];
    }
    NSMutableArray *results = [[NSMutableArray alloc] initWithCapacity:filtedResult.count];
    for (TSUsageAggregation *statEvent in filtedResult) {
        NSString * statKey= statEvent.usageName;
        [results addObject:[NSString stringWithFormat:@"%@\t%f",statKey,statEvent.duration]];
    }
    if ([type isEqualToString:@"app"]) {
        [self.appDataArea setStringValue:[results componentsJoinedByString:@"\n"]];
    }else{
        [self.webDataArea setStringValue:[results componentsJoinedByString:@"\n"]];
    }
    
}

@end
