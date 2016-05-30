//
//  TXTimeSpendPanelViewController.h
//  TimeSaver
//
//  Created by baidu on 16/5/30.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TXTimeIntervalSelectPanelViewController : NSViewController <NSDatePickerCellDelegate>
@property (strong) NSTextField *result;
@property (strong) IBOutlet NSDatePicker *startDatePicker;
@property (strong) IBOutlet NSDatePicker *endDatePocker;
@property (strong) IBOutlet NSButton *refreshBtn;
@end
