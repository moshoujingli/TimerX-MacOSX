//
//  MainContentViewController.m
//  TimeSaver
//
//  Created by baidu on 16/5/27.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import "MainContentViewController.h"
#import "TXUserConfig.h"

@interface MainContentViewController ()

@end

@implementation MainContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.tabStyle = NSTabViewControllerTabStyleUnspecified;
    [self.tabView setFrameSize:NSMakeSize(720, 540)];
    
}

-(void)viewWillAppear{
    [[TXUserConfig sharedConfig]addObserver:self forKeyPath:@"currentUserFunctionTab" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
    [TXUserConfig sharedConfig].currentUserFunctionTab = 1;

}

-(void)viewWillDisappear{
    [[TXUserConfig sharedConfig]removeObserver:self forKeyPath:@"currentUserFunctionTab"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    NSInteger tabIndex = [(NSNumber *)[change objectForKey:@"new"] integerValue];
    [self.tabView selectTabViewItemAtIndex:tabIndex];
}

@end
