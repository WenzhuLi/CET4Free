//
//  ScoreInfo.m
//  CET4Lite
//
//  Created by Seven Lee on 12-4-18.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "ScoreInfo.h"

@implementation ScoreInfo
@synthesize  TestTime;
@synthesize  NumberOfQuestions;
@synthesize  NumberOfRight;
@synthesize  Score;
@synthesize  Date;
@synthesize  TestType;

- (id)init{
    self = [super init];
    if (self) {
        self.Score = 0.0;
        self.NumberOfRight = 0;
        self.NumberOfQuestions = 1;
        self.Date = @"";
        self.TestTime = 0;
        self.TestType = 0;
    }
    return self;
}
- (float) myCorrectRate{
    if (self.TestType < 3) 
        return [self myCorrectRateAB];
    else 
        return [self myCorrectRateC];
}
- (float) myCorrectRateAB{
    NSNumber * one = [NSNumber numberWithInteger:self.NumberOfRight];
    NSNumber * two = [NSNumber numberWithInteger:self.NumberOfQuestions];
    float rate = [one floatValue] / [two floatValue];
    return  rate;

}
- (float) myCorrectRateC{
    return self.Score / 11.0;
}
- (NSString *)myTitle{
    NSString * year = [NSString stringWithFormat:@"%d年%d月",self.TestTime / 100, self.TestTime % 100];
    NSString * sec = nil;
    switch (self.TestType) {
        case 1:
            sec = @"SectionA";
            break;
        case 2:
            sec = @"SectionB";
            break;
        case 3:
            sec = @"SectionC";
            break;
            
        default:
            sec = @"";
            break;
    }
    return [NSString stringWithFormat:@"%@ %@",year,sec];
}
@end
