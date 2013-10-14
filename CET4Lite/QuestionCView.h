//
//  QuestionCView.h
//  CET4Lite
//
//  Created by Seven Lee on 12-3-14.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SevenLabel.h"
#import "AudioPlayerView.h"
#import "QuestioinABView.h"
#import "AnswerCSingleView.h"

@protocol QuestionCViewCollectDlegate <NSObject>

- (void) AddCurrentQuestionToFav:(NSInteger)index;

@end

@interface QuestionCView : UIView<QuestionABViewDelegate,AnswerCDelegate,UITextFieldDelegate>{
    IBOutlet UIScrollView * scrollView;
    NSArray * QuesArray;
    NSMutableArray * AnswerViewArray;
    AudioPlayerView * audioPlayer;
    id<QuestionABViewDelegate> delegate;
    id<AnswerHandler> answerHandler;
    id<QuestionCViewCollectDlegate> collectDlegate;
    NSInteger currentIndex;
}
@property (nonatomic, strong) id<AnswerHandler> answerHandler;
@property (nonatomic,strong) IBOutlet UIScrollView * scrollView;
@property (nonatomic, strong) id<QuestionABViewDelegate> delegate;
@property (nonatomic, strong) id<QuestionCViewCollectDlegate> collectDlegate;

- (NSInteger)CurrentIndex;
-(IBAction)PageChange:(UIButton *)sender;
- (id)initWithFrame:(CGRect)frame andQArray:(NSArray *)array;
- (id)initWithScroll:(UIScrollView *)scroll andQArray:(NSArray *)array;
- (void)rollToIndex:(NSInteger)index;
- (void)willDisappear;
- (void)willappear;
- (NSString *)CurrentCustomAnswer;
- (void)showRightOrWrongAndDisable;
@end
