//
//  NSView+Background.m
//  TimeSaver
//
//  Created by baidu on 16/5/28.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import "NSView+Background.h"



@implementation NSView(Background)

-(void)setBackgroundColor:(NSColor *)color{
    [self setWantsLayer:YES]; // view's backing store is using a Core Animation Layer
    CALayer *viewLayer;
    if(self.layer==nil){
        viewLayer = [CALayer layer];
    }else{
        viewLayer = self.layer;
    }
    [viewLayer setBackgroundColor:[color CGColor]]; //RGB plus Alpha Channel
    [self setLayer:viewLayer];
}
@end
