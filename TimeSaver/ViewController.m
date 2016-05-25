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
    self.startDatePicker = [[NSDatePicker alloc]initWithFrame:NSMakeRect(0, 0, 200, 100)];
    [self.startDatePicker setDateValue:[[NSDate alloc]init]];
    [self.view addSubview:self.startDatePicker];
    
    self.endDatePocker = [[NSDatePicker alloc]initWithFrame:NSMakeRect(201, 0, 200, 100)];
    [self.endDatePocker setDateValue:[[NSDate alloc]init]];
    [self.view addSubview:self.endDatePocker];
    
    NSButton *buttonApp = [[NSButton alloc] initWithFrame:NSMakeRect(401, 0, 100, 100)];
    [buttonApp setTitle:@"app"];
    [buttonApp setTarget:self];
    [buttonApp setAction:@selector(reloadButtonCLicked:)];
    [self.view addSubview:buttonApp];
    
    NSButton *buttonWeb = [[NSButton alloc] initWithFrame:NSMakeRect(501, 0, 100, 100)];
    [buttonWeb setTitle:@"web"];
    [buttonWeb setTarget:self];
    [buttonWeb setAction:@selector(reloadButtonCLicked:)];
    [self.view addSubview:buttonWeb];
    
    self.result = [[NSTextField alloc]initWithFrame:NSMakeRect(0, 200, 300, 100)];
    [self.view addSubview:self.result];
    
//    self.startDatePicker.delegate = self;
    
    // Do any additional setup after loading the view.
}

-(void)reloadButtonCLicked:(NSButton*) button{
    [self reload:button.title];
}

-(void)reload:(NSString *)type{
    NSTimeInterval startMillis = [self.startDatePicker.dateValue timeIntervalSinceReferenceDate];
    NSTimeInterval endMillis = [self.endDatePocker.dateValue timeIntervalSinceReferenceDate];

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
 
    [self.result setStringValue:[results componentsJoinedByString:@"\n"]];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}
@end
