//
//  AppDelegate.m
//  TimeSaver
//
//  Created by baidu on 16/5/15.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "AppDelegate.h"
#import "TSMacStatesObserver.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@end


@implementation AppDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [[TSMacStatesObserver sharedObserver]startObserve];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    [[TSMacStatesObserver sharedObserver]stopObserve];
}

@end
