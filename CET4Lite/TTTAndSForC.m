//
//  TTTAndSForC.m
//  CET4Lite
//
//  Created by Seven Lee on 12-3-1.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "TTTAndSForC.h"

@implementation TTTAndSForC
@synthesize Times;
@synthesize Qwords;

- (id)initWithTime:(NSArray *)times String:(NSString *)string{
    if (self = [super initWithTime:0 String:string]) {
        Times = times;
        Qwords = 0;
    }
    return self;
}
- (NSString *)description{
    return [[super description] stringByAppendingFormat:@"\nTiming1:%d\nTiming2:%d\nTiming3:%d\nQwords:%d",[Times objectAtIndex:0],[Times objectAtIndex:1],[Times objectAtIndex:2],Qwords];
}
@end
