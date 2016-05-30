//
//  NSLabel.m
//  TimeSaver
//
//  Created by baidu on 16/5/27.
//  Copyright © 2016年 tivo2. All rights reserved.
//

#import "NSLabel.h"

@implementation NSLabel

-(instancetype)init{
    self = [super init];
    if(self!=nil){
        [self initProperties];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)coder{
    self = [super initWithCoder:coder];
    if(self!=nil){
        [self initProperties];
    }
    return self;
}

-(instancetype)initWithFrame:(NSRect)frameRect{
    self = [super initWithFrame:frameRect];
    if(self!=nil){
        [self initProperties];
    }
    return self;
}

-(void)initProperties{
    self.drawsBackground = NO; // 背景無し
    self.bordered = NO;        // 外枠無し
    self.editable = NO;        // 編集不可
    self.selectable = NO;      // 選択不可
}
@end
