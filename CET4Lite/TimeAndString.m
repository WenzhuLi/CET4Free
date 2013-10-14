//
//  TimeAndString.m
//  CET4Lite
//
//  Created by Seven Lee on 12-2-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "TimeAndString.h"

@implementation TimeAndString
@synthesize Time;
@synthesize String;

//初始化
- (id) initWithTime:(NSInteger)time String:(NSString *)string{
    if (self = [super init]) {
        self.Time = time;
        self.String = string;
    }
    return self;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"=======\nTime:%d\nString:%@",Time,String];
}
@end
