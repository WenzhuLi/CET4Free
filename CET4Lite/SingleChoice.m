//
//  SingleChoice.m
//  CET4Lite
//
//  Created by Seven Lee on 12-2-27.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "SingleChoice.h"

@implementation SingleChoice

@synthesize ForChoices;


- (id)init{
    if (self = [super init]) {
        self.ForChoices = NULL;
        self.QuestionSound = nil;
    }
    return self;
}
- (float) GiveMeTheScore{
    if (self.YourAnswer == nil) {
        return 0;
    }
    //答对给一分，答错给0分
    if ([self.answer compare:YourAnswer] == NSOrderedSame) 
        return 1.0;
    else 
        return 0;
}
-(NSString  *)description{
    NSString * des = [super description];
    return [des stringByAppendingFormat:@"ForChoices:\nA:%@\nB:%@\nC:%@\nD:%@\nQuestionSound:%@",[self.ForChoices objectAtIndex:0],[self.ForChoices objectAtIndex:1], [self.ForChoices objectAtIndex:2],[self.ForChoices objectAtIndex:3],self.QuestionSound];
}
@end
