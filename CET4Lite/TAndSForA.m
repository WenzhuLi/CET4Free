//
//  TAndSForA.m
//  CET4Lite
//
//  Created by Seven Lee on 12-2-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "TAndSForA.h"

@implementation TAndSForA
@synthesize Sex;

//初始化
- (id) initWithTime:(NSInteger)time String:(NSString *)string Sex:(NSString *)sex{
    if (self = [super initWithTime:time String:string]) {
        self.Sex = sex;
    }
    return self;
}
@end
