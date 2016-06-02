//
// Created by baidu on 16/5/31.
// Copyright (c) 2016 tivo2. All rights reserved.
//

#import "TXPieChartView.h"
#import "TSEvent.h"

@interface TXPieChartView()
@property (nonatomic)NSArray *shareArray;
@property NSArray *colorList;
@end

@implementation TXPieChartView
@synthesize eventList = _eventList;
@synthesize shareArray = _shareArray;

-(NSArray *)shareArray {
    if(_shareArray==nil){
        _shareArray = [[NSArray alloc] init];
    }
    return _shareArray;
}


-(void)setEventList:(NSArray *)eventList {
    _eventList = eventList;

    if(eventList.count==0){
        [self stateNoContent];
    }else{
        NSMutableArray *shareDic = [[NSMutableArray alloc] initWithCapacity:eventList.count];
        self.shareArray = shareDic;
        double sum = 0;
        for(TSEvent * event in eventList){
            sum+= event.end;
        }
        if(sum==0){
            [self stateNoContent];
            return;
        }
        for(TSEvent * event in eventList){
            TSEvent *shareEvent = [[TSEvent alloc]init];
            shareEvent.bundleName = event.bundleName;
            shareEvent.pageDomain = event.pageDomain;
            shareEvent.end = event.end/sum;
            [shareDic addObject:shareEvent];
        }
    }
    [self display];
}

-(instancetype)init{
    self = [super init];
    if (self!=nil){
        self.colorList = @[[NSColor blackColor], [NSColor darkGrayColor], [NSColor lightGrayColor],
                [NSColor whiteColor], [NSColor grayColor], [NSColor redColor], [NSColor greenColor],
                [NSColor blueColor], [NSColor cyanColor], [NSColor yellowColor], [NSColor magentaColor],
                [NSColor orangeColor], [NSColor purpleColor], [NSColor brownColor]];
    }
    return self;
}

- (void)stateNoContent {

}


-(void)drawRect:(NSRect)dirtyRect {
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    NSLog(NSStringFromSize(self.frame.size));
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    [context saveGraphicsState];
    //
    NSBezierPath*   arcPath = [NSBezierPath bezierPath];
    CGFloat startAngle = 90;
    CGFloat endAngle;
    for (int i = 0; i < self.shareArray.count; ++i) {
        NSColor *colorFill = nil;
        TSEvent *event = self.shareArray[i];
        if (i>=self.colorList.count){
            colorFill = self.colorList.lastObject;
        }else{
            colorFill = self.colorList[i];
        }
        [colorFill setFill];
        [arcPath removeAllPoints];
        endAngle = startAngle-event.end*360.0f;
        [arcPath appendBezierPathWithArcWithCenter:NSMakePoint(50,50) radius:45 startAngle:startAngle endAngle:endAngle clockwise:YES];
        startAngle = endAngle;
        [arcPath lineToPoint:NSMakePoint(50,50)];
        [arcPath closePath];
        [arcPath fill];
    }
    [context restoreGraphicsState];
}


@end