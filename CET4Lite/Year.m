//
//  Year.m
//  CET4Lite
//
//  Created by Seven Lee on 12-2-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "Year.h"

@implementation Year

@synthesize text;
@synthesize intValue;

- (id) initWithText:(NSString *)t andInt:(NSInteger)value{
    if (self = [super init]) {
        self.text = t;
        self.intValue = value;
    }
    return self;
}
- (NSComparisonResult)compare:(Year *)year{
    NSInteger yearNumber = year.intValue / 100;
    NSInteger yearNumberSelf = self.intValue / 100;
    if (yearNumberSelf > yearNumber) {
        return NSOrderedAscending;
    }
    else if (yearNumberSelf < yearNumber){
        return NSOrderedDescending;
    }
    else{
        NSInteger monthNumber = year.intValue % 100;
        NSInteger monthNumberSelf = self.intValue % 100;
        if (monthNumberSelf > monthNumber) {
            return NSOrderedAscending;
        }
        else{
            return NSOrderedDescending;
        }
    }
}
- (NSString *) myText{
    return self.text;
}
- (NSInteger) myValue{
    return self.intValue;
}
@end
