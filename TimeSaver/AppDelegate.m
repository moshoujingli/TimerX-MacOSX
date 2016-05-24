//
//  AppDelegate.m
//  TimeSaver
//
//  Created by baidu on 16/5/15.
//  Copyright © 2016年 baidu. All rights reserved.
//

#import "AppDelegate.h"
#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>
#import "Safari.h"
#import "Chrome.h"
#import "TimeLog.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@property NSThread *browserLoopThread;
@property (nonatomic,strong)TimeLog *timeLog;
@end


@implementation AppDelegate
@synthesize timeLog = _timeLog;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSLog(@"open");
    self.timeLog = [TimeLog getInstance];
    [[NSWorkspace sharedWorkspace].notificationCenter addObserver:self selector:@selector(appChange:) name:NSWorkspaceDidActivateApplicationNotification object:nil];
    [self fileNotifications];
    
    //    safari.window
    // Insert code here to initialize your application
}

-(void)webPageRefresh{
    NSLog(@"start");
    while (![NSThread currentThread].isCancelled) {
        SafariApplication *safari = [SBApplication applicationWithBundleIdentifier:@"com.apple.Safari"];
        [self.timeLog savePage:[[[safari.windows objectAtIndex:0]currentTab] URL] forApp:@"com.apple.Safari" withTimeStamp:CFAbsoluteTimeGetCurrent()];
        
        sleep(2);
    }
}

-(void)webPageRefreshChrome{
    NSLog(@"start");
    while (![NSThread currentThread].isCancelled) {
        ChromeApplication *chrome = [SBApplication applicationWithBundleIdentifier:@"com.google.Chrome"];
        ChromeWindow *currentWindow = [chrome.windows objectAtIndex:0];
        ChromeTab *currentTab = [currentWindow.tabs objectAtIndex:currentWindow.activeTabIndex];
        //
        [self.timeLog savePage:currentTab.URL forApp:@"com.google.Chrome" withTimeStamp:CFAbsoluteTimeGetCurrent()];
        sleep(2);
    }
}

-(void)appChange:(NSNotification *)notification{
    NSRunningApplication *app = notification.userInfo[NSWorkspaceApplicationKey];
    //    NSLog(@"name %@",app.localizedName);
    NSLog(@"name %@",app.bundleIdentifier);
    [self.timeLog savePage:nil forApp:app.bundleIdentifier withTimeStamp:CFAbsoluteTimeGetCurrent()];
    
    [self.browserLoopThread cancel];
    if ([app.localizedName isEqualToString:@"Safari"]) {
        self.browserLoopThread = [[NSThread alloc]initWithTarget:self selector:@selector(webPageRefresh) object:nil];
        [self.browserLoopThread start];
    }else if ([app.localizedName isEqualToString:@"Google Chrome"]) {
        self.browserLoopThread = [[NSThread alloc]initWithTarget:self selector:@selector(webPageRefreshChrome) object:nil];
        [self.browserLoopThread start];
    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
    NSLog(@"finish");
    
}
- (void) receiveSleepNote: (NSNotification*) note
{
    NSLog(@"receiveSleepNote: %@", [note name]);
}

- (void) receiveWakeNote: (NSNotification*) note
{
    NSLog(@"receiveWakeNote: %@", [note name]);
}

- (void) fileNotifications
{
    //These notifications are filed on NSWorkspace's notification center, not the default
    // notification center. You will not receive sleep/wake notifications if you file
    //with the default notification center.
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                           selector: @selector(receiveSleepNote:)
                                                               name: NSWorkspaceWillSleepNotification object: NULL];
    
    [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self
                                                           selector: @selector(receiveWakeNote:)
                                                               name: NSWorkspaceDidWakeNotification object: NULL];
}

@end
