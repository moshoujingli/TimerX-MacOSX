//
//  TXTimeSpendPanelViewController.m
//  TimeSaver
//
//  Created by baidu on 16/5/30.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import "TXTimeIntervalSelectPanelViewController.h"
#import <FMDB.h>
#import "TSEventManager.h"
#import "TXUserConfig.h"

@interface TXTimeIntervalSelectPanelViewController ()

@end

@implementation TXTimeIntervalSelectPanelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.startDatePicker = [[NSDatePicker alloc]initWithFrame:NSMakeRect(0, 0, 200, 100)];
    [self.startDatePicker setDateValue:[[NSDate alloc]initWithTimeIntervalSinceNow:-3600*24]];
    [self.view addSubview:self.startDatePicker];
//
//    self.endDatePocker = [[NSDatePicker alloc]initWithFrame:NSMakeRect(201, 0, 200, 100)];
    [self.endDatePocker setDateValue:[[NSDate alloc]init]];
    [self.view addSubview:self.endDatePocker];
//
//    NSButton *buttonApp = [[NSButton alloc] initWithFrame:NSMakeRect(401, 0, 100, 100)];
//    [buttonApp setTitle:@"app"];
//    [buttonApp setTarget:self];
//    [buttonApp setAction:@selector(reloadButtonCLicked:)];
//    [self.view addSubview:buttonApp];
//    
//    NSButton *buttonWeb = [[NSButton alloc] initWithFrame:NSMakeRect(501, 0, 100, 100)];
//    [buttonWeb setTitle:@"web"];
//    [buttonWeb setTarget:self];
//    [buttonWeb setAction:@selector(reloadButtonCLicked:)];
//    [self.view addSubview:buttonWeb];
//    
//    self.result = [[NSTextField alloc]initWithFrame:NSMakeRect(0, 200, 300, 100)];
    [self.view addSubview:self.result];
    
    //    self.startDatePicker.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}
-(IBAction)refreshDateInterval:(id)sender{
    TXUserConfig *sharedConfig = [TXUserConfig sharedConfig];
    sharedConfig.startDateOverUI = self.startDatePicker.dateValue;
    sharedConfig.endDateOverUI = self.endDatePocker.dateValue;
    [sharedConfig requestTimeIntervalRefresh];
}
@end
