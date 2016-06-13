//
// Created by baidu on 16/5/31.
// Copyright (c) 2016 tivo2. All rights reserved.
//

#import "TXPieChartView.h"
#import "TSEvent.h"

@interface TXPieChartView()
@property (nonatomic)NSArray *shareArray;
@property NSArray *colorList;
@property NSSize prevSize;
@property NSTrackingArea *tagDisplayTrackingArea;
@property NSPoint mouseLocation;
@property NSPoint pieCenter;
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


-(void)updateTrackingAreas{
    if (CGSizeEqualToSize(self.prevSize, self.frame.size)) {
        return;
    }
    NSRect selfRect = NSMakeRect(0, 0,self.frame.size.width,self.frame.size.height);
    self.prevSize = selfRect.size;
    if (self.tagDisplayTrackingArea!=nil) {
        [self removeTrackingArea:self.tagDisplayTrackingArea];
    }
    self.tagDisplayTrackingArea = [[NSTrackingArea alloc]initWithRect:selfRect options:NSTrackingActiveAlways|NSTrackingMouseMoved owner:self userInfo:nil];
    [self addTrackingArea:self.tagDisplayTrackingArea];
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
- (void)mouseMoved:(NSEvent *)theEvent {
    self.mouseLocation = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    [self display];
}

-(void)drawRect:(NSRect)dirtyRect {
    NSGraphicsContext *context = [NSGraphicsContext currentContext];
    CGFloat width = self.frame.size.width;
    CGFloat center = width/2;
    self.pieCenter = NSMakePoint(center, center);
    CGFloat radio = center-5;
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
        [arcPath appendBezierPathWithArcWithCenter:NSMakePoint(center,center) radius:radio startAngle:startAngle endAngle:endAngle clockwise:YES];
        startAngle = endAngle;
        [arcPath lineToPoint:NSMakePoint(center,center)];
        [arcPath closePath];
        [arcPath fill];
    }
    //note we are using the convenience method, so we don't need to autorelease the object
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica" size:22], NSFontAttributeName,[NSColor whiteColor], NSForegroundColorAttributeName,[NSColor blackColor] ,NSBackgroundColorAttributeName,nil];
    NSAttributedString * currentText=[[NSAttributedString alloc] initWithString:[self getMouseHint] attributes: attributes];
    NSSize attrSize = [currentText size];
    [currentText drawAtPoint:self.mouseLocation];
    [context restoreGraphicsState];
}
-(NSString *)getMouseHint{
    CGFloat distance =[self mouseFromCenter];
    if (distance<(self.pieCenter.x-5)) {
        CGFloat dx =self.mouseLocation.x-self.pieCenter.x;
        CGFloat dy =self.mouseLocation.y-self.pieCenter.y;

        CGFloat pos = 0;
        if (dx == 0) {
            if (dy >=0 ) {
                pos = 0;
            }else {
                pos = 0.5;
            }
        }else{
            CGFloat angle = M_PI_2 - atan(dy/dx);
            if (dx<0) {
                angle+=M_PI;
            }
            pos = angle/(M_PI*2);
        }
        NSLog(@"%f",pos);
        CGFloat base = 0;
        for (int i = 0; i < self.shareArray.count; ++i) {
            TSEvent *event = self.shareArray[i];
            base+=event.end;
            if (base>pos) {
                return event.bundleName==nil?event.pageDomain:event.bundleName;
            }
        }
        return @"cat";
    }
    return @"";
}
-(CGFloat)mouseFromCenter{
    CGFloat dx = self.mouseLocation.x - self.pieCenter.x;
    CGFloat dy = self.mouseLocation.y - self.pieCenter.y;
    return sqrt((dx*dx) + (dy*dy));
}

@end