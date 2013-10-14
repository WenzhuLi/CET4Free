//
//  Question.h
//  CET4Lite
//
//  Created by Seven Lee on 12-2-27.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AnswerHandler <NSObject>

@required
- (void) restoreCustomAnswer:(NSString *)answer ofNumber:(NSInteger)number;
@optional
- (void) CurrentIndexChanged:(NSInteger)nowIndex;
@end

//单个问题的父类，要子类来继承
@interface Question : NSObject{
    NSString * question;        //问题
    NSString * answer;          //答案
    NSInteger Year;             //年份
    NSInteger Number;           //题号
    NSString * audio;           //题目的音频文件名
    NSString * YourAnswer;        //用户填的答案
    NSString * QuestionSound;               //Question的发音文件名
}
@property (nonatomic, strong) NSString * question;
@property (nonatomic, strong) NSString * answer;          
@property (assign) NSInteger Year;             
@property (assign) NSInteger Number;           
@property (nonatomic, strong) NSString * audio;
@property (nonatomic, strong) NSString * YourAnswer;
@property (nonatomic, strong) NSString * QuestionSound;

- (float) GiveMeTheScore; //根据答案计算成绩，子类重写
@end
