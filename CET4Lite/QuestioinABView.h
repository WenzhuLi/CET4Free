//
//  QuestioinABView.h
//  CET4Lite
//
//  Created by Seven Lee on 12-2-29.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleChoice.h"
#import "SevenLabel.h"
#import "ABCDView.h"
#import <QuartzCore/QuartzCore.h>

@protocol QuestionABViewDelegate <NSObject>

@required

- (void)PlayCurrentQuestionSound:(UIButton *)sender;

@end
//SectionAB单个题目的view
@interface QuestioinABView : UIView{
    SingleChoice * myQ;         //要表现的Question(单选)
    id<AnswerHandler> answerHandler;
    NSArray * ABCDArray;
    NSMutableArray * ABCDButtonsArray;
    id<QuestionABViewDelegate> delegate;
    UIScrollView * scroll;
    UIButton * questionBtn;
    NSArray * imgArray;
}
@property (nonatomic, strong) id<AnswerHandler> answerHandler;
@property (nonatomic, strong) id<QuestionABViewDelegate> delegate;
@property (nonatomic, strong) SingleChoice * myQ; 
//初始化
- (id)initWithFrame:(CGRect)frame andQ:(SingleChoice *)q;

//绘图
- (void)drawView;

//点Question按钮时触发的事件,播放QuestionSound
- (void)playQuestionSound;

//选择选项时触发的事件
- (void)chooseAnswer:(UITapGestureRecognizer *)sender;

//设置对错图片并将选项设为不可选
- (void)ShowRightOrWrongAndDisable;

- (void)startQuestionButtonAimation;
- (void)stopQuestionButtonAimation;
@end
