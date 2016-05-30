//
//  TXUserView.m
//  TimeSaver
//
//  Created by baidu on 16/5/29.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import "TXUserView.h"
#import "NSLabel.h"
@implementation TXUserView

-(instancetype)initWithCoder:(NSCoder *)coder{
    self=[super initWithCoder:coder];
    if(self){
        [self initSubviews];

    }
    return self;

}
-(instancetype)initWithFrame:(NSRect)frameRect{
    self=[super initWithFrame:frameRect];
    if(self){
        [self initSubviews];
    }
    return self;
}

-(void)initSubviews{
    NSLabel *label = [[NSLabel alloc]initWithFrame:NSMakeRect(0, 0, 100, 70)];
    [self addSubview:label];
    label.stringValue=@"Hello Tivo!";
}

@end
