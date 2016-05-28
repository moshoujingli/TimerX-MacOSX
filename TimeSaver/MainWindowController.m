//
//  MainWindowController.m
//  TimeSaver
//
//  Created by baidu on 16/5/27.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import "MainWindowController.h"
#import "ViewController.h"

@interface MainWindowController ()

@end

@implementation MainWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.window.backgroundColor = [NSColor whiteColor];
    self.window.title=@"TimerX";
    NSLog(@"%s,%@",__FILE__,NSStringFromRect(self.window.frame));
}

@end
