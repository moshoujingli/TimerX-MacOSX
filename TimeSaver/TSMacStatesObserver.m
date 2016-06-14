//
//  TSMacStatesObserver.m
//  TimeSaver
//
//  Created by BiXiaopeng on 16/5/24.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import "TSMacStatesObserver.h"
#import <AppKit/AppKit.h>
#import <ScriptingBridge/ScriptingBridge.h>
#import "Safari.h"
#import "Chrome.h"
#import "TSEventManager.h"

#define DEVICE_SLEEP @"system.sleep"
#define NOT_RUNNING @"app.closed"


@interface TSMacStatesObserver()
@property (strong)NSThread *tabLoopThread;
@property (strong)TSEventManager *eventManager;
@end

@implementation TSMacStatesObserver
+(instancetype)sharedObserver{
    static TSMacStatesObserver *sharedObserver = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObserver = [[self alloc] init];
    });
    return sharedObserver;
}

-(instancetype)init{
    self=[super init];
    if(self!=nil){
        self.eventManager = [TSEventManager sharedManager];
    }
    return self;
}

-(void)startObserve{
    [self logEventForBundle:NOT_RUNNING page:nil];
    NSNotificationCenter *workspaceNotificationCenter = [NSWorkspace sharedWorkspace].notificationCenter;
    [workspaceNotificationCenter addObserver:self
                                 selector:@selector(appChange:)
                                     name:NSWorkspaceDidActivateApplicationNotification
                                   object:nil];

    [workspaceNotificationCenter addObserver: self
                               selector: @selector(receiveSleepNote:)
                                   name: NSWorkspaceWillSleepNotification object: NULL];
    
    [workspaceNotificationCenter addObserver: self
                                   selector: @selector(receiveWakeNote:)
                                       name: NSWorkspaceDidWakeNotification object: NULL];
	
}
-(void)stopObserve{
    NSNotificationCenter *workspaceNotificationCenter = [NSWorkspace sharedWorkspace].notificationCenter;
    [workspaceNotificationCenter removeObserver:self];
    [self.tabLoopThread cancel];
    [self logEventForBundle:NOT_RUNNING page:nil];
}
-(void)safariWebPageRefresh{
    NSString *safariBundleId = @"com.apple.Safari";
    while (![NSThread currentThread].isCancelled) {
        SafariApplication *safari = [SBApplication applicationWithBundleIdentifier:safariBundleId];
        [self logEventForBundle:safariBundleId page:[[[safari.windows objectAtIndex:0]currentTab] URL]];
        sleep(2);
    }
}

-(void)chromeWebPageRefresh{
    NSString *safariBundleId = @"com.google.Chrome";
    while (![NSThread currentThread].isCancelled) {
        ChromeApplication *chrome = [SBApplication applicationWithBundleIdentifier:safariBundleId];
        ChromeWindow *currentWindow = [chrome.windows objectAtIndex:0];
        ChromeTab *currentTab = [currentWindow.tabs objectAtIndex:currentWindow.activeTabIndex];
        [self logEventForBundle:safariBundleId page:currentTab.URL];
        sleep(2);
    }
}
-(void)appChange:(NSNotification *)notification{
    NSRunningApplication *app = notification.userInfo[NSWorkspaceApplicationKey];
    [self.tabLoopThread cancel];
    BOOL hasTabs = NO;
    SEL tabLoop = nil;
    if ([app.bundleIdentifier isEqualToString:@"com.apple.Safari"]) {
        hasTabs = YES;
        tabLoop = @selector(safariWebPageRefresh);
    }else if ([app.bundleIdentifier isEqualToString:@"com.google.Chrome"]) {
        hasTabs = YES;
        tabLoop = @selector(chromeWebPageRefresh);
    }
    if (hasTabs) {
        self.tabLoopThread = [[NSThread alloc]initWithTarget:self selector:tabLoop object:nil];
        [self.tabLoopThread start];
    }else{
        [self logEventForBundle:app.bundleIdentifier page:nil];
    }
    
  }

- (void) receiveSleepNote: (NSNotification*) note
{
    NSLog(@"receiveSleepNote: %@", [note name]);
    [self logEventForBundle:DEVICE_SLEEP page:nil];
}

- (void) receiveWakeNote: (NSNotification*) note
{
    NSLog(@"receiveWakeNote: %@", [note name]);
    [self logEventForBundle:DEVICE_SLEEP page:nil];
}

-(void)logEventForBundle:(NSString *)bundleName page:(NSString *)pageURL{
    TSEvent *event = [TSEvent enterEventWithBundle:bundleName withPage:pageURL];
    [self.eventManager saveEventNow:event];
}

@end
