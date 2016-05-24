//
//  ViewController.m
//  TimeSaver
//
//  Created by baidu on 16/5/17.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import "ViewController.h"
#import <FMDB.h>
#import "TSEventManager.h"

@interface ViewController()
@property (strong)NSTextField *result;
@property (strong)NSDatePicker *startDatePicker;
@property (strong)NSDatePicker *endDatePocker;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    
    self.result = [[NSTextField alloc]initWithFrame:NSMakeRect(0, 200, 300, 100)];
    [self.view addSubview:self.result];
    
//    self.startDatePicker.delegate = self;
    
    // Do any additional setup after loading the view.
}

-(void)reloadButtonCLicked:(NSButton*) button{
    [self reload];
}

-(void)reload{
    NSTimeInterval startMillis = [self.startDatePicker.dateValue timeIntervalSinceReferenceDate];
    NSTimeInterval endMillis = [self.endDatePocker.dateValue timeIntervalSinceReferenceDate];

    TSEventManager *sharedManager = [TSEventManager sharedManager];
    NSDictionary *appsInfo = [sharedManager appsFrom:startMillis to:endMillis];
	NSArray *bundleIds = [appsInfo allKeys];
    NSMutableArray *results = [[NSMutableArray alloc]initWithCapacity:bundleIds.count];
    for (NSString *bundleId in bundleIds) {
        TSEvent *aggrEvent = [appsInfo objectForKey:bundleId];
        [results addObject:[NSString stringWithFormat:@"%@\t%f",bundleId,aggrEvent.end]];
    }
 
    [self.result setStringValue:[results componentsJoinedByString:@"\n"]];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
@end
