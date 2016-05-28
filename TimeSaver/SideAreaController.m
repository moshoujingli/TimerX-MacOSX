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
#import "NSView+Background.h"

#define TAB_HEIGHT 100
#define USER_INFO_HEIGHT 150

@interface SideAreaController ()

@property NSArray *functions;

@end

@implementation SideAreaController
- (void)tableViewSelectionDidChange:(NSNotification *)aNotification{
    NSLog(@"%ld",(long)self.functionTabs.selectedRow);
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return 3;
}
- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    NSTableCellView *labelContainer= [tableView makeViewWithIdentifier:@"function_cell" owner:self];
    labelContainer.textField.stringValue = self.functions[row];
    return labelContainer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //add user profile
    self.functions = @[@"时间线",@"分配统计",@"变化趋势"];
    NSView *spView = self.view;
    __weak SideAreaController *weakSelf = self;
    NSLog(@"%s,%@",__FILE__,NSStringFromRect(spView.frame));
    [self.container mas_updateConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(spView);
        make.top.equalTo(spView);
        make.size.equalTo(spView);
    }];
    
    [self.userView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(spView);
        make.top.equalTo(spView);
        make.leading.equalTo(spView);
        make.height.lessThanOrEqualTo(@80);
    }];
    [self.tabContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(spView);
        make.top.equalTo(weakSelf.userView.mas_bottom);
        make.leading.equalTo(spView);
        make.bottom.equalTo(spView);
    }];
//    [self.functionTabs mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(weakSelf.tabContainer);
//        make.leading.equalTo(weakSelf.tabContainer);
//        make.size.equalTo(weakSelf.tabContainer);
//    }];
    
    
//    [spView setFrameSize:NSMakeSize(240, 540)];

//    __weak SideAreaController *weakSelf = self;
//    NSView *userInfoArea = [[NSView alloc]init];
//    [spView addSubview:userInfoArea];
//    [userInfoArea mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(spView);
//        make.leading.equalTo(spView);
//        make.trailing.equalTo(spView);
//        make.height.equalTo(@USER_INFO_HEIGHT);
//    }];
//    [userInfoArea setBackgroundColor:[NSColor colorWithSRGBRed:84/255.0f green:98/255.0f blue:188/255.0f alpha:1.0f]];
//    NSLog(@"%s,%@",__FILE__,NSStringFromRect(self.view.frame));

    
//    
//    
//    
//    [self.view addSubview:tabTable];
//    tabTable.dataSource = self;
//    tabTable.delegate =self;
//    [tabTable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(userInfoArea.mas_bottom);
//        make.leading.equalTo(spView);
//        make.width.equalTo(spView);
//        make.bottom.equalTo(spView);
//    }];
//    self.tabTable = tabTable;
    NSLog(@"%s,%@",__FILE__,NSStringFromRect(self.view.frame));

//    //add time line
//    self.timeLineTab = [[NSView alloc]init];
//    [self.view addSubview:self.timeLineTab];
//    [self.timeLineTab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(spView);
//        make.trailing.equalTo(spView);
//        make.top.equalTo(spView);
//        make.height.equalTo(@TAB_HEIGHT);
//    }];
//    [tabTable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.timeLineTab.mas_bottom);
//        make.leading.equalTo(spView);
//        make.trailing.equalTo(spView);
//        make.bottom.equalTo(spView);
//    }];
//    
//    NSLabel *timeLineLabel = [[NSLabel alloc]init];
//    [self.timeLineTab addSubview:timeLineLabel];
//
//    [timeLineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(self.timeLineTab);
//        make.trailing.equalTo(self.timeLineTab);
//        make.top.equalTo(self.timeLineTab);
//        make.height.equalTo(@TAB_HEIGHT);
//    }];
//    
//    timeLineLabel.stringValue=@"Time Line";
//    
//    //add pi
//    
//    self.timeSpendTab = [[NSView alloc]init];
//    NSLabel *timeSpendLabel = [[NSLabel alloc]init];
//    timeSpendLabel.stringValue=@"Time Spend";
//
    
    //add hint and setting
    //other...
}

@end
