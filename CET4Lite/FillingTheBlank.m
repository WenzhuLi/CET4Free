//
//  FillingTheBlank.m
//  CET4Lite
//
//  Created by Seven Lee on 12-2-27.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "FillingTheBlank.h"

@implementation FillingTheBlank

@synthesize keywords;

- (float)GiveMeTheScore{
    if (self.YourAnswer == nil) {
        return 0;
    }
    NSString * customAnswer = [[[self.YourAnswer componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""] lowercaseString];
    NSString * rightAnswer = [[[self.answer componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""] lowercaseString];
    NSLog(@"customAnswer:%@",customAnswer);
    NSLog(@"rightAnswer:%@",rightAnswer);
    //keywords数组为NULL，证明为单词填空，完全相同给1分，不对给0分
    if (!self.keywords) {
        if ([customAnswer compare:rightAnswer] == NSOrderedSame)
            return 1;
        else
            return 0;
    }
    
    else {
        //keywords数组不为NULL，证明为长句填空，每含有一个关键词给1/3分
        float result = 0;
        float correct = 0;
        for (int i = 0; i < kNumberofKeywords ; i++) {
            NSString * keyword = [self.keywords objectAtIndex:i];
            if ( keyword && keyword.length > 0) {
                keyword = [[[keyword componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] componentsJoinedByString:@""] lowercaseString];
                NSLog(@"keyword %d : %@",i,keyword);
                if ([customAnswer rangeOfString:keyword options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    correct += 1.0;
                    result = correct / (i + 1);
                }
            }
            
        }
        return result;
    }
}

@end
