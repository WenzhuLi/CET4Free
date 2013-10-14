//
//  Question.m
//  CET4Lite
//
//  Created by Seven Lee on 12-2-27.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "Question.h"

@implementation Question

@synthesize question;
@synthesize answer;
@synthesize audio;
@synthesize Year;
@synthesize Number;
@synthesize YourAnswer;
@synthesize QuestionSound;

- (id)init{
    if (self = [super init]) {
        self.question = nil;
        self.audio = nil;
        self.Year = 201112;
        self.Number = 11;
        self.YourAnswer = nil;
    }
    return self;
}
- (float) GiveMeTheScore{
    return 0;
}
- (NSString *)description{

    return [NSString stringWithFormat:@"===========\nquestion:%@\nanswer:%@\naudio:%@\nYear:%d\nNumber:%d\n",self.question,self.answer,self.audio,self.Year,self.Number];
}
@end
