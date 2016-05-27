//
//  SideAreaController.m
//  TimeSaver
//
//  Created by baidu on 16/5/27.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import "SideAreaController.h"
#import "NSLabel.h"
#import "Masonry.h"

#define TAB_HEIGHT 200

@interface SideAreaController ()

@property NSView *timeLineTab;
@property NSView *timeSpendTab;

@end

@implementation SideAreaController

- (void)viewDidLoad {
    [super viewDidLoad];
    //add user profile
    
    NSView *spView = self.view;
    //add time line
    self.timeLineTab = [[NSView alloc]init];
    [self.view addSubview:self.timeLineTab];
    [self.timeLineTab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(spView);
        make.trailing.equalTo(spView);
        make.top.equalTo(spView);
        make.height.equalTo(@TAB_HEIGHT);
    }];
    
    
    NSLabel *timeLineLabel = [[NSLabel alloc]init];
    [self.timeLineTab addSubview:timeLineLabel];

    [timeLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.timeLineTab);
        make.trailing.equalTo(self.timeLineTab);
        make.top.equalTo(self.timeLineTab);
        make.height.equalTo(@TAB_HEIGHT);
    }];
    
    timeLineLabel.stringValue=@"Time Line";
    
    //add pi
    
    self.timeSpendTab = [[NSView alloc]init];
    NSLabel *timeSpendLabel = [[NSLabel alloc]init];
    timeSpendLabel.stringValue=@"Time Spend";

    
    //add hint and setting
    //other...
}

@end
