//
//  ScoreInfo.h
//  CET4Lite
//
//  Created by Seven Lee on 12-4-18.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreInfo : NSObject{
    NSInteger TestTime;
    NSInteger NumberOfQuestions;
    NSInteger NumberOfRight;
    float Score;
    NSString * Date;
    NSInteger TestType;
}
@property (nonatomic, assign) NSInteger TestTime;
@property (nonatomic, assign) NSInteger NumberOfQuestions;
@property (nonatomic, assign) NSInteger NumberOfRight;
@property (nonatomic, assign) float Score;
@property (nonatomic, strong) NSString * Date;
@property (nonatomic, assign) NSInteger TestType;

- (float) myCorrectRate;
- (float) myCorrectRateAB;
- (float) myCorrectRateC;
- (NSString *)myTitle;
@end
