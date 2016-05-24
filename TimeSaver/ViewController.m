//
//  ViewController.m
//  TimeSaver
//
//  Created by baidu on 16/5/17.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import "ViewController.h"
#import <FMDB.h>
#import "TSEvent.h"

@interface ViewController()
@property (strong)FMDatabase *db;
@property (strong)NSTextField *result;
@property (strong)NSDatePicker *startDatePicker;
@property (strong)NSDatePicker *endDatePocker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.db = [FMDatabase databaseWithPath:@"/Users/baidu/test_time/time_line.db"];
    if (![self.db open]) {
        NSLog(@"db open error!");
        exit(255);
    }
    self.startDatePicker = [[NSDatePicker alloc]initWithFrame:NSMakeRect(0, 0, 100, 100)];
    [self.startDatePicker setDateValue:[[NSDate alloc]init]];
    [self.view addSubview:self.startDatePicker];
    
    self.endDatePocker = [[NSDatePicker alloc]initWithFrame:NSMakeRect(101, 0, 100, 100)];
    [self.endDatePocker setDateValue:[[NSDate alloc]init]];
    [self.view addSubview:self.endDatePocker];
    
    NSButton *button = [[NSButton alloc] initWithFrame:NSMakeRect(201, 0, 100, 100)];
    [button setTarget:self];
    [button setAction:@selector(reloadButtonCLicked:)];
    [self.view addSubview:button];
    
//    self.startDatePicker.delegate = self;
    
    // Do any additional setup after loading the view.
}

-(void)reloadButtonCLicked:(NSButton*) button{
    [self reload];
}

-(void)reload{
    NSTimeInterval startMillis = [self.startDatePicker.dateValue timeIntervalSinceReferenceDate];
    NSTimeInterval endMillis = [self.endDatePocker.dateValue timeIntervalSinceReferenceDate];
    FMResultSet *rs = [self.db executeQuery:@"select * from app_time_line where time_millis between ? and ? order by time_millis asc",[NSNumber numberWithDouble:startMillis],[NSNumber numberWithDouble:endMillis] ] ;

    NSArray *events = [TSEvent parseArray:rs];
    TSEvent *lastEvent = events.lastObject;
    NSTimeInterval nowMilli = CFAbsoluteTimeGetCurrent();
    if (nowMilli<endMillis) {
        lastEvent.end = nowMilli;
    }else{
        lastEvent.end =  endMillis;
    }
    
    for (TSEvent *event in events) {
        NSLog(@"%@\t%@\t%f",event.bundleName,event.pageDomain,(event.end - event.start));
    }
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
@end
